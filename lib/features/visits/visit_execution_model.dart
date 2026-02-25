import 'package:flutter/material.dart';

enum VisitStatus { planned, inProgress, completed }

class VisitExecutionModel {
  final String visitId;
  final String accountName;
  VisitStatus status;
  
  // Check-in Data
  DateTime? checkInTime;
  String? startLocation; // Mock GPS
  String? purpose;

  // Check-out Data
  DateTime? checkOutTime;
  String? outcome;
  String? discussionNotes;
  String? nextActionType;
  DateTime? nextActionDate;
  List<String> attachments;

  VisitExecutionModel({
    required this.visitId,
    required this.accountName,
    this.status = VisitStatus.planned,
    this.attachments = const [],
  });
}