import { useState, useEffect } from 'react';
import TimeSlotModel from '../models/TimeSlotModel';

const useTimeSlotViewModel = (data) => {
  const [timeSlots, setTimeSlots] = useState([]);
  const [selectedTimeSlot, setSelectedTimeSlot] = useState(null);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const model = new TimeSlotModel(data);
    setTimeSlots(model.getTimeSlots());
    setIsLoading(false);
  }, [data]);

  const selectTimeSlot = (timeSlotID) => {
    const model = new TimeSlotModel(data);
    const slot = model.getTimeSlotById(timeSlotID);
    setSelectedTimeSlot(slot);
  };

  return {
    timeSlots,
    selectedTimeSlot,
    selectTimeSlot,
    isLoading,
  };
};

export default useTimeSlotViewModel;

export class TimeSlot {
  constructor(id, slot) {
    this.TimeSlotID = id;
    this.Slot = slot;
  }
}