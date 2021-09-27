import 'package:flutter/material.dart';
import 'package:prueba_tecnica/Database/SQLiteDatabase.dart';
import 'package:prueba_tecnica/TabBarMenu.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await SQLiteDatabase().initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prueba tecnica',
      theme: ThemeData(
        
        primarySwatch: Colors.blue,
      ),
      home: 
      TabBarMenu(title: 'Prueba Tecnica'),
    );
  }
}


