import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateStudentPage extends StatefulWidget {
  const UpdateStudentPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  final String id;

  @override
  State<UpdateStudentPage> createState() => _UpdateStudentPageState();
}

class _UpdateStudentPageState extends State<UpdateStudentPage> {
  final _formKey = GlobalKey<FormState>();

  Future<void> updateUser(id, name, email, password) async {
    FirebaseFirestore.instance.collection("students").doc(id).update(
      {
        "name": name,
        "email": email,
        "password": password,
      },
    ).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("성공적으로 업데이트 되었습니다.")));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("업데이트 실패하였습니다.\n에러: $error}")));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("학생 정보 수정"),
      ),
      body: Form(
          key: _formKey,
          child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance.collection("students").doc(widget.id).get(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasError) {
                print("에러 발생하였습니다.");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              var data = snapshot.data!.data();
              var name = data!["name"];
              var email = data["email"];
              var password = data["password"];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: ListView(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        initialValue: name,
                        autofocus: false,
                        onChanged: (value) => name = value,
                        decoration: const InputDecoration(
                          labelText: "이름:",
                          labelStyle: TextStyle(fontSize: 18),
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
                        initialValue: email,
                        autofocus: false,
                        onChanged: (value) => email = value,
                        decoration: const InputDecoration(
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
                        initialValue: password,
                        autofocus: false,
                        onChanged: (value) => password = value,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "비밀번호:",
                          labelStyle: TextStyle(fontSize: 18),
                          border: OutlineInputBorder(),
                          errorStyle: TextStyle(color: Colors.redAccent, fontSize: 15),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "비밀번호를 입력하십시오.";
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
                                updateUser(widget.id, name, email, password);
                                return Navigator.of(context).pop();
                              }
                            },
                            child: const Text("수정완료", style: TextStyle(fontSize: 16)),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text("초기화", style: TextStyle(fontSize: 16)),
                            style: ElevatedButton.styleFrom(primary: Colors.black54, elevation: 0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          )),
    );
  }
}
