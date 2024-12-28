// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:loginpage/files/model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';
// import 'package:path/path.dart';

ValueNotifier<List<StudentModel>> studentListNotifier = ValueNotifier([]);

late Database _db;
//Database open cheyyan ulle function/Initialise cheyyan ulle function
Future<void> initialiseDataBase() async {
  _db = await openDatabase(
    'student.db',
    version:
        1, //student.db ennule name il aahn save cheyyandeth or folder il um store cheyyam
    onCreate: (Database db, int version) async {
      await db.execute(
        'CREATE TABLE student (id INTEGER PRIMARY KEY, name TEXT, age TEXT, photo TEXT, phone TEXT, address TEXT)',
      );
    },
  );
}

Future<void> addStudent(StudentModel value) async {
  {
    await _db.rawInsert(
      'INSERT INTO student(name,age,photo,phone,address) VALUES(?,?,?,?,?)',
      [value.name, value.age, value.photo, value.phone, value.address],
    );
    await getAllStudents(); // This already notifies listeners
  }
}

Future<void> getAllStudents() async {
  final values = await _db.rawQuery('SELECT * FROM student');
  // print(_values);
  studentListNotifier.value.clear();
  // _values.forEach((map) {
  for (var value in values) {
    final student = StudentModel.fromMap(value);
    studentListNotifier.value.add(student);
  }
  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
  studentListNotifier.notifyListeners();
}

Future<void> deleteStudent(int id) async {
  await _db.rawDelete('DELETE FROM student WHERE id = ?', [id]);
  getAllStudents();
}

Future<void> updateStudent(StudentModel value) async {
  await _db.rawUpdate(
    'UPDATE student SET name = ?,age = ?,photo = ? ,phone = ?,address = ? WHERE id = ?',
    [value.name, value.age, value.photo, value.phone, value.address, value.id],
  );

  await getAllStudents();
}

Future<void> printAllStudent() async {
  final values = await _db.rawQuery('SELECT * FROM student');
  for (var value in values) {
    log(value.toString());
  }
}

Future<void> searchingStudent(String value) async {
  final students = await _db.query(
    'student',
    where: 'LOWER(name) LIKE ?',
    whereArgs: ['%${value.toLowerCase()}%'],
  );
  studentListNotifier.value =
      students.map((element) => StudentModel.fromMap(element)).toList();
}