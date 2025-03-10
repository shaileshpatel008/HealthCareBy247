export default class PackageModel {
    constructor(id, name, price, originalPrice, added = false) {
      this.id = id;
      this.name = name;
      this.price = price;
      this.originalPrice = originalPrice;
      this.added = added;
    }
  }