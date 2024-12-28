import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loginpage/files/dbfunctions.dart';
import 'package:loginpage/files/model.dart';

class UpdateStudent extends StatefulWidget {
  final StudentModel data;

  const UpdateStudent({Key? key, required this.data}) : super(key: key);

  @override
  
  _UpdateStudentState createState() => _UpdateStudentState();
}

class _UpdateStudentState extends State<UpdateStudent> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  String? image;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.data.name);
    _ageController = TextEditingController(text: widget.data.age);
    _phoneController = TextEditingController(text: widget.data.phone);
    _addressController = TextEditingController(text: widget.data.address);
    image = widget.data.photo;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> updateStudentDetails() async {
    if (_formKey.currentState!.validate() && _imageValidation()) {
      final updatedStudent = StudentModel(
        id: widget.data.id,
        name: _nameController.text.trim(),
        age: _ageController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        photo: image!,
      );
      await updateStudent(updatedStudent);
      Navigator.pop(context);
    }
  }

  Future<void> galleryImage() async {
    final imageTaken = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageTaken != null) {
      setState(() {
        image = imageTaken.path;
      });
    }
  }

  Future<void> cameraImage() async {
    final imageTaken = await ImagePicker().pickImage(source: ImageSource.camera);
    if (imageTaken != null) {
      setState(() {
        image = imageTaken.path;
      });
    }
  }

  bool _imageValidation() {
    if (image == null || image!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select an image',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Student Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                    height: 250,
                    width: 250,
                    child: image != null
                        ? Image.file(File(image!))
                        : const Center(
                            child: Text('Upload image'),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return SizedBox(
                          height: 120,
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                onPressed: () {
                                  cameraImage();
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.camera, size: 50),
                              ),
                              IconButton(
                                onPressed: () {
                                  galleryImage();
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.image, size: 50),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  label: const Text('Upload image'),
                  icon: const Icon(Icons.add_a_photo),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Name',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter the name';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _ageController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Age',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter the age';
                    }
                    return null;
                  },
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(2),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Phone',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter the phone number';
                    }
                    return null;
                  },
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Address',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter the address';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 15),
                ElevatedButton.icon(
                  onPressed: updateStudentDetails,
                  label: const Text('Update student'),
                  icon: const Icon(Icons.update),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

