import { api } from '../utils/ApiService/api'; // Import the common API module

// Fetch App Config Data from API
const getAppConfig = async () => {
  const response = await api.get('/sysConfig.php'); // Endpoint for fetching config
  
  if (response.success) {
    console.log("Api Response:",response.data);
    return response.data[0]; // Return the first config object (assuming it's an array)
  } else {
    throw new Error(response.error); // Throw error if API call failed
  }
};

export const configModel = {
  getAppConfig,
};