import 'package:flutter/material.dart';
import 'msl_screen.dart';

class MslMappingScreen extends StatelessWidget {
  const MslMappingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MslBaseScreen(
      title: "MSL Mapping",
      cards: [
        MslCardData(title: "Total Mapped Doctors", value: "450", growth: "+20 this month", color: Colors.purple),
        MslCardData(title: "Avg. Doctors/MSL", value: "18", growth: "Stable", color: Colors.teal),
        MslCardData(title: "Unmapped Doctors", value: "15", growth: "High Priority", color: Colors.orange),
        MslCardData(title: "Mapping Overlap", value: "5", growth: "Needs review", color: Colors.red),
      ],
      tableColumns: ["MSL Name", "Mapped Doctor", "Doctor Specialty", "Zone", "Last Visit"],
      tableRows: [
        ["Dr. Anjali Sharma", "Dr. Mehta", "Cardiology", "North", "15 Mar 2024"],
        ["Dr. Anjali Sharma", "Dr. Iyer", "Cardiology", "North", "12 Mar 2024"],
        ["Dr. Vikram Singh", "Dr. Khan", "Oncology", "West", "18 Mar 2024"],
        ["Dr. Priya Patel", "Dr. Rao", "Neurology", "South", "10 Mar 2024"],
      ],
    );
  }
}