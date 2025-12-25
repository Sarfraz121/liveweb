// API Base URL - uses environment variable in production, localhost in development
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 
                     (import.meta.env.PROD ? window.location.origin : 'http://localhost:3000');

import i18n from '../i18n';

/**
 * Generate code using Gemini 3 Flash API
 * @param {string} prompt - User's voice command or text prompt
 * @param {string} currentCode - Current HTML code to modify
 * @returns {Promise<{code: string, success: boolean}>}
 */
export const generateCode = async (prompt, currentCode = '', pageId = null, templateId = null, selectedComponent = null) => {
  const controller = new AbortController();
  const timeoutId = setTimeout(() => controller.abort(), 90000); // 90 second timeout (increased for longer Gemini responses)

  try {
    const response = await fetch(`${API_BASE_URL}/api/generate`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        prompt,
        currentCode,
        pageId,
        templateId,
        selectedComponent,
      }),
      signal: controller.signal,
    });

    clearTimeout(timeoutId);

    if (!response.ok) {
      const errorData = await response.json().catch(() => ({}));
      throw new Error(errorData.error || `HTTP error! status: ${response.status}`);
    }

    const data = await response.json();
    return {
      code: data.code,
      success: true,
      pageId: data.pageId || null,
      checkpointId: data.checkpointId || null,
      detectedAPIs: data.detectedAPIs || [],
      metadata: data.metadata || null
    };
  } catch (error) {
    clearTimeout(timeoutId);

    if (error.name === 'AbortError') {
      throw new Error(i18n.t('errors.timeout'));
    }

    if (error.message.includes('Failed to fetch') || error.message.includes('NetworkError')) {
      throw new Error(i18n.t('errors.networkError'));
    }

    throw error;
  }
};

/**
 * Health check to verify backend is running
 * @returns {Promise<boolean>}
 */
export const checkBackendHealth = async () => {
  try {
    const response = await fetch(`${API_BASE_URL}/health`, {
      method: 'GET',
      signal: AbortSignal.timeout(5000), // 5 second timeout
    });
    return response.ok;
  } catch (error) {
    return false;
  }
};

/**
 * Get checkpoints for a page
 * @param {string} pageId - Page ID
 * @returns {Promise<{checkpoints: Array}>}
 */
export const getCheckpoints = async (pageId) => {
  try {
    const response = await fetch(`${API_BASE_URL}/api/checkpoints/${pageId}`, {
      method: 'GET',
    });

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    const data = await response.json();
    return data;
  } catch (error) {
    console.error('Error fetching checkpoints:', error);
    throw error;
  }
};

/**
 * Get code for a specific checkpoint
 * @param {string} pageId - Page ID
 * @param {string} checkpointId - Checkpoint ID
 * @returns {Promise<{code: string, checkpoint: Object}>}
 */
export const getCheckpointCode = async (pageId, checkpointId) => {
  try {
    const response = await fetch(`${API_BASE_URL}/api/checkpoints/${pageId}/${checkpointId}`, {
      method: 'GET',
    });

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    const data = await response.json();
    return data;
  } catch (error) {
    console.error('Error fetching checkpoint code:', error);
    throw error;
  }
};

/**
 * Get all available templates
 * @returns {Promise<{templates: Array}>}
 */
export const getTemplates = async () => {
  try {
    const response = await fetch(`${API_BASE_URL}/api/templates`, {
      method: 'GET',
    });

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    const data = await response.json();
    return data;
  } catch (error) {
    console.error('Error fetching templates:', error);
    throw error;
  }
};

/**
 * Get specific template by ID
 * @param {string} templateId - Template ID
 * @returns {Promise<{id: string, name: string, description: string, code: string}>}
 */
export const getTemplate = async (templateId) => {
  try {
    const response = await fetch(`${API_BASE_URL}/api/templates/${templateId}`, {
      method: 'GET',
    });

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    const data = await response.json();
    return data;
  } catch (error) {
    console.error('Error fetching template:', error);
    throw error;
  }
};

/**
 * Get all available API configurations
 * @returns {Promise<{apis: Array}>}
 */
export const getAvailableAPIs = async () => {
  try {
    const response = await fetch(`${API_BASE_URL}/api/apis`, {
      method: 'GET',
    });

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    const data = await response.json();
    return data;
  } catch (error) {
    console.error('Error fetching APIs:', error);
    throw error;
  }
};
