import 'package:flutter/material.dart';

enum DayEventType { admin, leave }

class DayEvent {
  final String id;
  final DateTime date;
  final DayEventType type;
  final String? notes;
  final String? userId;
  final DateTime createdAt;

  DayEvent({
    String? id,
    required this.date,
    required this.type,
    this.notes,
    this.userId,
    DateTime? createdAt,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'type': type.toString().split('.').last,
        'notes': notes,
        'userId': userId,
        'createdAt': createdAt.toIso8601String(),
      };

  factory DayEvent.fromJson(Map<String, dynamic> j) => DayEvent(
        id: j['id'] as String?,
        date: DateTime.parse(j['date'] as String),
        type: (j['type'] as String) == 'leave' ? DayEventType.leave : DayEventType.admin,
        notes: j['notes'] as String?,
        userId: j['userId'] as String?,
        createdAt: DateTime.parse(j['createdAt'] as String),
      );
}

Color dayEventColor(DayEventType t) {
  switch (t) {
    case DayEventType.admin:
      return Colors.amber;
    case DayEventType.leave:
      return Colors.red;
  }
}
