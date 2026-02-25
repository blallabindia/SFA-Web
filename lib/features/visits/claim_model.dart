import 'package:flutter/foundation.dart';

enum ClaimStatus { notCreated, draft, submitted, approved, rejected }

class ExpenseLine {
  String id;
  String type;
  double amount;
  DateTime date;
  String? remarks;
  // receipt path or bytes would go here; UI-only uses placeholder

  ExpenseLine({
    String? id,
    required this.type,
    required this.amount,
    required this.date,
    this.remarks,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();
}

class Claim {
  final String id;
  String salesPerson;
  List<String> visitIds; // linked visit ids
  List<ExpenseLine> lines;
  ClaimStatus status;
  String? managerRemarks;
  DateTime createdAt;

  Claim({
    String? id,
    required this.salesPerson,
    required this.visitIds,
    List<ExpenseLine>? lines,
    this.status = ClaimStatus.draft,
    this.managerRemarks,
    DateTime? createdAt,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        lines = lines ?? [],
        createdAt = createdAt ?? DateTime.now();

  double get total => lines.fold(0.0, (s, l) => s + l.amount);
}
