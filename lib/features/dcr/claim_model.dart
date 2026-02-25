import 'package:flutter/material.dart';

enum ClaimStatus { notCreated, draft, submitted, approved, rejected }

class ExpenseLine {
  final String id;
  String expenseType;
  double amount;
  DateTime expenseDate;
  String? description;
  String? receiptPath;
  String modeOfPayment;

  ExpenseLine({
    String? id,
    required this.expenseType,
    required this.amount,
    DateTime? expenseDate,
    this.description,
    this.receiptPath,
    this.modeOfPayment = 'Cash',
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        expenseDate = expenseDate ?? DateTime.now();
}

class Claim {
  final String id;
  final String salesPerson;
  final List<String> visitIds;
  List<ExpenseLine> expenses;
  ClaimStatus status;
  DateTime createdAt;
  String? managerRemarks;

  Claim({
    String? id,
    required this.salesPerson,
    required this.visitIds,
    this.expenses = const [],
    this.status = ClaimStatus.draft,
    DateTime? createdAt,
    this.managerRemarks,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt = createdAt ?? DateTime.now();

  double get totalAmount => expenses.fold(0.0, (p, e) => p + e.amount);
}
