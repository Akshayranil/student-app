import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loginpage/files/dbfunctions.dart';
import 'package:loginpage/files/model.dart';
import 'package:loginpage/files/updatestudent.dart';

class GridStudentWidget extends StatelessWidget {
  const GridStudentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    getAllStudents();
    return ValueListenableBuilder(
      valueListenable: studentListNotifier,
      builder:
          (BuildContext ctx, List<StudentModel> studentList, Widget? child) {
        if (studentList.isEmpty) {
          return const Center(
            child: Text('Add student'),
          );
        }
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
          itemBuilder: (context, index) {
            final data = studentList[index];
            return InkWell(
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context)=>AboutStudent(data: data)));
              },
              child: Card(
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: FileImage(File(data.photo)),
                      radius: 40,
                    ),
                    Text(data.name),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(
                                          'Are you sure want to update'),
                                      actions: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton(
                                                onPressed: () {
                                                   Navigator.pushReplacement(
                                                   context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                        UpdateStudent(
                                                           data: data,
                                                              )));
                                                },
                                                child: const Text('yes')),
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('No'))
                                          ],
                                        ),
                                      ],
                                    );
                                  });
                            },
                            icon: const Icon(Icons.edit)),
                        IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                        'Are you sure want to delete'),
                                    actions: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextButton(
                                              onPressed: () {
                                                deleteStudent(data.id!);
                                                Navigator.pop(context);
                                              },
                                              child: const Text('yes')),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('No'))
                                        ],
                                      ),
                                    ],
                                  );
                                });
                          },
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          },
          itemCount: studentList.length,
        );
      },
    );
  }
}
