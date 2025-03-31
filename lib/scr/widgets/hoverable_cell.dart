


import 'package:flutter/material.dart';

class HoverableDataTable extends StatefulWidget {
  final List<DataRow> rows;
  final List<DataColumn> columns;

  const HoverableDataTable({
    Key? key,
    required this.rows,
    required this.columns,
  }) : super(key: key);

  @override
  State<HoverableDataTable> createState() => _HoverableDataTableState();
}

class _HoverableDataTableState extends State<HoverableDataTable> {
  int? hoveredIndex;
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      headingRowHeight: 40,
      horizontalMargin: 16,
      columnSpacing: 24,
      headingRowColor: WidgetStateProperty.all(Colors.transparent),
      dataRowColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF1B3454); // Darker blue when selected
          }
          if (states.contains(WidgetState.hovered)) {
            return const Color(0xFF162C47); // Slightly lighter when hovered
          }
          return const Color(0xFF132A46); // Default background
        },
      ),
      border: const TableBorder(
        horizontalInside: BorderSide(
          color: Color(0xFF1E3A5C),
          width: 1,
        ),
      ),
      showCheckboxColumn: false,
      columns: widget.columns,
      rows: widget.rows.asMap().entries.map((entry) {
        final index = entry.key;
        final row = entry.value;
        
        return DataRow(
          color: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (index == selectedIndex) {
                return const Color(0xFF132A46); // Selected color
              }
              if (index == hoveredIndex) {
                return const Color(0xFF1B3B64); // Hover color
              }
              return null; // Default/transparent
            },
          ),
          onSelectChanged: (_) {
            setState(() {
              selectedIndex = index == selectedIndex ? null : index;
            });
          },
          cells: row.cells.map((cell) {
            return DataCell(
              MouseRegion(
                onEnter: (_) => setState(() => hoveredIndex = index),
                onExit: (_) => setState(() => hoveredIndex = null),
                child: cell.child,
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}