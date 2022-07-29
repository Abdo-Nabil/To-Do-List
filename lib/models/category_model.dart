import 'package:to_do_list/services/id_generator.dart';

class CategoryModel {
  final String id; //the id will generated using UUID
  final String categoryName;

  const CategoryModel({
    required this.id,
    required this.categoryName,
  });

  static CategoryModel allCategories =
      CategoryModel(id: IdGenerator.getId(), categoryName: 'All Categories');

  static List getDefaultCategories() {
    return [
      CategoryModel(id: IdGenerator.getId(), categoryName: 'Default'),
      CategoryModel(id: IdGenerator.getId(), categoryName: 'Personal'),
      CategoryModel(id: IdGenerator.getId(), categoryName: 'Shopping'),
      CategoryModel(id: IdGenerator.getId(), categoryName: 'Wish list'),
      CategoryModel(id: IdGenerator.getId(), categoryName: 'Work'),
    ];
  }

  static String getDefaultCategory =
      CategoryModel.getDefaultCategories()[0].categoryName;

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return new CategoryModel(
      id: map['id'] as String,
      categoryName: map['categoryName'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'id': this.id,
      'categoryName': this.categoryName,
    } as Map<String, dynamic>;
  }
//ToDo: implement == and hashcodes in all classes !?
  /* @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          categoryName == other.categoryName;

  @override
  int get hashCode => id.hashCode ^ categoryName.hashCode;*/
}
