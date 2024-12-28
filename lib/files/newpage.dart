import 'package:flutter/material.dart';
import 'package:loginpage/files/addstudent.dart';
import 'package:loginpage/files/dbfunctions.dart';
import 'package:loginpage/files/grid_student_widget.dart';
import 'package:loginpage/files/list_student_widget.dart';

class NewScreen extends StatelessWidget {
  const NewScreen({super.key});

  @override
  Widget build(BuildContext context) {
     TextEditingController searchcontroller = TextEditingController();
    getAllStudents();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.blueGrey,
          title: const Text(
            'Student Details',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                controller: searchcontroller,
                onChanged: (value) {
                  searchingStudent(value);
                },
                
                decoration: const InputDecoration(
                    hintText: 'search',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.search)),
              ),
            ),
            const TabBar(tabs: [
              Tab(
                icon: Icon(Icons.list),
              ),
              Tab(
                icon: Icon(Icons.grid_view),
              )
            ]),
            const Expanded(
              child: TabBarView(
                  children: [ListStudentWidget(), GridStudentWidget()]),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddStudentWidget()));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
