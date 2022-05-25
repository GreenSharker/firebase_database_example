import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_example/pages/update_student_page.dart';
import 'package:flutter/material.dart';

class ListStudentPage extends StatefulWidget {
  const ListStudentPage({Key? key}) : super(key: key);

  @override
  State<ListStudentPage> createState() => _ListStudentPageState();
}

class _ListStudentPageState extends State<ListStudentPage> {
  final Stream<QuerySnapshot> studentsStream = FirebaseFirestore.instance.collection("students").snapshots();

  CollectionReference students = FirebaseFirestore.instance.collection("students");

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: studentsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print("에러가 발생하였습니다.");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final List storedocs = [];
        snapshot.data!.docs.map((DocumentSnapshot document) {
          Map a = document.data() as Map<String, dynamic>;
          storedocs.add(a);
          a["id"] = document.id;
        }).toList();

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Table(
              border: TableBorder.all(),
              columnWidths: const <int, TableColumnWidth>{1: FixedColumnWidth(150)},
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child: Container(
                        color: Colors.blue,
                        child: const Center(
                          child: Text(
                            "이름",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        color: Colors.blue,
                        child: const Center(
                          child: Text(
                            "이메일",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        color: Colors.blue,
                        child: const Center(
                          child: Text(
                            "액션",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                for (var i = 0; i < storedocs.length; i++) ...[
                  TableRow(
                    children: [
                      TableCell(
                        child: Center(
                          child: Text(
                            storedocs[i]["name"],
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Center(
                          child: Text(
                            storedocs[i]["email"],
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => UpdateStudentPage(id: storedocs[i]["id"]))),
                              icon: const Icon(Icons.edit, color: Colors.blue),
                            ),
                            IconButton(
                              onPressed: () {
                                deleteUser(storedocs[i]["id"]);
                              },
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> deleteUser(String id) {
    return students.doc(id).delete().then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "성공적으로 삭제되었습니다.",
          textAlign: TextAlign.center,
        ),
      ));
    }).catchError((error) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("삭제 실패하였습니다.\n에러: $error")),
        ));
  }
}
