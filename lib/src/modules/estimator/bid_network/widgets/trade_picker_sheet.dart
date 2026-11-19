import 'package:flutter/material.dart';
import '../../../../utils/app_color.dart';
import '../models/bid_network_models.dart';

/// Multi-select checkbox list of trades ("scrollable-list" frame in the design).
/// Returns the chosen list via [onDone] when the sheet is dismissed with Done.
class TradePickerSheet extends StatefulWidget {
  const TradePickerSheet({
    super.key,
    required this.initial,
    required this.onDone,
    this.trades = kBidTrades,
  });

  final List<String> initial;
  final List<String> trades;
  final ValueChanged<List<String>> onDone;

  static Future<void> show(
    BuildContext context, {
    required List<String> initial,
    required ValueChanged<List<String>> onDone,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => TradePickerSheet(initial: initial, onDone: onDone),
    );
  }

  @override
  State<TradePickerSheet> createState() => _TradePickerSheetState();
}

class _TradePickerSheetState extends State<TradePickerSheet> {
  late final Set<String> _selected = {...widget.initial};

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 8, 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Select Trades (${_selected.length})',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      widget.onDone(
                        widget.trades.where(_selected.contains).toList(),
                      );
                      Navigator.of(context).pop();
                    },
                    child: Text('Done',
                        style: TextStyle(color: AppColors.primaryOrange)),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                itemCount: widget.trades.length,
                itemBuilder: (_, i) {
                  final trade = widget.trades[i];
                  final checked = _selected.contains(trade);
                  return InkWell(
                    onTap: () => setState(
                      () => checked ? _selected.remove(trade) : _selected.add(trade),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Row(
                        children: [
                          Checkbox(
                            value: checked,
                            activeColor: AppColors.primaryOrange,
                            visualDensity: VisualDensity.compact,
                            onChanged: (_) => setState(
                              () => checked
                                  ? _selected.remove(trade)
                                  : _selected.add(trade),
                            ),
                          ),
                          Expanded(
                            child: Text(trade, style: const TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
