class TaskModal {
  int? id;
  String title;
  String description;
  DateTime date;
  String status;
  String priority;

  TaskModal({
    required this.title,
    required this.description,
    required this.date,
    required this.priority,
    required this.status,
  });

  TaskModal.withId({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.priority,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['description'] = description;
    map['date'] = date.toIso8601String();
    map['priority'] = priority;
    map['status'] = status;
    return map;
  }

  factory TaskModal.fromMap(Map<String, dynamic> map) {
    return TaskModal.withId(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        date: DateTime.parse(map['date']),
        priority: map['priority'],
        status: map['status']);
  }
}
