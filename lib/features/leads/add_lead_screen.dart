import 'package:flutter/material.dart';

class AddLeadScreen extends StatefulWidget {
  const AddLeadScreen({super.key});

  @override
  State<AddLeadScreen> createState() => _AddLeadScreenState();
}

class _AddLeadScreenState extends State<AddLeadScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController revenueController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  String leadType = "New Doctor";
  String leadSource = "Field Visit";
  String city = "Ahmedabad";
  String state = "Gujarat";
  String pincode = "380001";
  String country = "India";
  String assignTo = "Self";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Lead")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              _sectionTitle("Basic Information"),

              _dropdown("Lead Type", leadType, [
                "New Doctor",
                "New Client",
                "Package Pitch"
              ], (val) => setState(() => leadType = val!)),

              _dropdown("Lead Source", leadSource, [
                "Field Visit",
                "Website",
                "Referral",
                "Call Center"
              ], (val) => setState(() => leadSource = val!)),

              _textField("Name", nameController, required: true),

              _textField("Mobile", mobileController,
                  keyboard: TextInputType.phone),

              _textField("Email", emailController,
                  keyboard: TextInputType.emailAddress),

              const SizedBox(height: 24),
              _sectionTitle("Location Details"),

              _dropdown("City", city, ["Ahmedabad", "Surat", "Baroda"],
                  (val) => setState(() => city = val!)),

              _dropdown("State", state, ["Gujarat", "Rajasthan"],
                  (val) => setState(() => state = val!)),

              _dropdown("Pincode", pincode, ["380001", "380015"],
                  (val) => setState(() => pincode = val!)),

              _dropdown("Country", country, ["India"],
                  (val) => setState(() => country = val!)),

              const SizedBox(height: 24),
              _sectionTitle("Commercial Details"),

              _textField("Expected Monthly Revenue",
                  revenueController,
                  keyboard: TextInputType.number),

              _dropdown("Assign To", assignTo,
                  ["Self", "ASM - Raj", "RM - Karan"],
                  (val) => setState(() => assignTo = val!)),

              const SizedBox(height: 24),

              _sectionTitle("Remarks"),

              TextFormField(
                controller: remarksController,
                maxLines: 4,
                decoration: _inputDecoration("Enter remarks"),
              ),

              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _saveDraft,
                      child: const Text("Save Draft"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveLead,
                      child: const Text("Save Lead"),
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
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _dropdown(String label, String value,
      List<String> items,
      Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        items: items
            .map((e) => DropdownMenuItem(
                value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
        decoration: _inputDecoration(label),
      ),
    );
  }

  Widget _textField(String label,
      TextEditingController controller,
      {TextInputType keyboard = TextInputType.text,
      bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        validator: required
            ? (val) =>
                val!.isEmpty ? "Required" : null
            : null,
        decoration: _inputDecoration(label),
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

  void _saveLead() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context);
    }
  }

  void _saveDraft() {
    Navigator.pop(context);
  }
}
