class Todo {
  final String id;
  final String title;
  final bool isDone;

  const Todo({required this.id, required this.title, required this.isDone});

  factory Todo.fromMap(String id, Map<String, dynamic> data) {
    return Todo(
      id: id,
      title: data['title'] ?? '',
      isDone: data['isDone'] ?? false,
    );
  }

  Todo copyWith({String? title, bool? isDone}) {
    return Todo(
      id: id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
    );
  }
}
