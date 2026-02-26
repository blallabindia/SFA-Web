import 'package:flutter/material.dart';
import 'add_opportunity_screen.dart';
import '../../shared/widgets/primary_button.dart';

class OpportunityContent extends StatefulWidget {
  const OpportunityContent({super.key});

  @override
  State<OpportunityContent> createState() => _OpportunityContentState();
}

class _OpportunityContentState extends State<OpportunityContent> {
  String searchQuery = "";

  final List<Map<String, String>> opportunities = [
    {
      "topic": "Annual Maintenance Contract",
      "account": "Apollo Hospital",
      "stage": "Proposal",
      "amount": "1,50,000",
      "closeDate": "15 Apr 2026",
      "owner": "Self",
    },
    {
      "topic": "New Lab Setup",
      "account": "Dr. Lal PathLabs",
      "stage": "Negotiation",
      "amount": "5,00,000",
      "closeDate": "01 May 2026",
      "owner": "ASM - Raj",
    },
    {
      "topic": "Software Upgrade",
      "account": "Sterling Hospital",
      "stage": "Qualification",
      "amount": "75,000",
      "closeDate": "20 Mar 2026",
      "owner": "Self",
    },
  ];

  List<Map<String, String>> get filteredOpportunities {
    return opportunities.where((opp) {
      return opp["topic"]!.toLowerCase().contains(searchQuery.toLowerCase()) ||
             opp["account"]!.toLowerCase().contains(searchQuery.toLowerCase());
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
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Opportunities", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
              PrimaryButton(
                text: "Add Opportunity",
                icon: Icons.add,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddOpportunityScreen()));
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Search
          SizedBox(
            width: 350,
            child: TextField(
              onChanged: (val) => setState(() => searchQuery = val),
              decoration: InputDecoration(
                hintText: "Search Opportunity...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // List
          Expanded(
            child: SingleChildScrollView(
              child: isMobile 
                ? Column(children: filteredOpportunities.map((opp) => _buildOpportunityCard(opp)).toList())
                : Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: 1100,
                        child: Column(
                          children: [
                            _buildHeaderRow(),
                            ...filteredOpportunities.map((opp) => _buildOpportunityRow(opp)),
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

  Widget _buildOpportunityCard(Map<String, String> item) {
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
                Expanded(
                  child: Text(item["topic"] ?? "", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(4)),
                  child: Text(item["stage"] ?? "", style: TextStyle(fontSize: 12, color: Colors.blue.shade700)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(item["account"] ?? "", style: TextStyle(fontSize: 14, color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),
            _cardRow(Icons.currency_rupee, item["amount"]),
            _cardRow(Icons.calendar_today, item["closeDate"]),
            _cardRow(Icons.person, item["owner"]),
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
          Expanded(child: Text(value ?? "-", style: const TextStyle(fontSize: 14, color: Colors.black87))),
        ],
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey))),
      child: const Row(
        children: [
          Expanded(flex: 2, child: Text("Topic", style: TextStyle(fontWeight: FontWeight.w600))),
          Expanded(flex: 2, child: Text("Account", style: TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text("Stage", style: TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text("Amount", style: TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text("Close Date", style: TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text("Owner", style: TextStyle(fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  Widget _buildOpportunityRow(Map<String, String> item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey))),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(item["topic"] ?? "-")),
          Expanded(flex: 2, child: Text(item["account"] ?? "-")),
          Expanded(child: Text(item["stage"] ?? "-")),
          Expanded(child: Text("₹ ${item["amount"]}")),
          Expanded(child: Text(item["closeDate"] ?? "-")),
          Expanded(child: Text(item["owner"] ?? "-")),
        ],
      ),
    );
  }
}