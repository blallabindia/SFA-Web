import 'package:flutter/material.dart';
import '../../shared/widgets/primary_button.dart';

class OpportunityContent extends StatefulWidget {
  const OpportunityContent({super.key});

  @override
  State<OpportunityContent> createState() => _OpportunityContentState();
}

class _OpportunityContentState extends State<OpportunityContent> {
  final List<Map<String, String>> opportunities = [
    {
      "name": "Apollo Hospital - Annual Contract",
      "customer": "Apollo Hospital",
      "value": "5,00,000",
      "stage": "Negotiation",
      "closeDate": "15 Apr 2026",
      "probability": "80%",
    },
    {
      "name": "Dr. Sharma Clinic - Lab Setup",
      "customer": "Dr. Sharma",
      "value": "1,20,000",
      "stage": "Proposal Sent",
      "closeDate": "30 Mar 2026",
      "probability": "60%",
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
                "Opportunities",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              PrimaryButton(
                text: "Add Opportunity",
                icon: Icons.add,
                onPressed: () {
                  // TODO: Open Add Panel
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
            child: Column(
              children: [
                _buildHeaderRow(),
                ...opportunities.map((opp) => _buildRow(opp)),
              ],
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
          Expanded(flex: 2, child: Text("Opportunity Name", style: TextStyle(fontWeight: FontWeight.w600))),
          Expanded(flex: 2, child: Text("Customer", style: TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text("Value", style: TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text("Stage", style: TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text("Close Date", style: TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text("Prob. %", style: TextStyle(fontWeight: FontWeight.w600))),
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
          Expanded(flex: 2, child: Text(item["customer"]!)),
          Expanded(child: Text("₹ ${item["value"]}")),
          Expanded(child: Text(item["stage"]!)),
          Expanded(child: Text(item["closeDate"]!)),
          Expanded(child: Text(item["probability"]!)),
        ],
      ),
    );
  }
}