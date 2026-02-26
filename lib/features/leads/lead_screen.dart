import 'package:flutter/material.dart';
import 'add_lead_screen.dart';
import 'lead_detail_screen.dart';
import '../../shared/widgets/primary_button.dart';

class LeadContent extends StatefulWidget {
  const LeadContent({super.key});

  @override
  State<LeadContent> createState() => _LeadContentState();
}

class _LeadContentState extends State<LeadContent> {
  String searchQuery = "";

  final List<Map<String, String>> allLeads = [
    {
      "date": "01 Mar 2026",
      "name": "Dr. Sharma",
      "leadType": "New Doctor",
      "leadSource": "Field Visit",
      "mobile": "9876543210",
      "email": "drsharma@gmail.com",
      "city": "Ahmedabad",
      "revenue": "30000",
      "assigned": "Self",
    },
    {
      "date": "02 Mar 2026",
      "name": "Apollo Clinic",
      "leadType": "New Client",
      "leadSource": "Website",
      "mobile": "9988776655",
      "email": "apollo@gmail.com",
      "city": "Surat",
      "revenue": "50000",
      "assigned": "ASM - Raj",
    },
    {
      "date": "02 Mar 2026",
      "name": "Apollo Clinic1",
      "leadType": "New Client",
      "leadSource": "Website",
      "mobile": "9988776655",
      "email": "apollo@gmail.com",
      "city": "Surat",
      "revenue": "50000",
      "assigned": "ASM - Raj",
    },
    {
      "date": "02 Mar 2026",
      "name": "Apollo Clinic2",
      "leadType": "New Client",
      "leadSource": "Website",
      "mobile": "9988776655",
      "email": "apollo@gmail.com",
      "city": "Surat",
      "revenue": "50000",
      "assigned": "ASM - Raj",
    },
    {
      "date": "02 Mar 2026",
      "name": "Apollo Clinic3",
      "leadType": "New Client",
      "leadSource": "Website",
      "mobile": "9988776655",
      "email": "apollo@gmail.com",
      "city": "Surat",
      "revenue": "50000",
      "assigned": "ASM - Raj",
    },
  ];

  List<Map<String, String>> get filteredLeads {
    return allLeads.where((lead) {
      return lead["name"]!
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
                      "Leads",
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w600),
                    ),
                    PrimaryButton(
                      text: "Add Lead",
                      icon: Icons.add,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddLeadScreen()),
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
                      hintText: "Search Lead...",
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
                            children: filteredLeads
                                .map((lead) => _buildLeadCard(lead))
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
                            ...filteredLeads.map((lead) => _buildLeadRow(lead)),
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

  Widget _buildLeadCard(Map<String, String> lead) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LeadDetailScreen(lead: lead)),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    lead["name"] ?? "",
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
                      lead["leadType"] ?? "",
                      style:
                          TextStyle(fontSize: 12, color: Colors.blue.shade700),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _cardRow(Icons.calendar_today, lead["date"]),
              _cardRow(Icons.phone, lead["mobile"]),
              _cardRow(Icons.email, lead["email"]),
              _cardRow(Icons.location_city, lead["city"]),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "₹ ${lead["revenue"]}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.green),
                  ),
                  Text(
                    lead["assigned"] ?? "",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ],
          ),
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

  // ========================
  // HEADER ROW
  // ========================

  Widget _buildHeaderRow() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: const Row(
        children: [
          _HeaderCell("Date"),
          _HeaderCell("Name"),
          _HeaderCell("Lead Type"),
          _HeaderCell("Lead Source"),
          _HeaderCell("Mobile"),
          _HeaderCell("Email"),
          _HeaderCell("City"),
          _HeaderCell("Revenue"),
          _HeaderCell("Assigned"),
        ],
      ),
    );
  }

  Widget _buildLeadRow(Map<String, String> lead) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LeadDetailScreen(lead: lead)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey)),
        ),
        child: Row(
          children: [
            _DataCell(lead["date"]),
            _DataCell(lead["name"]),
            _DataCell(lead["leadType"]),
            _DataCell(lead["leadSource"]),
            _DataCell(lead["mobile"]),
            _DataCell(lead["email"]),
            _DataCell(lead["city"]),
            _DataCell("₹ ${lead["revenue"]}"),
            _DataCell(lead["assigned"]),
          ],
        ),
      ),
    );
  }
}

// ========================
// TABLE CELLS
// ========================

class _HeaderCell extends StatelessWidget {
  final String text;
  const _HeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(text,
          style: const TextStyle(fontWeight: FontWeight.w600)),
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
