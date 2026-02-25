import 'package:flutter/material.dart';

// Export all the MSL screens
export 'msl_list_screen.dart';
export 'msl_mapping_screen.dart';
export 'msl_compliance_screen.dart';
export 'msl_performance_screen.dart';
export 'msl_target_achievement_screen.dart';

// Reusable card data model
class MslCardData {
  final String title;
  final String value;
  final String growth;
  final Color color;

  const MslCardData({
    required this.title,
    required this.value,
    required this.growth,
    required this.color,
  });
}

// Base screen widget for all MSL pages
class MslBaseScreen extends StatefulWidget {
  final String title;
  final List<MslCardData> cards;
  final List<String> tableColumns;
  final List<List<String>> tableRows;

  const MslBaseScreen({
    super.key,
    required this.title,
    required this.cards,
    required this.tableColumns,
    required this.tableRows,
  });

  @override
  State<MslBaseScreen> createState() => _MslBaseScreenState();
}

class _MslBaseScreenState extends State<MslBaseScreen> {
  DateTimeRange? _selectedDateRange;
  String _selectedZone = "All";
  String _selectedMsl = "All";

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    int crossAxisCount = 4;
    if (width < 1200) crossAxisCount = 3;
    if (width < 800) crossAxisCount = 2;
    if (width < 600) crossAxisCount = 1;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header & Filters
          Text(
            widget.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildDateFilter(),
              _buildDropdownFilter(
                "Zone",
                ["All", "North", "South", "East", "West"],
                _selectedZone,
                (val) => setState(() => _selectedZone = val!),
              ),
              _buildDropdownFilter(
                "MSL",
                ["All", "Dr. Anjali", "Dr. Vikram", "Dr. Priya"],
                _selectedMsl,
                (val) => setState(() => _selectedMsl = val!),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Summary Cards
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.6,
            ),
            itemCount: widget.cards.length,
            itemBuilder: (context, index) => _buildSummaryCard(widget.cards[index]),
          ),
          const SizedBox(height: 24),

          // Chart Placeholder
          Container(
            height: 300,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Trend Analysis", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Expanded(child: _buildDummyChart()),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Data Table
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: widget.tableColumns.map((c) => DataColumn(label: Text(c, style: const TextStyle(fontWeight: FontWeight.bold)))).toList(),
                rows: widget.tableRows.map((row) => DataRow(cells: row.map((c) => DataCell(Text(c))).toList())).toList(),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildDateFilter() {
    String text = "Select Date Range";
    if (_selectedDateRange != null) {
      text =
          "${_selectedDateRange!.start.day.toString().padLeft(2, '0')}/${_selectedDateRange!.start.month.toString().padLeft(2, '0')}/${_selectedDateRange!.start.year} - ${_selectedDateRange!.end.day.toString().padLeft(2, '0')}/${_selectedDateRange!.end.month.toString().padLeft(2, '0')}/${_selectedDateRange!.end.year}";
    }

    return InkWell(
      onTap: () async {
        final picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
          initialDateRange: _selectedDateRange,
        );
        if (picked != null) {
          setState(() => _selectedDateRange = picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
            const SizedBox(width: 8),
            Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(width: 8),
            const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownFilter(String label, List<String> items, String selectedValue, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(selectedValue) ? selectedValue : items.first,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value == "All" ? "$label: All" : value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(MslCardData data) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      clipBehavior: Clip.hardEdge,
      child: Row(
        children: [
          Container(width: 4, color: data.color),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(data.title, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                  const SizedBox(height: 8),
                  Text(data.value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(data.growth, style: TextStyle(color: data.growth.contains('+') ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDummyChart() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(7, (index) {
        final height = [100.0, 140.0, 120.0, 180.0, 160.0, 200.0, 150.0][index];
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 30,
              height: height,
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.7),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              ),
            ),
            const SizedBox(height: 8),
            Text(["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][index], style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        );
      }),
    );
  }
}