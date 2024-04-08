import 'package:flutter/material.dart';
import 'package:todo_app/modals/task_modal.dart';
import 'package:todo_app/utils/colors.dart';

AppBar updateTaskAppBar(BuildContext context, TaskModal? task,
    Function markAsCompleted, Function deleteTask) {
  return AppBar(
    leading: IconButton(
      icon: const Icon(Icons.arrow_back),
      color: Colors.white,
      onPressed: () => Navigator.pop(context),
    ),
    title: const Text(
      "My Todos",
      style: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
      ),
    ),
    foregroundColor: Colors.white,
    backgroundColor: colorBackground,
    actions: [
      Visibility(
        visible: task?.status != 'Completed',
        child: IconButton(
          onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              title: const Text('Mark as completed'),
              content: const Text(
                  'Confirming this action will update your task as completed'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    markAsCompleted();
                  },
                  child: const Text('Confirm'),
                ),
              ],
            ),
          ),
          icon: const Icon(Icons.check),
        ),
      ),
      IconButton(
        onPressed: () => showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: const Text('Delete Task'),
            content: const Text(
                'Confirming this action will delete your task permanently'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  deleteTask();
                },
                child: const Text('Delete'),
              ),
            ],
          ),
        ),
        icon: const Icon(Icons.delete),
      )
    ],
  );
}
