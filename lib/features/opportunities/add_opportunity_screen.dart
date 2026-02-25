import 'package:flutter/material.dart';

class AddOpportunityScreen extends StatefulWidget {
  final VoidCallback onClose;
  const AddOpportunityScreen({super.key, required this.onClose});

  @override
  State<AddOpportunityScreen> createState() => _AddOpportunityScreenState();
}

class _AddOpportunityScreenState extends State<AddOpportunityScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController revenueController = TextEditingController();
  final TextEditingController closeDateController = TextEditingController();
  final TextEditingController competitorController = TextEditingController();

  String assignedTo = "Self";
  String stage = "Qualification";
  double probability = 20;

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        closeDateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle("Basic Details"),
              _textField("Name", nameController, required: true),
              _textField("Mobile", mobileController, keyboard: TextInputType.phone),
              _textField("Email", emailController, keyboard: TextInputType.emailAddress),
              _textField("City", cityController),

              const SizedBox(height: 24),
              _sectionTitle("Commercials"),
              _textField("Expected Monthly Revenue", revenueController, keyboard: TextInputType.number),
              _dropdown("Assigned To", assignedTo, ["Self", "ASM - Raj", "RM - Karan"], (val) => setState(() => assignedTo = val!)),

              const SizedBox(height: 24),
              _sectionTitle("Stage & Probability"),
              _dropdown("Stage", stage, ["Qualification", "Needs Analysis", "Proposal", "Negotiation", "Closed Won", "Closed Lost"], (val) => setState(() => stage = val!)),
              
              const Text("Probability (%)", style: TextStyle(fontSize: 14, color: Colors.grey)),
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: probability,
                      min: 0,
                      max: 100,
                      divisions: 100,
                      label: "${probability.toInt()}%",
                      onChanged: (val) => setState(() => probability = val),
                    ),
                  ),
                  Text("${probability.toInt()}%", style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 16),

              TextField(
                controller: closeDateController,
                readOnly: true,
                onTap: _pickDate,
                decoration: _inputDecoration("Expected Close Date").copyWith(suffixIcon: const Icon(Icons.calendar_today)),
              ),
              const SizedBox(height: 16),

              _textField("Competitor", competitorController),

              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: widget.onClose,
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.onClose();
                        }
                      },
                      child: const Text("Save Opportunity"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
    );
  }

  Widget _textField(String label, TextEditingController controller, {TextInputType keyboard = TextInputType.text, bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        validator: required ? (val) => val!.isEmpty ? "Required" : null : null,
        decoration: _inputDecoration(label),
      ),
    );
  }

  Widget _dropdown(String label, String value, List<String> items, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
        decoration: _inputDecoration(label),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}