import 'package:cloud_firestore_example/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        // 에러 체크
        if (snapshot.hasError) {
          print("알 수 없는 에러가 발생하였습니다.");
        }
        // 성공적으로 연결되면 애플리케이션을 보여줍니다.
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Firestore CRUD 데모',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: const HomePage(),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
