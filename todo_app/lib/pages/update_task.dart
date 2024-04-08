import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:toast/toast.dart';
import 'package:todo_app/components/AppBar/update_task_app_bar.dart';
import 'package:todo_app/helpers/task_data_provider.dart';
import 'package:todo_app/modals/task_modal.dart';
import 'package:todo_app/utils/colors.dart';

class UpdateTask extends StatefulWidget {
  const UpdateTask({super.key});

  @override
  State<UpdateTask> createState() => _UpdateTaskState();
}

class _UpdateTaskState extends State<UpdateTask> {
  String _title = '';
  String _description = '';
  DateTime? _date;

  int? _selectedOption;

  Map? data;

  TaskModal? _task;

  void _markAsCompleted() async {
    TaskModal task = TaskModal.withId(
        id: _task?.id,
        title: _task!.title,
        description: _task!.description,
        date: _task!.date,
        priority: _task!.priority,
        status: "Completed");
    await TaskDataProvider.instance.updateTask(task);
    if (mounted) {
      Toast.show(
        'Task Updated Succefully!',
        duration: Toast.lengthLong,
        backgroundColor: Colors.green as Color,
        textStyle: const TextStyle(color: Colors.white),
      );
      Navigator.pop(context, '/home');
    }
  }

  void _deleteTask() async {
    await TaskDataProvider.instance.deleteTask(_task?.id as int);
    if (mounted) {
      Toast.show(
        'Task Deleted Succefully!',
        duration: Toast.lengthLong,
        backgroundColor: Colors.green as Color,
        textStyle: const TextStyle(color: Colors.white),
      );
      Navigator.pop(context);
    }
  }

  void _updateTask() async {
    if (_task != null) {
      if (_title.isEmpty) {
        Toast.show(
          'Empty Title!',
          duration: Toast.lengthLong,
          backgroundColor: Colors.redAccent as Color,
          textStyle: const TextStyle(color: Colors.white),
        );
      } else if (_description.isEmpty) {
        Toast.show(
          'Empty Description!',
          duration: Toast.lengthLong,
          backgroundColor: Colors.redAccent as Color,
          textStyle: const TextStyle(color: Colors.white),
        );
      } else if (_date == null || _date.toString().isEmpty) {
        Toast.show(
          'Date not selected!',
          duration: Toast.lengthLong,
          backgroundColor: Colors.redAccent as Color,
          textStyle: const TextStyle(color: Colors.white),
        );
      } else {
        TaskModal task = TaskModal.withId(
            id: _task?.id,
            title: _title,
            description: _description,
            date: _date as DateTime,
            priority: _selectedOption == 1
                ? "High"
                : _selectedOption == 2
                    ? "Moderate"
                    : "Low",
            status: "Pending");
        await TaskDataProvider.instance.updateTask(task);
        if (mounted) {
          Toast.show(
            'Task Updated Succefully!',
            duration: Toast.lengthLong,
            backgroundColor: Colors.green as Color,
            textStyle: const TextStyle(color: Colors.white),
          );
          Navigator.pop(context);
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    data = ModalRoute.of(context)!.settings.arguments as Map;
    _task = TaskModal.fromMap(data?['task']);
    setState(() {
      if (_title.isEmpty) {
        _title = _task!.title;
      }
      if (_description.isEmpty) {
        _description = _task!.description;
      }
      if (_date == null || _date.toString().isEmpty) {
        _date = _task!.date;
      }
      if (_selectedOption == null || _selectedOption.toString().isEmpty) {
        _selectedOption = _task!.priority == "High"
            ? 1
            : _task!.priority == "Moderate"
                ? 2
                : 3;
      }
    });
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: updateTaskAppBar(context, _task, _markAsCompleted, _deleteTask),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Title",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4.0),
              TextFormField(
                cursorColor: colorAccent,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  border: OutlineInputBorder(),
                  hintText: "Task title",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: colorAccent,
                      width: 1.5,
                    ),
                  ),
                ),
                maxLength: 10,
                onChanged: (value) {
                  setState(() {
                    _title = value;
                  });
                },
                style: const TextStyle(
                  fontSize: 12.0,
                ),
                initialValue: _task!.title,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 18.0),
              const Text(
                "Description",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4.0),
              TextFormField(
                cursorColor: colorAccent,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  border: OutlineInputBorder(),
                  hintText: "Task description",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: colorAccent,
                      width: 1.5,
                    ),
                  ),
                ),
                maxLength: 25,
                maxLines: 5,
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                },
                style: const TextStyle(
                  fontSize: 12.0,
                ),
                initialValue: _task!.description,
              ),
              const SizedBox(
                height: 18.0,
              ),
              Text(
                _date == null
                    ? 'Date'
                    : "Date - ${_date?.day.toString()}/${_date?.month.toString()}",
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TableCalendar(
                  calendarStyle: const CalendarStyle(
                    selectedTextStyle: TextStyle(
                      fontSize: 11.0,
                      color: Colors.white,
                    ),
                    defaultTextStyle: TextStyle(
                      fontSize: 12.0,
                    ),
                    todayTextStyle: TextStyle(
                      fontSize: 12.0,
                      color: Colors.white,
                    ),
                    disabledTextStyle: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey,
                    ),
                  ),
                  headerStyle: const HeaderStyle(
                    headerMargin: EdgeInsets.all(0),
                  ),
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                      fontSize: 12.0,
                    ),
                    weekendStyle: TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                  focusedDay: _task!.date,
                  firstDay: DateTime.now(),
                  lastDay: DateTime.utc(2099, 12, 31),
                  selectedDayPredicate: (day) {
                    if (_date == null) {
                      return isSameDay(_task!.date, day);
                    } else {
                      return isSameDay(_date, day);
                    }
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _date = selectedDay;
                    });
                  },
                ),
              ),
              const SizedBox(height: 4.0),
              const SizedBox(height: 18.0),
              const Text(
                "Priority",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4.0),
              Column(
                children: [
                  ListTile(
                    title: const Text(
                      'High',
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(0),
                    leading: Radio<int>(
                      activeColor: colorAccent,
                      value: 1,
                      groupValue: _selectedOption,
                      onChanged: (value) {
                        setState(() {
                          _selectedOption = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text(
                      'Moderate',
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(0),
                    leading: Radio<int>(
                      activeColor: colorAccent,
                      value: 2,
                      groupValue: _selectedOption,
                      onChanged: (value) {
                        setState(() {
                          _selectedOption = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text(
                      'Low',
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(0),
                    leading: Radio<int>(
                      activeColor: colorAccent,
                      value: 3,
                      groupValue: _selectedOption,
                      onChanged: (value) {
                        setState(() {
                          _selectedOption = value;
                        });
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(height: 18.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Visibility(
                    visible: _task?.status != 'Completed',
                    child: ElevatedButton(
                      onPressed: _title != _task?.title ||
                              _description != _task?.description ||
                              _date != _task?.date ||
                              _selectedOption !=
                                  (_task?.priority == 'High'
                                      ? 1
                                      : _task?.priority == 'Moderate'
                                          ? 2
                                          : 3)
                          ? _updateTask
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorBackground,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text('Update'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
