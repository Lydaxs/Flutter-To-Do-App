import 'package:flutter/material.dart';
import 'package:to_do_list/HomePage.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "To Do List App",
      theme: ThemeData(
          colorScheme:
              ColorScheme.fromSeed(seedColor: const Color.fromRGBO(151, 207, 138, 1)).copyWith(background: Colors.white),
          textTheme: const TextTheme(bodyMedium: TextStyle(color: Color.fromRGBO(49, 94, 38, 1)))),
      home: const HomePage(),
    );
  }
}
