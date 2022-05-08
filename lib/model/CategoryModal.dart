class CategoryModal {
  String? image;
  String? category;

  CategoryModal({this.image, this.category});

  CategoryModal.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['category'] = this.category;
    return data;
  }
}