import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:todo_app/modals/task_modal.dart';

class TaskDataProvider {
  List<TaskModal> tasks = [];

  static final TaskDataProvider instance = TaskDataProvider._instance();
  Database? _db;

  TaskDataProvider._instance();

  String tasksTable = 'task_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDesc = 'description';
  String colDate = 'date';
  String colPriority = 'priority';
  String colStatus = 'status';

  Future<Database> get db async {
    return _db ?? await _initDb();
  }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = '${dir.path}/todo_list.db';

    final todoListDb =
        await openDatabase(path, version: 1, onCreate: _createDb);

    return todoListDb;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $tasksTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDesc TEXT, $colDate TEXT, $colPriority TEXT, $colStatus INTEGER)',
    );
  }

  Future<List<Map<String, dynamic>>> getTaskMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(tasksTable);

    return result;
  }

  Future<List<TaskModal>> getTaskList() async {
    final List<TaskModal> taskList = [];
    try {
      final List<Map<String, dynamic>> taskMapList = await getTaskMapList();
      for (var taskMap in taskMapList) {
        taskList.add(TaskModal.fromMap(taskMap));
      }
      taskList.sort((taskA, taskB) => taskA.date.compareTo(taskB.date));
    } catch (e) {
      print('$e - LOG');
    }
    return taskList;
  }

  Future<int> insertTask(TaskModal task) async {
    Database db = await this.db;
    final int result = await db.insert(tasksTable, task.toMap());
    return result;
  }

  Future<int> updateTask(TaskModal task) async {
    Database db = await this.db;
    final int result = await db.update(
      tasksTable,
      task.toMap(),
      where: '$colId = ?',
      whereArgs: [task.id],
    );
    return result;
  }

  Future<int> deleteTask(int id) async {
    Database db = await this.db;
    final int result = await db.delete(
      tasksTable,
      where: '$colId = ?',
      whereArgs: [id],
    );
    return result;
  }

  Future<int> deleteAllTask() async {
    Database db = await this.db;
    final int result = await db.delete(tasksTable);
    return result;
  }
}
