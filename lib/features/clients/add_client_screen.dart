import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class AddClientScreen extends StatefulWidget {
  const AddClientScreen({super.key});

  @override
  State<AddClientScreen> createState() => _AddClientScreenState();
}

class _AddClientScreenState extends State<AddClientScreen> {
  final _formKey = GlobalKey<FormState>();

  Widget buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget buildDropdown(String label, List<String> items) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (_) {},
      ),
    );
  }

  Widget buildUploadField(String label) {
    String? selectedFile;

    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),

              OutlinedButton.icon(
                icon: const Icon(Icons.upload_file, size: 18),
                label: const Text("Upload"),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(140, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform
                      .pickFiles();

                  if (result != null) {
                    setState(() {
                      selectedFile = result.files.single.name;
                    });
                  }
                },
              ),

              const SizedBox(height: 6),

              Text(
                selectedFile ?? "No file selected",
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildSection(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            LayoutBuilder(
              builder: (context, constraints) {
                double width = constraints.maxWidth > 1200
                    ? constraints.maxWidth / 4
                    : constraints.maxWidth > 800
                    ? constraints.maxWidth / 2
                    : constraints.maxWidth;

                return Wrap(
                  children: children
                      .map((e) => SizedBox(width: width, child: e))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Client")),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              /// Business Classification
              buildSection("Business Classification", [
                buildDropdown("Business Model", [
                  "B2B",
                  "B2I",
                  "B2D",
                  "SIS",
                  "FOFO",
                ]),
                buildDropdown("Revenue Vertical", [
                  "Clinical Trial",
                  "Corporate",
                  "Govt",
                ]),
                buildDropdown("Business Category", ["APSC", "B2B", "Retail"]),
                buildDropdown("Nature of Entity", [
                  "Individual",
                  "LLP",
                  "Pvt Ltd",
                ]),
                buildDropdown("Type of Party", ["Company", "Hospital", "Lab"]),
              ]),

              /// Firm Details
              buildSection("Firm / Client Details", [
                buildTextField("Name of Firm"),
                buildTextField("Invoice Name"),
                buildDropdown("Salutation", ["Mr", "Mrs", "Dr"]),
                buildDropdown("Lab Tagged", ["Lab A", "Lab B"]),
                buildDropdown("Price List", ["Price List 1"]),
                buildDropdown("Sales Person", ["Sales 1"]),
              ]),

              /// Address
              buildSection("Address Details", [
                buildTextField("Registered Address"),
                buildTextField("Billing Address"),
                buildDropdown("State", ["Delhi", "UP"]),
                buildDropdown("City", ["Noida", "Gurgaon"]),
                buildTextField("PIN Code"),
              ]),

              /// Primary Contact
              buildSection("Primary Contact", [
                buildTextField("Signatory Name"),
                buildTextField("Designation"),
                buildTextField("Mobile"),
                buildTextField("Email"),
                buildTextField("PAN Number"),
                buildDropdown("GST Registered", ["Yes", "No"]),
              ]),

              /// KYC Uploads
              buildSection("KYC & Compliance", [
                buildDropdown("Identity Proof Type", ["Aadhar", "PAN"]),
                buildUploadField("Identity Proof Document"),
                buildDropdown("Address Proof Type", ["Electricity Bill"]),
                buildUploadField("Address Proof Document"),
                buildUploadField("PAN Card Upload"),
                buildUploadField("Aadhar Card Upload"),
                buildUploadField("Registration Certificate"),
                buildUploadField("Cancelled Cheque"),
              ]),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {},
                child: const Text("Submit Client"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
