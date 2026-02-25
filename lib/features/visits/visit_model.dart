import 'package:flutter/material.dart';

class Visit {
  final String id;
  final DateTime date;
  final TimeOfDay? time;
  final String accountName;
  final String visitType;
  final String? notes;
  final Color typeColor;
  final DateTime createdAt;
  final List<String> jointWorkingWith;

  Visit({
    String? id,
    required this.date,
    this.time,
    required this.accountName,
    required this.visitType,
    this.notes,
    Color? typeColor,
    DateTime? createdAt,
    this.jointWorkingWith = const [],
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        typeColor = typeColor ?? _getColorForType(visitType),
        createdAt = createdAt ?? DateTime.now();

  static Color _getColorForType(String type) {
    switch (type.toLowerCase()) {
      case 'sales':
        return Colors.blue;
      case 'collection':
        return Colors.green;
      case 'service':
        return Colors.orange;
      case 'meeting':
        return Colors.purple;
      case 'demo':
        return Colors.red;
      case 'admin day':
        return Colors.blueGrey;
      case 'leave day':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  Visit copyWith({
    String? id,
    DateTime? date,
    TimeOfDay? time,
    String? accountName,
    String? visitType,
    String? notes,
    Color? typeColor,
    DateTime? createdAt,
    List<String>? jointWorkingWith,
  }) {
    return Visit(
      id: id ?? this.id,
      date: date ?? this.date,
      time: time ?? this.time,
      accountName: accountName ?? this.accountName,
      visitType: visitType ?? this.visitType,
      notes: notes ?? this.notes,
      typeColor: typeColor ?? this.typeColor,
      createdAt: createdAt ?? this.createdAt,
      jointWorkingWith: jointWorkingWith ?? this.jointWorkingWith,
    );
  }

  @override
  String toString() => 'Visit(id: $id, date: $date, time: $time, accountName: $accountName, visitType: $visitType, jointWorkingWith: $jointWorkingWith)';

  /// Factory constructor to create a Visit from just the visit type (useful for getting color)
  factory Visit.fromType(String visitType) {
    return Visit(
      date: DateTime.now(),
      accountName: '',
      visitType: visitType,
    );
  }
}