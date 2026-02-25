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
  bool showAddPanel = false;
  bool showDetailPanel = false;

  String searchQuery = "";
  Map<String, String>? selectedLead;

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
    final screenWidth = MediaQuery.of(context).size.width;
    final double panelWidth =
        screenWidth > 1200 ? 500 : screenWidth * 0.6;

    return Stack(
      children: [

        /// MAIN CONTENT
        AnimatedPadding(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.only(
              right: showAddPanel || showDetailPanel ? panelWidth + 20 : 20),
          child: SingleChildScrollView(
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
                        setState(() {
                          showDetailPanel = false;
                          showAddPanel = true;
                        });
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

                /// TABLE
                Container(
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
              ],
            ),
          ),
        ),

        /// ADD LEAD PANEL
        _buildRightPanel(
          show: showAddPanel,
          width: panelWidth,
          title: "Add Lead",
          onClose: () {
            setState(() => showAddPanel = false);
          },
          child: AddLeadScreen(onClose: () => setState(() => showAddPanel = false)),
        ),

        /// DETAIL PANEL
        _buildRightPanel(
          show: showDetailPanel,
          width: panelWidth,
          title: selectedLead?["name"] ?? "",
          onClose: () {
            setState(() => showDetailPanel = false);
          },
          child: selectedLead == null
              ? const SizedBox()
              : _buildDetailContent(),
        ),
      ],
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
        setState(() {
          selectedLead = lead;
          showAddPanel = false;
          showDetailPanel = true;
        });
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

  // ========================
  // DETAIL CONTENT
  // ========================

  Widget _buildDetailContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
    
            _detailRow("Mobile", selectedLead!["mobile"]),
            _detailRow("Email", selectedLead!["email"]),
            _detailRow("City", selectedLead!["city"]),
            _detailRow("Revenue", "₹ ${selectedLead!["revenue"]}"),
            _detailRow("Assigned", selectedLead!["assigned"]),
    
            const SizedBox(height: 30),
    
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _actionButton("Add Visit", Colors.blue, _openVisitDialog),
                _actionButton("Follow-up", Colors.orange, _openFollowupDialog),
                _actionButton("Convert to Opportunity", Colors.green, _openConvertDialog),
                _actionButton("Disqualify", Colors.red, _openDisqualifyDialog),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ========================
  // RIGHT PANEL BUILDER
  // ========================

  Widget _buildRightPanel({
    required bool show,
    required double width,
    required String title,
    required VoidCallback onClose,
    required Widget child,
  }) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      right: show ? 0 : -width,
      top: 0,
      bottom: 0,
      child: Material(
        elevation: 16,
        color: Colors.white,
        child: SizedBox(
          width: width,
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    IconButton(
                      onPressed: onClose,
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }

  // ========================
  // UTILITIES
  // ========================

  Widget _detailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          SizedBox(
              width: 140,
              child: Text(label,
                  style:
                      const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text(value ?? "-")),
        ],
      ),
    );
  }

  Widget _actionButton(
      String label, Color color, VoidCallback onTap) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      onPressed: onTap,
      child: Text(label),
    );
  }

  void _openVisitDialog() {
    showDialog(
      context: context,
      builder: (context) => const VisitDialog(),
    );
  }

  void _openFollowupDialog() {
    showDialog(
      context: context,
      builder: (context) => const FollowupDialog(),
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
