import cors from 'cors';

// CORS configuration - supports multiple origins and production/development
const getCorsOrigin = () => {
  const corsOrigin = process.env.CORS_ORIGIN;
  if (!corsOrigin) {
    return process.env.NODE_ENV === 'production' 
      ? true // Allow all origins in production (use Nginx for security)
      : 'http://localhost:5173'; // Development default
  }
  
  // Support comma-separated origins
  if (corsOrigin.includes(',')) {
    return corsOrigin.split(',').map(origin => origin.trim());
  }
  
  return corsOrigin;
};

export const corsMiddleware = cors({
  origin: getCorsOrigin(),
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
});
