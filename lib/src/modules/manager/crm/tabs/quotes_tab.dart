import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../logic.dart';
import '../models/crm_activity_models.dart';
import '../widgets/crm_action_button.dart';
import '../widgets/crm_blank_state.dart';
import '../widgets/crm_section_header.dart';
import '../widgets/quote_card.dart';
import 'quote_form_view.dart';

/// Quotes tab (reference screen 3): "Quotes & Proposals" header with
/// + New Quote, then either the empty state or the quote list.
class QuotesTab extends StatelessWidget {
  final CrmLogic logic;

  const QuotesTab({super.key, required this.logic});

  Future<void> _newQuote() async {
    final result = await Get.to<QuoteModel>(
      () => QuoteFormView(
        id: logic.newQuoteId(),
        number: logic.nextQuoteNumber(),
        organizationNames: logic.organizations.map((o) => o.name).toList(),
      ),
    );
    if (result != null) logic.addQuote(result);
  }

  // STUB: generate and share a branded PDF once a PDF package is chosen.
  void _pdf(BuildContext context, QuoteModel quote) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('PDF export for ${quote.number} is not wired yet.')),
      );
  }

  @override
  Widget build(BuildContext context) {
    final quotes = logic.quotes;

    return ListView(
      children: [
        CrmSectionHeader(
          icon: Icons.assignment_outlined,
          title: 'Quotes & Proposals',
          count: quotes.length,
          actions: [
            CrmActionButton(label: 'New Quote', icon: Icons.add, onTap: _newQuote),
          ],
        ),
        const SizedBox(height: 12),
        if (quotes.isEmpty)
          CrmBlankState(
            icon: Icons.assignment_outlined,
            circled: false,
            title: 'No quotes yet',
            message: 'Build branded proposals you can send as PDFs.',
            buttonLabel: 'New Quote',
            onButton: _newQuote,
          )
        else
          for (final quote in quotes)
            QuoteCard(
              key: ValueKey(quote.id),
              quote: quote,
              onStatusChanged: (s) => logic.setQuoteStatus(quote.id, s),
              onPdf: () => _pdf(context, quote),
            ),
      ],
    );
  }
}
