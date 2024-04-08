import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/modals/task_modal.dart';

class TasksList extends StatefulWidget {
  final List<TaskModal>? taskList;
  final Function getTaskList;

  const TasksList({
    super.key,
    required this.taskList,
    required this.getTaskList,
  });

  @override
  State<TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: widget.taskList?.length,
      itemBuilder: (context, index) {
        final task = widget.taskList![index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
          child: Card(
            color: Colors.white,
            surfaceTintColor: Colors.white,
            shadowColor: Colors.grey,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.grey[200] as Color,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.taskList![index].title,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      decoration: widget.taskList![index].status == 'Completed'
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  Text(
                    widget.taskList![index].description,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey[600],
                      decoration: widget.taskList![index].status == 'Completed'
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ],
              ),
              subtitle: Row(children: [
                Text(
                  DateFormat.d().add_MMM().add_y().format(
                        DateTime.parse(
                          widget.taskList?[index].date.toString() as String,
                        ),
                      ),
                  style: TextStyle(
                    fontSize: 12.0,
                    decoration: widget.taskList![index].status == 'Completed'
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.taskList?[index].priority == 'High'
                        ? Colors.red
                        : widget.taskList?[index].priority == 'Moderate'
                            ? Colors.orange
                            : Colors.green,
                  ),
                ),
                const SizedBox(
                  width: 4.0,
                ),
                Text(
                  widget.taskList?[index].priority as String,
                  style: const TextStyle(fontSize: 12.0),
                ),
              ]),
              onTap: () {
                Navigator.pushNamed(context, '/updateTask',
                    arguments: {'task': task.toMap()}).then((value) {
                  widget.getTaskList();
                });
              },
              selectedTileColor: Colors.grey[200],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        );
      },
    );
  }
}
