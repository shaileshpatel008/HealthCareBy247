import axios from 'axios';

// Setup axios instance
const apiClient = axios.create({
  baseURL: 'https://healthcare24x7.com/api', // Base URL for API
  timeout: 50000,
});

// Response Handler Function
const handleResponse = (response) => {
  if (response.status >= 200 && response.status < 300) {
    return { success: true, data: response.data };
  } else {
    return { success: false, error: 'Something went wrong' };
  }
};

// Error Handler Function
const handleError = (error) => {
  console.error('API Error:', error.errorMessage || error);
  let errorMessage = 'An unexpected error occurred';

  if (error.response) {
    // Server-side error
    errorMessage = error.response.data.message || error.response.statusText;
  } else if (error.request) {
    // Request was made, but no response was received
    errorMessage = 'Network Error: Request made, no response received';

  } else {
    errorMessage = 'Error: ' + error.message; // Capture other errors
  }


  return { success: false, error: errorMessage };
};

// Common API request functions
const get = async (url, params = {}) => {
  try {
    const response = await apiClient.get(url, { params });
    return handleResponse(response);
  } catch (error) {
    return handleError(error);
  }
};
const post = async (url, data = {}) => {
  try {
    console.log("Post Request:",url);
    const response = await apiClient.post(url, data);
    return handleResponse(response);
  } catch (error) {
    return handleError(error);
  }
};
// Export API methods
export const api = {
  get,post,
};