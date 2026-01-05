class Task {
  final int id;
  String title;
  String course;
  DateTime deadline;
  String status;
  String note;
  bool isDone;

  Task({
    required this.id,
    required this.title,
    required this.course,
    required this.deadline,
    required this.status,
    required this.note,
    required this.isDone,
  });
}
