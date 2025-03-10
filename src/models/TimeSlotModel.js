// TimeSlotModel.js
class TimeSlotModel {
  constructor(data) {
    this.timeSlots = data.map(item => ({
      timeSlotID: item.TimeSlotID,
      slot: item.Slot,
    }));
  }

  getTimeSlots() {
    return this.timeSlots;
  }

  getTimeSlotById(id) {
    return this.timeSlots.find(slot => slot.timeSlotID === id);
  }
}

export default TimeSlotModel;