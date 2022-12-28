class Models {
  final int? id;
  final String title;
  final int age;
  final String description;

  Models({
    this.id,
    required this.title,
    required this.age,
    required this.description,
  });

  Models.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        age = map['age'],
        description = map['description'];

  Map<String, Object?> toMap() {
    return {'id': id, 'title': title, 'age': age, 'description': description};
  }
}
