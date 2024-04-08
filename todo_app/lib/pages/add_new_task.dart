import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app/helpers/task_data_provider.dart';
import 'package:todo_app/modals/task_modal.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:toast/toast.dart';

class AddNewTask extends StatefulWidget {
  const AddNewTask({super.key});

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  String _title = '';
  String _description = '';
  DateTime? _date;

  int? _selectedOption = 1;

  void _saveTask() async {
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
      TaskModal task = TaskModal(
          title: _title,
          description: _description,
          date: _date as DateTime,
          priority: _selectedOption == 1
              ? "High"
              : _selectedOption == 2
                  ? "Moderate"
                  : "Low",
          status: "Pending");
      await TaskDataProvider.instance.insertTask(task);
      if (mounted) {
        Toast.show(
          'Task Created Successfully!',
          duration: Toast.lengthLong,
          backgroundColor: Colors.green as Color,
          textStyle: const TextStyle(color: Colors.white),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.pop(context, '/home'),
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
      ),
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
              TextField(
                cursorColor: colorAccent,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                  border: OutlineInputBorder(),
                  hintText: "Task title",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: colorAccent,
                      width: 1.5,
                    ),
                  ),
                ),
                maxLength: 20,
                onChanged: (value) {
                  setState(() {
                    _title = value;
                  });
                },
                style: const TextStyle(
                  fontSize: 14.0,
                ),
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
              TextField(
                cursorColor: colorAccent,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 14.0),
                  border: OutlineInputBorder(),
                  hintText: "Task description",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: colorAccent,
                      width: 1.5,
                    ),
                  ),
                ),
                maxLength: 50,
                maxLines: 5,
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                },
                style: const TextStyle(
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(
                height: 18.0,
              ),
              Text(
                _date == null
                    ? 'Date'
                    : "Date - ${_date?.day.toString() as String}/${_date?.month.toString()}",
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
                  focusedDay:
                      _date == null ? DateTime.now() : _date as DateTime,
                  firstDay: DateTime.now(),
                  lastDay: DateTime.utc(2099, 12, 31),
                  selectedDayPredicate: (day) {
                    return isSameDay(_date, day);
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
                        fontSize: 14.0,
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
                        fontSize: 14.0,
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
                        fontSize: 14.0,
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
                  ElevatedButton(
                    onPressed: _saveTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorBackground,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text('Save'),
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
