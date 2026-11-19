import 'package:flutter/material.dart';

import 'crm_palette.dart';

/// White search box with an optional trailing filter button.
///
/// Stateful so the text survives tab switches: the field is re-seeded from
/// [initialValue], which the logic keeps.
class CrmSearchField extends StatefulWidget {
  final String hint;
  final String initialValue;
  final ValueChanged<String> onChanged;

  /// When non-null a funnel icon is shown at the end of the field.
  final VoidCallback? onFilterTap;
  final bool filterActive;

  const CrmSearchField({
    super.key,
    required this.hint,
    required this.onChanged,
    this.initialValue = '',
    this.onFilterTap,
    this.filterActive = false,
  });

  @override
  State<CrmSearchField> createState() => _CrmSearchFieldState();
}

class _CrmSearchFieldState extends State<CrmSearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        color: CrmPalette.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: CrmPalette.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 18, color: CrmPalette.textFaint),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: widget.onChanged,
              style: const TextStyle(fontSize: 13, color: CrmPalette.text),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: const TextStyle(
                  fontSize: 13,
                  color: CrmPalette.textFaint,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (widget.onFilterTap != null)
            InkWell(
              onTap: widget.onFilterTap,
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SizedBox(
                  height: 44,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.filter_alt_outlined,
                        size: 20,
                        color: widget.filterActive
                            ? CrmPalette.orange
                            : CrmPalette.textMuted,
                      ),
                      if (widget.filterActive)
                        Positioned(
                          top: 11,
                          right: 0,
                          child: Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: CrmPalette.orange,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
