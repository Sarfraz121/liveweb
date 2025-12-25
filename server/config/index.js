import dotenv from 'dotenv';
import { RETRYABLE_STATUS_CODES, RETRY_DELAY_BASE } from './constants.js';

// Load environment variables
dotenv.config();

export const PORT = process.env.PORT || 3001;  // Changed from 3000 to avoid conflict with latoxicatst-frontend
export const GEMINI_API_KEY = process.env.GEMINI_API_KEY;

// Re-export constants for convenience
export { GEMINI_MODEL, GEMINI_TEMPERATURE, GEMINI_MAX_RETRIES } from './constants.js';
export { RETRYABLE_STATUS_CODES, RETRY_DELAY_BASE } from './constants.js';

// Validate required environment variables
if (!GEMINI_API_KEY) {
  console.warn('⚠️  WARNING: GEMINI_API_KEY not found in environment variables');
  console.warn('   Create a .env file with GEMINI_API_KEY=your_key');
}
