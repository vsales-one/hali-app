class HCategory {
  final int id;
  final String categoryName;

  HCategory(this.id, this.categoryName);

  static List<HCategory> generated() {
    return [new HCategory(1, "FOOD"), new HCategory(2, "NON-FOOD")];
  }
}