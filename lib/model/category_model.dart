class CategoryModel{
  final int categoryId;
  final String categoryName;
  final String categoryImage;

  CategoryModel({
    required this.categoryId,
    required this.categoryImage,
    required this.categoryName
  });

  Map<String, dynamic> toMap(){
    final result = <String, dynamic>{};
    result.addAll({'id': categoryId});
    result.addAll({'name': categoryName});
    result.addAll({'image': categoryImage});

    return result;
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map){
    return CategoryModel(
      categoryId: map['id'] ?? '', 
      categoryImage: map['image'] ?? '', 
      categoryName: map['name'] ?? ''
    );
  }
}