import 'package:cloud_firestore_example/pages/add_student_page.dart';
import 'package:cloud_firestore_example/pages/list_student_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Firestore CRUD"),
            ElevatedButton(
              onPressed: () => {Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddStudentPage()))},
              child: const Text("추가", style: TextStyle(fontSize: 20)),
              style: ElevatedButton.styleFrom(primary: Colors.indigo),
            ),
          ],
        ),
      ),
      body: const ListStudentPage(),
    );
  }
}
