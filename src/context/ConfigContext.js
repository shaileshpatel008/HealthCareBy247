import React, { createContext, useState, useContext } from 'react';

// Create a Context for configuration data
const ConfigContext = createContext();

// Create a custom hook to use the ConfigContext
export const useConfig = () => {
  return useContext(ConfigContext);
};

// Create the provider for the config context
export const ConfigProvider = ({ children }) => {
  const [cartItems, setCartItems] = useState([]);
  const [config, setConfig] = useState([String]);

  // Function to update the config data
  const updateConfig = (newConfig) => {
    // console.log("Config",newConfig);
    setConfig(newConfig);
  };

  return (
    <ConfigContext.Provider value={{ config, updateConfig }}>
      {children}
    </ConfigContext.Provider>
  );
};