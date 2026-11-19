import 'package:flutter/material.dart';

/// One column of a [FinancialTable].
class FinancialColumn {
  final String label;
  final double width;
  final bool alignRight;
  const FinancialColumn(this.label, this.width, {this.alignRight = false});
}

/// Horizontally scrolling table used by Budget and Cost Ledger (the
/// reference's "Table" frames are wider than the screen). Header row on a
/// light grey band, body rows built by the caller as one widget per cell,
/// an [emptyMessage] row when there are no rows, and an optional bold
/// [footer] (the "Project Total" row).
class FinancialTable extends StatelessWidget {
  final List<FinancialColumn> columns;
  final List<List<Widget>> rows;
  final List<Widget>? footer;
  final String emptyMessage;

  const FinancialTable({
    super.key,
    required this.columns,
    required this.rows,
    this.footer,
    required this.emptyMessage,
  });

  double get _width => columns.fold(0.0, (s, c) => s + c.width);

  Widget _row(List<Widget> cells, {Color? background, bool top = false}) {
    return Container(
      width: _width,
      decoration: BoxDecoration(
        color: background,
        border: top ? Border(top: BorderSide(color: Colors.grey.shade200)) : null,
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          for (var i = 0; i < columns.length; i++)
            SizedBox(
              width: columns[i].width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Align(
                  alignment:
                      columns[i].alignRight ? Alignment.centerRight : Alignment.centerLeft,
                  child: cells[i],
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(10),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _row(
                [
                  for (final c in columns)
                    Text(c.label,
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700)),
                ],
                background: Colors.grey.shade50,
              ),
              if (rows.isEmpty)
                Container(
                  width: _width < 300 ? 300 : _width,
                  padding: const EdgeInsets.symmetric(vertical: 22),
                  decoration:
                      BoxDecoration(border: Border(top: BorderSide(color: Colors.grey.shade200))),
                  child: Center(
                    child: Text(emptyMessage,
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                  ),
                )
              else
                for (final r in rows) _row(r, top: true),
              if (footer != null) _row(footer!, background: Colors.grey.shade50, top: true),
            ],
          ),
        ),
      ),
    );
  }
}

/// Plain cell text styles so Budget and Cost Ledger stay consistent.
const TextStyle financialCellStyle = TextStyle(fontSize: 10);
const TextStyle financialCellBoldStyle = TextStyle(fontSize: 10, fontWeight: FontWeight.w700);
