import { useState } from 'react';
import TestModel from '../models/TestModel';

const useTestViewModel = () => {
  const [test, setTest] = useState([
    new TestModel('1', 'Advanced Fever Panel', 1499  ),
    new TestModel('2', 'Complete Body Checkup', 2999),
    new TestModel('3', 'Heart Care Package', 3499),
    new TestModel('4', 'ANA PROFILE (IMMUNO BLOT)', 2499),
    new TestModel('5', 'CRP (QUANTITATIVE)', 1200),
    new TestModel('5', 'TROPONIN-T QUALITATIVE', 1499),
  ]);
  

  const toggleAddRemove = (id) => {
    setTest((prevTest) =>
      prevTest.map((obj) =>
        obj.id === id ? { ...obj, added: !obj.added } : obj
      )
    );
  };

  return { test, toggleAddRemove };
};

export default useTestViewModel;