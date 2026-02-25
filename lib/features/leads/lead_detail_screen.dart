import 'package:flutter/material.dart';

class LeadDetailScreen extends StatefulWidget {
  final Map<String, String> lead;

  const LeadDetailScreen({super.key, required this.lead});

  @override
  State<LeadDetailScreen> createState() => _LeadDetailScreenState();
}

class _LeadDetailScreenState extends State<LeadDetailScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lead["name"] ?? "Lead Details"),
        actions: [

          /// Salesforce Style Action Button
          PopupMenuButton<String>(
            icon: const Icon(Icons.arrow_drop_down),
            onSelected: _handleAction,
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: "visit",
                child: Text("Add Visit"),
              ),
              PopupMenuItem(
                value: "followup",
                child: Text("Followup"),
              ),
              PopupMenuItem(
                value: "disqualified",
                child: Text("Disqualified"),
              ),
              PopupMenuItem(
                value: "convert",
                child: Text("Convert to Opportunity"),
              ),
            ],
          ),

          const SizedBox(width: 12),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                _infoRow("Name", widget.lead["name"]),
                _infoRow("Mobile", widget.lead["mobile"]),
                _infoRow("Email", widget.lead["email"]),
                _infoRow("City", widget.lead["city"]),
                _infoRow("Expected Monthly Revenue",
                    "₹ ${widget.lead["revenue"] ?? "0"}"),
                _infoRow("Assigned", widget.lead["assigned"]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleAction(String action) {
    switch (action) {
      case "visit":
        _openVisitDialog();
        break;
      case "followup":
        _openFollowupDialog();
        break;
      case "convert":
        _openConvertDialog();
        break;
      case "disqualified":
        _openDisqualifyDialog();
        break;
    }
  }

  void _openVisitDialog() {
    showDialog(
      context: context,
      builder: (_) => const VisitDialog(),
    );
  }

  void _openFollowupDialog() {
    showDialog(
      context: context,
      builder: (_) => const FollowupDialog(),
    );
  }

  void _openConvertDialog() {
    showDialog(
      context: context,
      builder: (_) => const ConvertDialog(),
    );
  }

  void _openDisqualifyDialog() {
    showDialog(
      context: context,
      builder: (_) => const DisqualifyDialog(),
    );
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          SizedBox(
            width: 220,
            child: Text(
              label,
              style: const TextStyle(
                  fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value ?? "-"),
          ),
        ],
      ),
    );
  }
}
class VisitDialog extends StatefulWidget {
  const VisitDialog({super.key});

  @override
  State<VisitDialog> createState() => _VisitDialogState();
}

class _VisitDialogState extends State<VisitDialog> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _backendController = TextEditingController();
  final TextEditingController _jointWorkingController = TextEditingController();
  final TextEditingController _rescheduleDateController = TextEditingController();
  final TextEditingController _reschedulePurposeController = TextEditingController();
  final TextEditingController _rescheduleLocationController = TextEditingController();
  final TextEditingController _cancelReasonController = TextEditingController();
  final TextEditingController _nextVisitDateController = TextEditingController();
  final TextEditingController _nextVisitPurposeController = TextEditingController();
  final TextEditingController _visitOutcomeController = TextEditingController();
  final TextEditingController _opportunityNameController = TextEditingController();
  final TextEditingController _expectedRevenueController = TextEditingController();
  final TextEditingController _closingDateController = TextEditingController();

  String visitStatus = "Scheduled";

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        _dateController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _pickRescheduleDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        _rescheduleDateController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _pickNextVisitDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        _nextVisitDateController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _pickClosingDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        _closingDateController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _captureGeoLocation() {
    // UI placeholder – later integrate geolocator package
    debugPrint("Capturing Geo Location...");
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Visit"),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            children: [

              /// Visit Date
              TextField(
                controller: _dateController,
                readOnly: true,
                onTap: _pickDate,
                decoration: const InputDecoration(
                  labelText: "Visit Date",
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
              const SizedBox(height: 16),

              /// Purpose
              TextField(
                controller: _purposeController,
                decoration:
                    const InputDecoration(labelText: "Purpose"),
              ),
              const SizedBox(height: 16),

              /// Google Location Dropdown (UI Placeholder)
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: "Visit Location",
                  hintText: "Select from Google Places",
                  suffixIcon: Icon(Icons.location_on),
                ),
              ),
              const SizedBox(height: 16),

              /// Remarks
              TextField(
                controller: _remarksController,
                maxLines: 3,
                decoration:
                    const InputDecoration(labelText: "Visit Remarks"),
              ),
              const SizedBox(height: 16),

              /// Visit Status Dropdown
              DropdownButtonFormField<String>(
                initialValue: visitStatus,
                decoration:
                    const InputDecoration(labelText: "Visit Status"),
                items: const [
                  DropdownMenuItem(
                      value: "Scheduled",
                      child: Text("Scheduled")),
                  DropdownMenuItem(
                      value: "Rescheduled",
                      child: Text("Rescheduled")),
                  DropdownMenuItem(
                      value: "Canceled",
                      child: Text("Canceled")),
                  DropdownMenuItem(
                      value: "Done",
                      child: Text("Done")),
                  DropdownMenuItem(
                      value: "Next Visit Required",
                      child: Text("Next Visit Required")),
                  DropdownMenuItem(
                      value: "Converted to Opportunity",
                      child: Text("Converted to Opportunity")),
                ],
                onChanged: (val) {
                  setState(() {
                    visitStatus = val!;
                  });

                  if (val == "Done") {
                    _captureGeoLocation();
                  }
                },
              ),
              const SizedBox(height: 16),

              if (visitStatus == "Rescheduled") ...[
                TextField(
                  controller: _rescheduleDateController,
                  readOnly: true,
                  onTap: _pickRescheduleDate,
                  decoration: const InputDecoration(
                    labelText: "Reschedule Visit Date",
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _reschedulePurposeController,
                  decoration:
                      const InputDecoration(labelText: "Reschedule Purpose"),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _rescheduleLocationController,
                  decoration: const InputDecoration(
                    labelText: "Reschedule Location",
                    suffixIcon: Icon(Icons.location_on),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              if (visitStatus == "Canceled") ...[
                TextField(
                  controller: _cancelReasonController,
                  decoration: const InputDecoration(labelText: "Cancel Reason"),
                ),
                const SizedBox(height: 16),
              ],

              if (visitStatus == "Next Visit Required") ...[
                TextField(
                  controller: _nextVisitDateController,
                  readOnly: true,
                  onTap: _pickNextVisitDate,
                  decoration: const InputDecoration(
                    labelText: "Next Visit Date",
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _nextVisitPurposeController,
                  decoration: const InputDecoration(labelText: "Next Visit Purpose"),
                ),
                const SizedBox(height: 16),
              ],

              if (visitStatus == "Done") ...[
                TextField(
                  controller: _visitOutcomeController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: "Visit Outcome / MOM",
                  ),
                ),
                const SizedBox(height: 16),
              ],

              if (visitStatus == "Converted to Opportunity") ...[
                TextField(
                  controller: _opportunityNameController,
                  decoration: const InputDecoration(labelText: "Opportunity Name"),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _expectedRevenueController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Expected Revenue"),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _closingDateController,
                  readOnly: true,
                  onTap: _pickClosingDate,
                  decoration: const InputDecoration(
                    labelText: "Tentative Closing Date",
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              /// Backend Action Required
              TextField(
                controller: _backendController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText:
                      "Any action required from backend team / Raised tickets",
                ),
              ),
              const SizedBox(height: 16),

              /// Joint Working
              TextField(
                controller: _jointWorkingController,
                decoration:
                    const InputDecoration(labelText: "Joint Working With"),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            // Save logic later
            Navigator.pop(context);
          },
          child: const Text("Save Visit"),
        ),
      ],
    );
  }
}

class FollowupDialog extends StatefulWidget {
  const FollowupDialog({super.key});

  @override
  State<FollowupDialog> createState() => _FollowupDialogState();
}

class _FollowupDialogState extends State<FollowupDialog> {
  final _formKey = GlobalKey<FormState>();

  String _mode = "Call";
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();

  String _temperature = "Warm";
  double _confidence = 50;
  String _outcome = "Continue Followup";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Follow-up"),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Followup Mode
                DropdownButtonFormField<String>(
                  initialValue: _mode,
                  decoration: const InputDecoration(labelText: "Followup Mode"),
                  items: ["Call", "Visit", "Email", "WhatsApp"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => _mode = val!),
                ),
                const SizedBox(height: 16),

                /// Date & Time
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _dateController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: "Followup Date",
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate:
                                DateTime.now().add(const Duration(days: 1)),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) {
                            _dateController.text =
                                "${picked.day}/${picked.month}/${picked.year}";
                          }
                        },
                        validator: (val) => val!.isEmpty ? "Required" : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _timeController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: "Reminder Time",
                          suffixIcon: Icon(Icons.access_time),
                        ),
                        onTap: () async {
                          TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (!mounted) return;
                          if (picked != null) {
                            _timeController.text = _formatTimeOfDay(picked);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                /// Conversation Summary
                TextFormField(
                  controller: _summaryController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Conversation Summary",
                    alignLabelWithHint: true,
                  ),
                  validator: (val) => val!.isEmpty ? "Mandatory" : null,
                ),
                const SizedBox(height: 16),

                /// Lead Temperature
                const Text("Lead Temperature",
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Row(
                  children: ["Hot 🔥", "Warm", "Cold"].map((temp) {
                    final isSelected = _temperature == temp;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(temp),
                        selected: isSelected,
                        onSelected: (val) =>
                            setState(() => _temperature = temp),
                        selectedColor: Colors.blue.withAlpha((0.2 * 255).round()),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.blue : Colors.black,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                /// Deal Confidence
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Deal Confidence",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    Text("${_confidence.toInt()}%"),
                  ],
                ),
                Slider(
                  value: _confidence,
                  min: 0,
                  max: 100,
                  divisions: 100,
                  label: "${_confidence.toInt()}%",
                  onChanged: (val) => setState(() => _confidence = val),
                ),
                const SizedBox(height: 16),

                /// Next Outcome
                DropdownButtonFormField<String>(
                  initialValue: _outcome,
                  decoration:
                      const InputDecoration(labelText: "Next Outcome"),
                  items: [
                    "Continue Followup",
                    "Convert to Opportunity",
                    "Disqualify"
                  ]
                      .map((e) =>
                          DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => _outcome = val!),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context);
            }
          },
          child: const Text("Save"),
        ),
      ],
    );
  }

  String _formatTimeOfDay(TimeOfDay t) {
    final int hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final String minute = t.minute.toString().padLeft(2, '0');
    final String period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}

class ConvertDialog extends StatelessWidget {
  const ConvertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Convert to Opportunity"),
      content: const Text("Lead will be converted to Opportunity."),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Convert"),
        ),
      ],
    );
  }
}
class DisqualifyDialog extends StatefulWidget {
  const DisqualifyDialog({super.key});

  @override
  State<DisqualifyDialog> createState() => _DisqualifyDialogState();
}

class _DisqualifyDialogState extends State<DisqualifyDialog> {
  final _formKey = GlobalKey<FormState>();
  String? _reason;
  final TextEditingController _remarksController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Disqualify Lead"),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: _reason,
                decoration: const InputDecoration(labelText: "Reason"),
                items: [
                  "Not Interested",
                  "Lost to Competitor",
                  "Budget Constraints",
                  "Invalid Contact",
                  "Other"
                ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => _reason = val),
                validator: (val) => val == null ? "Required" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _remarksController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: "Remarks"),
                validator: (val) =>
                    (val == null || val.isEmpty) ? "Required" : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context);
            }
          },
          child: const Text("Disqualify"),
        ),
      ],
    );
  }
}
