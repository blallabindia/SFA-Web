import 'package:flutter/material.dart';
import 'visit_execution_model.dart';

class CheckInSection extends StatefulWidget {
  final VisitExecutionModel visit;
  final Function(String purpose, String location) onStartVisit;

  const CheckInSection({
    super.key,
    required this.visit,
    required this.onStartVisit,
  });

  @override
  State<CheckInSection> createState() => _CheckInSectionState();
}

class _CheckInSectionState extends State<CheckInSection> {
  String? _selectedPurpose;
  String _mockLocation = "Fetching location...";
  bool _isLoadingLocation = true;

  final List<String> _purposes = [
    "Intro",
    "Follow-up",
    "Negotiation",
    "Onboarding",
    "Collection",
    "Complaint"
  ];

  @override
  void initState() {
    super.initState();
    _fetchMockLocation();
  }

  Future<void> _fetchMockLocation() async {
    // Simulate GPS delay
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _mockLocation = "23.0225° N, 72.5714° E (Ahmedabad)";
        _isLoadingLocation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Start Visit (Check-in)",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        
        // Account Name (Read-only)
        TextFormField(
          initialValue: widget.visit.accountName,
          readOnly: true,
          decoration: const InputDecoration(
            labelText: "Account",
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Color(0xFFF5F5F5),
            prefixIcon: Icon(Icons.business),
          ),
        ),
        const SizedBox(height: 16),

        // Purpose Dropdown
        DropdownButtonFormField<String>(
          initialValue: _selectedPurpose,
          decoration: const InputDecoration(
            labelText: "Purpose",
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.flag),
          ),
          items: _purposes
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (val) => setState(() => _selectedPurpose = val),
        ),
        const SizedBox(height: 16),

        // GPS Location
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.location_on, color: Colors.blue),
          title: const Text("Current Location", style: TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold)),
          subtitle: Text(_mockLocation, style: const TextStyle(fontSize: 14)),
          trailing: _isLoadingLocation
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.check_circle, color: Colors.green, size: 18),
        ),
        const SizedBox(height: 24),

        // Start Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: (_selectedPurpose != null && !_isLoadingLocation)
                ? () => widget.onStartVisit(_selectedPurpose!, _mockLocation)
                : null,
            icon: const Icon(Icons.play_arrow),
            label: const Text("Start Visit"),
          ),
        ),
      ],
    );
  }
}