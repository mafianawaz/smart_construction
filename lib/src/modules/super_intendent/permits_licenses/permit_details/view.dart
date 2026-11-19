import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../widgets/app_appbar.dart';
import '../models/permit_models.dart';
import '../widgets/permit_expiry_pill.dart';
import '../widgets/permits_palette.dart';


/// Read-only details. Not in the reference design — layout is my own.
/// No controller; the model is passed directly (same as other detail screens).
class PermitDetailsView extends StatelessWidget {
  final PermitModel permit;

  const PermitDetailsView({super.key, required this.permit});

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('MMM d, yyyy');
    return Scaffold(
      appBar: AppPrimaryBar(
        title: 'Permits & Licenses',
        subtitle: permit.projectName,
        showBackButton: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: PermitsPalette.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: PermitsPalette.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              permit.displayTitle,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: PermitsPalette.textDark,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          PermitExpiryPill(permit: permit),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _Field('PROJECT', permit.projectName),
                      _Field('PERMIT TYPE', permit.name),
                      _Field('PERMIT NUMBER', permit.number),
                      _Field('ISSUING AUTHORITY', permit.issuingAuthority),
                      _Field('ISSUED', fmt.format(permit.issuedDate)),
                      _Field('EXPIRES', fmt.format(permit.expiryDate)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final String value;

  const _Field(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: PermitsPalette.textMuted,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: PermitsPalette.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
