import express from 'express';
import path from 'path';
import { fileURLToPath } from 'url';
import fs from 'fs';
import { corsMiddleware } from './middleware/cors.js';
import routes from './routes/index.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();

// Middleware
app.use(corsMiddleware);
app.use(express.json({ limit: '10mb' }));

// Health check route (before static files)
app.get('/health', (req, res) => {
  res.json({ 
    status: 'healthy',
    timestamp: new Date().toISOString()
  });
});

// API Routes - mount at /api explicitly
app.use('/api', routes);

// Serve static files from frontend/dist in production
// The frontend/dist is packaged INSIDE the Docker image by the Dockerfile
if (process.env.NODE_ENV === 'production') {
  // Use absolute path from app root (/app) - process.cwd() should be /app in Docker
  const frontendDistPath = path.join(process.cwd(), 'frontend', 'dist');
  
  // Verify path exists and log for debugging
  if (fs.existsSync(frontendDistPath)) {
    console.log(`✅ Serving frontend from: ${frontendDistPath}`);
    
    // IMPORTANTE: Orden correcto de middleware:
    // 1. Primero servir archivos estáticos (JS, CSS, imágenes, etc.)
    app.use(express.static(frontendDistPath));
    
    // 2. CRÍTICO: SPA Fallback - debe ir DESPUÉS de las rutas de API y archivos estáticos
    // Esto maneja rutas como /perfil, /dashboard, etc. que son rutas del frontend
    // Si el usuario entra directamente a /perfil o recarga la página, 
    // Node.js no encontrará esa ruta de API, así que devuelve index.html
    // y deja que React/Vue maneje el routing del lado del cliente
    app.get('*', (req, res) => {
      // No reenviar requests de API que fallaron
      if (req.path.startsWith('/api')) {
        return res.status(404).json({ error: 'Not Found' });
      }
      // No reenviar health check
      if (req.path.startsWith('/health')) {
        return res.status(404).json({ error: 'Not Found' });
      }
      // Para cualquier otra ruta, devolver index.html (SPA fallback)
      res.sendFile(path.join(frontendDistPath, 'index.html'));
    });
  } else {
    console.error(`❌ Frontend dist not found at: ${frontendDistPath}`);
    console.error(`   Current working directory: ${process.cwd()}`);
    console.error(`   This should not happen if the Docker image was built correctly.`);
  }
} else {
  // In development, mount API routes at root for backward compatibility
  app.use('/', routes);
}

export default app;
