import 'package:flutter/material.dart';
import 'add_opportunity_screen.dart';
import 'opportunity_detail_screen.dart';
import '../../shared/widgets/primary_button.dart';

class OpportunityContent extends StatefulWidget {
  const OpportunityContent({super.key});

  @override
  State<OpportunityContent> createState() => _OpportunityContentState();
}

class _OpportunityContentState extends State<OpportunityContent> {
  bool showAddPanel = false;
  bool showDetailPanel = false;
  Map<String, String>? selectedOpportunity;

  final List<Map<String, String>> opportunities = [
    {
      "name": "Dr. Sharma",
      "mobile": "9876543210",
      "email": "dr.sharma@test.com",
      "city": "Ahmedabad",
      "revenue": "50,000",
      "assigned": "Self",
      "stage": "Negotiation",
      "closeDate": "15 Apr 2026",
      "probability": "80%",
      "competitor": "None",
    },
    {
      "name": "Apollo Clinic",
      "mobile": "9988776655",
      "email": "contact@apollo.com",
      "city": "Surat",
      "revenue": "1,20,000",
      "assigned": "ASM - Raj",
      "stage": "Proposal Sent",
      "closeDate": "30 Mar 2026",
      "probability": "60%",
      "competitor": "Thyrocare",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double panelWidth = screenWidth > 1200 ? 500 : screenWidth * 0.6;

    return Stack(
      children: [
        AnimatedPadding(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.only(right: (showAddPanel || showDetailPanel) ? panelWidth + 20 : 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Opportunities",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                    ),
                    PrimaryButton(
                      text: "Add Opportunity",
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
                      width: 1300,
                      child: Column(
                        children: [
                          _buildHeaderRow(),
                          ...opportunities.map((opp) => _buildRow(opp)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        /// ADD PANEL
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          right: showAddPanel ? 0 : -panelWidth,
          top: 0,
          bottom: 0,
          child: Material(
            elevation: 16,
            color: Colors.white,
            child: SizedBox(
              width: panelWidth,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Add Opportunity",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        IconButton(
                          onPressed: () => setState(() => showAddPanel = false),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: AddOpportunityScreen(
                    onClose: () => setState(() => showAddPanel = false),
                  )),
                ],
              ),
            ),
          ),
        ),

        /// DETAIL PANEL
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          right: showDetailPanel ? 0 : -panelWidth,
          top: 0,
          bottom: 0,
          child: Material(
            elevation: 16,
            color: Colors.white,
            child: SizedBox(
              width: panelWidth,
              child: selectedOpportunity == null
                  ? const SizedBox()
                  : OpportunityDetailScreen(
                      opportunity: selectedOpportunity!,
                      onClose: () => setState(() => showDetailPanel = false),
                    ),
            ),
          ),
        ),
      ],
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
          Expanded(flex: 2, child: Text("Name", style: TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text("Mobile", style: TextStyle(fontWeight: FontWeight.w600))),
          Expanded(flex: 2, child: Text("Email", style: TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text("City", style: TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text("Exp. Revenue", style: TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text("Assigned", style: TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text("Stage", style: TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text("Close Date", style: TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text("Prob. %", style: TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text("Competitor", style: TextStyle(fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  Widget _buildRow(Map<String, String> item) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOpportunity = item;
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
            Expanded(flex: 2, child: Text(item["name"]!)),
            Expanded(child: Text(item["mobile"]!)),
            Expanded(flex: 2, child: Text(item["email"]!)),
            Expanded(child: Text(item["city"]!)),
            Expanded(child: Text("₹ ${item["revenue"]}")),
            Expanded(child: Text(item["assigned"]!)),
            Expanded(child: Text(item["stage"]!)),
            Expanded(child: Text(item["closeDate"]!)),
            Expanded(child: Text(item["probability"]!)),
            Expanded(child: Text(item["competitor"]!)),
          ],
        ),
      ),
    );
  }
}
