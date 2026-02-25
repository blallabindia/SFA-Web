import 'package:flutter/material.dart';
import 'msl_screen.dart';

class MslListScreen extends StatelessWidget {
  const MslListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MslBaseScreen(
      title: "MSL List",
      cards: [
        MslCardData(title: "Total MSLs", value: "25", growth: "+2 this month", color: Colors.blue),
        MslCardData(title: "Active MSLs", value: "22", growth: "92% Active", color: Colors.green),
        MslCardData(title: "Onboarding", value: "3", growth: "New Joiners", color: Colors.orange),
        MslCardData(title: "Exits", value: "1", growth: "Last Quarter", color: Colors.red),
      ],
      tableColumns: ["MSL Name", "Specialty", "Zone", "Contact", "Status"],
      tableRows: [
        ["Dr. Anjali Sharma", "Cardiology", "North", "9876543210", "Active"],
        ["Dr. Vikram Singh", "Oncology", "West", "9988776655", "Active"],
        ["Dr. Priya Patel", "Neurology", "South", "9123456789", "Onboarding"],
        ["Dr. Rohan Gupta", "Endocrinology", "East", "9876512345", "Active"],
      ],
    );
  }
}