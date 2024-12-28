class StudentModel {
  final int? id;

  final String name;
  final String age;
  final String photo;
  final String phone;
  final String address;

  StudentModel(
      {required this.name, required this.age, this.id, required this.photo,required this.phone,required this.address});
  static StudentModel fromMap(Map<String, Object?> map) {
    final id = map['id'] as int;
    final name = map['name'] as String;
    final age = map['age'] as String;
    final photo = map['photo'] as String;
    final phone = map['phone'] as String;
    final address = map['address'] as String;

    return StudentModel(id: id, name: name, age: age, photo: photo,phone:phone,address:address);
  }
}
