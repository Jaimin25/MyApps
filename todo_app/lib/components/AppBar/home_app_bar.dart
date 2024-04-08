import 'package:flutter/material.dart';
import 'package:todo_app/modals/task_modal.dart';
import 'package:todo_app/utils/colors.dart';

AppBar homeAppBar(
    Function setState,
    Function getTaskList,
    List<TaskModal>? filterList,
    List<TaskModal>? taskList,
    List<TaskModal>? tempList,
    int selectedItem) {
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
        visible: filterList != null && filterList.isNotEmpty,
        child: IconButton(
          onPressed: () {
            getTaskList();
          },
          icon: const Icon(Icons.refresh),
          tooltip: "Refresh List",
        ),
      ),
      Visibility(
        visible: filterList != null && filterList.isNotEmpty,
        child: PopupMenuButton(
          icon: const Icon(Icons.filter_alt),
          surfaceTintColor: Colors.white,
          color: Colors.white,
          initialValue: selectedItem,
          onSelected: (value) {
            switch (value) {
              case 1:
                {
                  setState(() {
                    if (filterList != null) {
                      taskList = filterList;
                    }
                    taskList?.sort(
                        (taskA, taskB) => taskA.date.compareTo(taskB.date));
                    selectedItem = 1;
                  });
                  break;
                }
              case 2:
                {
                  setState(() {
                    if (filterList != null) {
                      taskList = filterList;
                    }
                    taskList?.sort(
                        (taskA, taskB) => taskB.date.compareTo(taskA.date));
                    selectedItem = 2;
                  });
                  break;
                }
              case 3:
                {
                  setState(() {
                    if (filterList != null) {
                      taskList = filterList;
                    }
                    filterList = List.from(taskList!);
                    taskList?.sort((taskA, taskB) =>
                        taskA.priority.compareTo(taskB.priority));
                    selectedItem = 3;
                  });
                  break;
                }
              case 4:
                {
                  setState(() {
                    if (filterList != null) {
                      taskList = filterList;
                    }
                    filterList = List.from(taskList!);
                    taskList?.sort((taskA, taskB) =>
                        taskB.priority.compareTo(taskA.priority));
                    selectedItem = 4;
                  });
                  break;
                }
              case 5:
                {
                  setState(() {
                    if (filterList != null) {
                      taskList = filterList;
                    }
                    filterList = List.from(taskList!);
                    taskList
                        ?.removeWhere((element) => element.status == 'Pending');
                    selectedItem = 5;
                  });
                  break;
                }
              case 6:
                {
                  setState(() {
                    if (filterList != null) {
                      taskList = filterList;
                    }
                    filterList = List.from(taskList!);
                    taskList?.removeWhere(
                        (element) => element.status == 'Completed');
                    selectedItem = 6;
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
