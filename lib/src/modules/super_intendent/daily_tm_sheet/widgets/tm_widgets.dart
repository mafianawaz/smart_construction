import 'package:flutter/material.dart';
import '../data/tm_format.dart';
import '../models/tm_models.dart';

/// Local palette stand-in (no guessed cross-feature imports).
class TmPalette {
  TmPalette._();

  static const orange = Color(0xFFF97316);
  static const text = Color(0xFF111827);
  static const label = Color(0xFF475569);
  static const muted = Color(0xFF6B7280);
  static const hint = Color(0xFF9CA3AF);
  static const border = Color(0xFFE5E7EB);
  static const fieldFill = Color(0xFFF3F4F6);
  static const pageBg = Color(0xFFF8FAFC);
  static const red = Color(0xFFEF4444);
  static const green = Color(0xFF16A34A);
  static const greenBg = Color(0xFFF0FDF4);
}

/// White rounded card with a soft shadow.
class TmCard extends StatelessWidget {
  const TmCard({super.key, required this.child, this.padding = const EdgeInsets.all(14)});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Color(0x0F000000), blurRadius: 10, offset: Offset(0, 2)),
        ],
      ),
      child: child,
    );
  }
}



/// One submitted sheet inside the Recent T&M Sheets card.
class TmSheetTile extends StatelessWidget {
  const TmSheetTile({super.key, required this.sheet});

  final TmSheet sheet;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: TmPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  TmFormat.shortDate(sheet.date),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: TmPalette.text),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: TmPalette.greenBg,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: TmPalette.green),
                ),
                child: const Text('SUBMITTED',
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: TmPalette.green)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            sheet.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, height: 1.35, color: TmPalette.muted),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              _meta(Icons.groups_outlined, 'Crew ${sheet.crewSize}'),
              if (sheet.weather.isNotEmpty) _meta(Icons.wb_sunny_outlined, sheet.weather),
              _meta(Icons.person_outline, sheet.companyRep),
            ],
          ),
        ],
      ),
    );
  }

  Widget _meta(IconData icon, String text) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: TmPalette.hint),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 10, color: TmPalette.muted)),
        ],
      );
}
