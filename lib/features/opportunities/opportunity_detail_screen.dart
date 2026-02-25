import 'package:flutter/material.dart';
import 'create_proposal_dialog.dart';

class OpportunityDetailScreen extends StatefulWidget {
  final Map<String, String> opportunity;
  final VoidCallback onClose;

  const OpportunityDetailScreen({
    super.key,
    required this.opportunity,
    required this.onClose,
  });

  @override
  State<OpportunityDetailScreen> createState() =>
      _OpportunityDetailScreenState();
}

class _OpportunityDetailScreenState extends State<OpportunityDetailScreen> {
  late TextEditingController _nameController;
  late TextEditingController _mobileController;
  late TextEditingController _emailController;
  late TextEditingController _cityController;
  late TextEditingController _revenueController;
  late TextEditingController _stageController;
  late TextEditingController _competitorController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.opportunity["name"]);
    _mobileController = TextEditingController(text: widget.opportunity["mobile"]);
    _emailController = TextEditingController(text: widget.opportunity["email"]);
    _cityController = TextEditingController(text: widget.opportunity["city"]);
    _revenueController =
        TextEditingController(text: widget.opportunity["revenue"]);
    _stageController = TextEditingController(text: widget.opportunity["stage"]);
    _competitorController =
        TextEditingController(text: widget.opportunity["competitor"]);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    _revenueController.dispose();
    _stageController.dispose();
    _competitorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Opportunity Details",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              IconButton(
                onPressed: widget.onClose,
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),

        // Body
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField("Opportunity Name", _nameController),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                        child: _buildTextField("Mobile", _mobileController)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTextField("Email", _emailController)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildTextField("City", _cityController)),
                    const SizedBox(width: 16),
                    Expanded(
                        child:
                            _buildTextField("Exp. Revenue", _revenueController)),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField("Stage", _stageController),
                const SizedBox(height: 16),
                _buildTextField("Competitor", _competitorController),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const CreateProposalDialog(),
                      );
                    },
                    icon: const Icon(Icons.description),
                    label: const Text("Create Proposal"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.orange,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement Update logic
                      widget.onClose();
                    },
                    child: const Text("Update Opportunity"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}