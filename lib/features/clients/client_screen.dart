import 'package:flutter/material.dart';
import 'add_client_screen.dart';
import '../../shared/widgets/primary_button.dart';

class ClientContent extends StatefulWidget {
  const ClientContent({super.key});

  @override
  State<ClientContent> createState() => _ClientContentState();
}

class _ClientContentState extends State<ClientContent> {
  String searchQuery = "";

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

  List<Map<String, String>> get filteredClients {
    return clients.where((client) {
      return client["name"]!
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Padding(
      padding: const EdgeInsets.all(20),
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

          /// SEARCH
          SizedBox(
            width: 350,
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Search Client...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// TABLE OR CARDS
          Expanded(
            child: SingleChildScrollView(
              child: isMobile
                  ? Column(
                      children: filteredClients
                          .map((client) => _buildClientCard(client))
                          .toList(),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: 1100,
                          child: Column(
                            children: [
                              _buildHeaderRow(),
                              ...filteredClients
                                  .map((client) => _buildClientRow(client)),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientCard(Map<String, String> client) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  client["name"] ?? "",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    client["status"] ?? "",
                    style:
                        TextStyle(fontSize: 12, color: Colors.blue.shade700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _cardRow(Icons.location_city, client["city"]),
            _cardRow(Icons.business, client["model"]),
            _cardRow(Icons.layers, client["vertical"]),
            _cardRow(Icons.phone, client["mobile"]),
          ],
        ),
      ),
    );
  }

  Widget _cardRow(IconData icon, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value ?? "-",
              style: const TextStyle(fontSize: 14, color: Colors.black87),
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
          _HeaderCell("Client Name"),
          _HeaderCell("City"),
          _HeaderCell("Model"),
          _HeaderCell("Vertical"),
          _HeaderCell("Mobile"),
          _HeaderCell("Status"),
        ],
      ),
    );
  }

  Widget _buildClientRow(Map<String, String> item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: Row(
        children: [
          _DataCell(item["name"]),
          _DataCell(item["city"]),
          _DataCell(item["model"]),
          _DataCell(item["vertical"]),
          _DataCell(item["mobile"]),
          _DataCell(item["status"]),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  const _HeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}

class _DataCell extends StatelessWidget {
  final String? text;
  const _DataCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Text(text ?? "-"));
  }
}
