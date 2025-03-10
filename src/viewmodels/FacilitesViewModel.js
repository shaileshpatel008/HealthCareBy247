import { useState } from 'react';
import FacilitesModel from '../models/FacilitesModel';

const useFacilitesViewModel = () => {
  const [facilites, setTest] = useState([
    new FacilitesModel('1', 'Lorem Ipsum is simply dummy text', 'Lorem Ipsum is simply dummy text of the \n printing and typesetting industry.'),
    new FacilitesModel('2', 'Lorem Ipsum is simply dummy text', 'Lorem Ipsum is simply dummy text of the \n printing and typesetting industry.'),
    new FacilitesModel('3', 'Lorem Ipsum is simply dummy text', 'Lorem Ipsum is simply dummy text of the \n printing and typesetting industry.'),
    new FacilitesModel('4', 'Lorem Ipsum is simply dummy text', 'Lorem Ipsum is simply dummy text of the \n printing and typesetting industry.'),
    new FacilitesModel('5','Lorem Ipsum is simply dummy text', 'Lorem Ipsum is simply dummy text of the \n printing and typesetting industry.'),
  ]);
  

  const toggleAddRemove = (id) => {
    setFacilites((prevFacilites) =>
      prevFacilites.map((obj) =>
        obj.id === id ? { ...obj, added: !obj.added } : obj
      )
    );
  };

  return { facilites, toggleAddRemove };
};

export default useFacilitesViewModel;