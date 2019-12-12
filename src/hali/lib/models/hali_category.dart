class HCategory {
  final int id;
  final String categoryName;

  HCategory(this.id, this.categoryName);

  static List<HCategory> generated() {
    return [new HCategory(1, "Thực Phẩm"), new HCategory(2, "Đồ Dùng Khác Thực Phẩm")];
  }
}