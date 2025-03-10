export default class TestModel {
    constructor(id, name, price, added = false) {
      this.id = id;
      this.name = name;
      this.price = price;
      this.added = added;
    }
  }