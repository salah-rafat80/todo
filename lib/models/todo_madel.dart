class TodoModel {
  final int id;
  final String name;
  late final bool isCompleted;
  final DateTime? completedAt;

  TodoModel({
    required this.id,
    required this.name,
    this.isCompleted = false,
    this.completedAt,
  });

  TodoModel copyWith({
    int? id,
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
