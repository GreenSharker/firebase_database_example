import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({Key? key}) : super(key: key);

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final _formKey = GlobalKey<FormState>();

  var name = "";
  var email = "";
  var password = "";

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // 입력된 내용을 지우는 메서드
  void clearText() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
  }

  CollectionReference students = FirebaseFirestore.instance.collection("students");

  Future<void> addNewUser() {
    return students.add({
      "name": name,
      "email": email,
      "password": password,
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("성공적으로 등록되었습니다.")));
      Navigator.of(context).pop();
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("등록 실패하였습니다.\n에러: $error")));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("새로운 학생 추가"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: ListView(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  controller: nameController,
                  autofocus: false,
                  decoration: const InputDecoration(
                    labelText: "이름:",
                    labelStyle: TextStyle(fontSize: 17),
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(color: Colors.redAccent, fontSize: 15),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "이름을 입력해 주세요.";
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  controller: emailController,
                  autofocus: false,
                  decoration: InputDecoration(
                    labelText: "이메일:",
                    labelStyle: TextStyle(fontSize: 18),
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(color: Colors.redAccent, fontSize: 15),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "이메일 주소를 입력해 주세요.";
                    } else if (!value.contains("@")) {
                      return "올바른 이메일 주소를 입력하세요.";
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  controller: passwordController,
                  autofocus: false,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "비밀번호:",
                    labelStyle: TextStyle(fontSize: 18),
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(color: Colors.redAccent, fontSize: 15),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "비밀번호 입력하십시오.";
                    }
                    return null;
                  },
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            name = nameController.text;
                            email = emailController.text;
                            password = passwordController.text;

                            addNewUser();
                            clearText();
                            // return Navigator.of(context).pop();
                          });
                        }
                      },
                      child: const Text("등록", style: TextStyle(fontSize: 16)),
                    ),
                    ElevatedButton(
                      onPressed: () => clearText(),
                      child: const Text("초기화", style: TextStyle(fontSize: 16)),
                      style: ElevatedButton.styleFrom(primary: Colors.black54, elevation: 0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
