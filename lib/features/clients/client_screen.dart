import 'package:flutter/material.dart';
import 'add_client_screen.dart';
import '../../shared/widgets/primary_button.dart';

class ClientContent extends StatefulWidget {
  const ClientContent({super.key});

  @override
  State<ClientContent> createState() => _ClientContentState();
}

class _ClientContentState extends State<ClientContent> {
  final List<Map<String, String>> clients = [
    {
      "name": "Apollo Hospital",
      "city": "Ahmedabad",
      "model": "B2B",
      "vertical": "Corporate",
      "mobile": "9876543210",
      "status": "Active",
    },
    {
      "name": "Dr. Lal PathLabs",
      "city": "Surat",
      "model": "B2B",
      "vertical": "Trade",
      "mobile": "9988776655",
      "status": "Active",
    },
    {
      "name": "Sterling Hospital",
      "city": "Baroda",
      "model": "B2B",
      "vertical": "Hospital",
      "mobile": "9123456789",
      "status": "Onboarding",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Clients",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              PrimaryButton(
                text: "Add Client",
                icon: Icons.add,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddClientScreen()),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),

          /// TABLE
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black12)],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 1100,
                child: Column(
                  children: [
                    _buildHeaderRow(),
                    ...clients.map((client) => _buildRow(client)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: const Row(
        children: [
          Expanded(flex: 2, child: Text("Client Name", style: TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text("City", style: TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text("Model", style: TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text("Vertical", style: TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text("Mobile", style: TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text("Status", style: TextStyle(fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  Widget _buildRow(Map<String, String> item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(item["name"]!)),
          Expanded(child: Text(item["city"]!)),
          Expanded(child: Text(item["model"]!)),
          Expanded(child: Text(item["vertical"]!)),
          Expanded(child: Text(item["mobile"]!)),
          Expanded(child: Text(item["status"]!)),
        ],
      ),
    );
  }
}
