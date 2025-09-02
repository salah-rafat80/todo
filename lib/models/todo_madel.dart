class TodoModel {
  final String id;
  final String name;
  final bool isCompleted;
  final DateTime? completedAt;

  TodoModel({
    required this.id,
    required this.name,
    this.isCompleted = false,
    this.completedAt,
  });

  TodoModel copyWith({
    String? id,
    String? name,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return TodoModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
