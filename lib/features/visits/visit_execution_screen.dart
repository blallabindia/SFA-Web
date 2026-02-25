import 'package:flutter/material.dart';
import 'visit_execution_model.dart';
import 'visit_store.dart';
import 'checkin_section.dart';
import 'checkout_section.dart';

class VisitExecutionScreen extends StatefulWidget {
  final String accountName;
  final String visitId;

  const VisitExecutionScreen({
    super.key,
    required this.accountName,
    required this.visitId,
  });

  @override
  State<VisitExecutionScreen> createState() => _VisitExecutionScreenState();
}

class _VisitExecutionScreenState extends State<VisitExecutionScreen> {
  late VisitExecutionModel _visit;

  @override
  void initState() {
    super.initState();
    // Initialize with planned state
    _visit = VisitExecutionModel(
      visitId: widget.visitId,
      accountName: widget.accountName,
      status: VisitStatus.planned,
    );
  }

  void _handleStartVisit(String purpose, String location) {
    setState(() {
      _visit.status = VisitStatus.inProgress;
      _visit.checkInTime = DateTime.now();
      _visit.startLocation = location;
      _visit.purpose = purpose;
    });
  }

  void _handleCompleteVisit(
    String outcome,
    String notes,
    String nextAction,
    DateTime? nextActionDate,
    List<String> attachments,
  ) {
    setState(() {
      _visit.status = VisitStatus.completed;
      _visit.checkOutTime = DateTime.now();
      _visit.outcome = outcome;
      _visit.discussionNotes = notes;
      _visit.nextActionType = nextAction;
      _visit.nextActionDate = nextActionDate;
      _visit.attachments = attachments;
    });
    // mark completed in shared store (UI-only)
    VisitStore().markCompleted(widget.visitId);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 800),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text("Visit Execution"),
            centerTitle: false,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: _buildStatusBadge(),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                if (_visit.status == VisitStatus.planned)
                  CheckInSection(
                    visit: _visit,
                    onStartVisit: _handleStartVisit,
                  ),
                if (_visit.status == VisitStatus.inProgress) ...[
                  _buildInProgressHeader(),
                  const Divider(height: 32),
                  CheckOutSection(
                    visit: _visit,
                    onCompleteVisit: _handleCompleteVisit,
                  ),
                ],
                if (_visit.status == VisitStatus.completed)
                  _buildCompletedSummary(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color color;
    String text;
    switch (_visit.status) {
      case VisitStatus.planned:
        color = Colors.blue;
        text = "PLANNED";
        break;
      case VisitStatus.inProgress:
        color = Colors.orange;
        text = "IN PROGRESS";
        break;
      case VisitStatus.completed:
        color = Colors.green;
        text = "COMPLETED";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildInProgressHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.timer, color: Colors.orange),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Visit In Progress",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              Text(
                "Started at: ${_formatTime(_visit.checkInTime!)}",
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Icon(Icons.check_circle, color: Colors.green, size: 64),
        ),
        const SizedBox(height: 16),
        const Center(
          child: Text(
            "Visit Completed Successfully",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 32),
        _summaryRow("Account", _visit.accountName),
        _summaryRow("Purpose", _visit.purpose),
        _summaryRow("Check-in", _formatTime(_visit.checkInTime!)),
        _summaryRow("Check-out", _formatTime(_visit.checkOutTime!)),
        const Divider(),
        _summaryRow("Outcome", _visit.outcome),
        _summaryRow("Next Action", _visit.nextActionType),
        if (_visit.nextActionDate != null)
          _summaryRow("Due Date",
              "${_visit.nextActionDate!.day}/${_visit.nextActionDate!.month}/${_visit.nextActionDate!.year}"),
        if (_visit.discussionNotes != null &&
            _visit.discussionNotes!.isNotEmpty)
          _summaryRow("Notes", _visit.discussionNotes),
        
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ),
      ],
    );
  }

  Widget _summaryRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? "-",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    return "${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
  }
}