import 'package:flutter/material.dart';
import 'package:todo_app/pages/add_new_task.dart';
import 'package:todo_app/pages/home.dart';
import 'package:todo_app/pages/update_task.dart';
import 'package:todo_app/utils/colors.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: colorAccent,
      ),
    ),
    initialRoute: '/home',
    routes: {
      '/home': (context) => const HomeScreen(),
      '/addNewTask': (context) => const AddNewTask(),
      '/updateTask': (context) => const UpdateTask(),
    },
  ));
}
