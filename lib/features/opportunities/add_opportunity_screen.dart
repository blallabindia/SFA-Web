import 'package:flutter/material.dart';

class AddOpportunityScreen extends StatefulWidget {
  const AddOpportunityScreen({super.key});

  @override
  State<AddOpportunityScreen> createState() => _AddOpportunityScreenState();
}

class _AddOpportunityScreenState extends State<AddOpportunityScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _closeDateController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  String _stage = "Qualification";
  String _account = "Apollo Hospital";
  String _owner = "Self";

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _closeDateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Opportunity")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle("Opportunity Details"),
              _textField("Topic / Name", _topicController, required: true),
              _dropdown("Account", _account, ["Apollo Hospital", "Dr. Sharma", "Sterling Hospital"], (val) => setState(() => _account = val!)),
              _dropdown("Stage", _stage, ["Qualification", "Proposal", "Negotiation", "Closed Won", "Closed Lost"], (val) => setState(() => _stage = val!)),
              
              Row(
                children: [
                  Expanded(child: _textField("Amount", _amountController, keyboard: TextInputType.number)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: _pickDate,
                      child: AbsorbPointer(
                        child: _textField("Est. Close Date", _closeDateController, suffixIcon: Icons.calendar_today),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              _sectionTitle("Ownership"),
              _dropdown("Owner", _owner, ["Self", "ASM - Raj", "RM - Karan"], (val) => setState(() => _owner = val!)),

              const SizedBox(height: 24),
              _sectionTitle("Remarks"),
              TextFormField(
                controller: _remarksController,
                maxLines: 4,
                decoration: _inputDecoration("Enter remarks"),
              ),

              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel"))),
                  const SizedBox(width: 16),
                  Expanded(child: ElevatedButton(onPressed: _save, child: const Text("Save Opportunity"))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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

  Widget _textField(String label, TextEditingController controller,
      {TextInputType keyboard = TextInputType.text, bool required = false, IconData? suffixIcon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        validator: required ? (val) => val!.isEmpty ? "Required" : null : null,
        decoration: _inputDecoration(label).copyWith(
          suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}