import 'package:flutter/material.dart';
import 'package:todo_app/components/tasks_list.dart';
import 'package:todo_app/components/task_list_skeleton.dart';
import 'package:todo_app/helpers/task_data_provider.dart';
import 'package:todo_app/modals/task_modal.dart';
import 'package:todo_app/utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TaskModal>? _taskList;
  bool loading = false;
  List<TaskModal>? _filterList;
  List<TaskModal>? _tempList;
  int? _selectedItem = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getTaskList();
  }

  void _getTaskList() {
    setState(() {
      _selectedItem = 1;
      loading = true;
    });
    TaskDataProvider.instance.getTaskList().then(
          (value) => setState(
            () {
              _filterList = value;
              _taskList = value;
              loading = false;
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 18.0),
        child: _filterList!.isEmpty && !loading
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.checklist_rtl,
                      color: colorAccent,
                      size: 50.0,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      "Schedule your tasks",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 26.0,
                        letterSpacing: 1.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Manage your tasks easily and effeciently",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.blueGrey,
                        letterSpacing: 0.75,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Material(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                      elevation: 2.0,
                      color: Colors.white,
                      child: TextField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search),
                          hintText: "Search tasks...",
                        ),
                        onChanged: (value) {
                          setState(() {
                            if (value.isEmpty) {
                              _selectedItem = 1;
                              _taskList = List.from(_tempList!);
                              _filterList = List.from(_tempList!);
                            }
                          });
                        },
                        onSubmitted: (value) {
                          setState(() {
                            _tempList = List.from(_taskList!);
                            _filterList = List.from(_taskList!);
                            _filterList = _filterList
                                ?.where((e) => e.title
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                            _taskList = _filterList;
                          });
                        },
                        textInputAction: TextInputAction.search,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                    child: Material(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey[200],
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        // margin: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Center(
                              child: Text(
                                'You have [${_taskList!.where((element) => element.status == 'Pending').length}] pending out of [${_taskList?.length}]',
                                style: TextStyle(
                                  color: Colors.blueGrey[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: loading
                          ? const TaskListSkeleton()
                          : _taskList != null && _taskList!.isNotEmpty
                              ? TasksList(
                                  taskList: _taskList,
                                  getTaskList: _getTaskList,
                                )
                              : const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.data_array_rounded,
                                        color: colorAccent,
                                        size: 45.0,
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        "Empty List",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24.0,
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addNewTask').then((value) {
            _getTaskList();
          });
        },
        backgroundColor: colorBackground,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text(
        "My Todos",
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: colorBackground,
      foregroundColor: Colors.white,
      actions: [
        Visibility(
          visible: _taskList!.isNotEmpty || _filterList!.isNotEmpty,
          child: IconButton(
            onPressed: () {
              _getTaskList();
            },
            icon: const Icon(Icons.refresh),
            tooltip: "Refresh List",
          ),
        ),
        Visibility(
          visible: _taskList!.isNotEmpty || _filterList!.isNotEmpty,
          child: PopupMenuButton(
            icon: const Icon(Icons.filter_alt),
            surfaceTintColor: Colors.white,
            color: Colors.white,
            initialValue: _selectedItem,
            onSelected: (value) {
              switch (value) {
                case 1:
                  {
                    setState(() {
                      if (_filterList != null) {
                        _taskList = _filterList;
                      }
                      _taskList?.sort(
                          (taskA, taskB) => taskA.date.compareTo(taskB.date));
                      _selectedItem = 1;
                    });
                    break;
                  }
                case 2:
                  {
                    setState(() {
                      if (_filterList != null) {
                        _taskList = _filterList;
                      }
                      _taskList?.sort(
                          (taskA, taskB) => taskB.date.compareTo(taskA.date));
                      _selectedItem = 2;
                    });
                    break;
                  }
                case 3:
                  {
                    setState(() {
                      if (_filterList != null) {
                        _taskList = _filterList;
                      }
                      _filterList = List.from(_taskList!);
                      _taskList?.sort((taskA, taskB) =>
                          taskA.priority.compareTo(taskB.priority));
                      _selectedItem = 3;
                    });
                    break;
                  }
                case 4:
                  {
                    setState(() {
                      if (_filterList != null) {
                        _taskList = _filterList;
                      }
                      _filterList = List.from(_taskList!);
                      _taskList?.sort((taskA, taskB) =>
                          taskB.priority.compareTo(taskA.priority));
                      _selectedItem = 4;
                    });
                    break;
                  }
                case 5:
                  {
                    setState(() {
                      if (_filterList != null) {
                        _taskList = _filterList;
                      }
                      _filterList = List.from(_taskList!);
                      _taskList?.removeWhere(
                          (element) => element.status == 'Pending');
                      _selectedItem = 5;
                    });
                    break;
                  }
                case 6:
                  {
                    setState(() {
                      if (_filterList != null) {
                        _taskList = _filterList;
                      }
                      _filterList = List.from(_taskList!);
                      _taskList?.removeWhere(
                          (element) => element.status == 'Completed');
                      _selectedItem = 6;
                    });
                  }
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 1,
                child: ListTile(
                  leading: Icon(Icons.calendar_month),
                  title: Text("Sort By Date (Asc)"),
                ),
              ),
              const PopupMenuItem(
                value: 2,
                child: ListTile(
                  leading: Icon(Icons.calendar_month),
                  title: Text("Sort By Date (Desc)"),
                ),
              ),
              const PopupMenuItem(
                value: 3,
                child: ListTile(
                  leading: Icon(Icons.priority_high),
                  title: Text("Priority (High to Low)"),
                ),
              ),
              const PopupMenuItem(
                value: 4,
                child: ListTile(
                  leading: Icon(Icons.priority_high),
                  title: Text("Priority (Low to High)"),
                ),
              ),
              const PopupMenuItem(
                value: 5,
                child: ListTile(
                  leading: Icon(Icons.playlist_add_check),
                  title: Text("Completed Tasks"),
                ),
              ),
              const PopupMenuItem(
                value: 6,
                child: ListTile(
                  leading: Icon(Icons.pending_actions),
                  title: Text("Pending Tasks"),
                ),
              ),
            ],
            tooltip: "Sort List",
          ),
        ),
      ],
    );
  }
}
