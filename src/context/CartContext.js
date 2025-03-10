// CartContext.js
import React, { createContext, useContext, useReducer, useEffect } from 'react';
import AsyncStorage from '@react-native-async-storage/async-storage';

// Create a context for the cart
const CartContext = createContext();

// Initial state
const initialState = {
  items: [],
};

// Reducer function to manage cart state
const cartReducer = (state, action) => {
  switch (action.type) {
    case 'LOAD_CART':
      return { ...state, items: action.payload };
    case 'ADD_ITEM':
      return { ...state, items: [...state.items, action.payload] };
    case 'REMOVE_ITEM':
      return {
        ...state,
        items: state.items.filter(item => item.ReportNo !== action.payload.ReportNo || item.PackageId !== action.payload.PackageId),
      };
    case 'CLEAR_CART':
      return { ...state, items: [] };
    default:
      return state;
  }
};

// Provider component
export const CartProvider = ({ children }) => {
  const [state, dispatch] = useReducer(cartReducer, initialState);

  // Load cart from AsyncStorage on mount
  useEffect(() => {
    const loadCart = async () => {
      const savedCart = await AsyncStorage.getItem('@cart_items');
      if (savedCart) {
        const parsedCart = JSON.parse(savedCart);
        dispatch({ type: 'LOAD_CART', payload: parsedCart });
      }
    };
    loadCart();
  }, []);

  // Save cart to AsyncStorage whenever it changes
  useEffect(() => {
    const saveCart = async () => {
      await AsyncStorage.setItem('@cart_items', JSON.stringify(state.items));
    };
    saveCart();
  }, [state.items]);

  return (
    <CartContext.Provider value={{ state, dispatch }}>
      {children}
    </CartContext.Provider>
  );
};

// Custom hook to use the Cart context
export const useCart = () => {
  return useContext(CartContext);
};