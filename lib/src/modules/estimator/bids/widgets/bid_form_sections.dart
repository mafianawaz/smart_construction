import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';

import '../data/create_bid_mock_data.dart';
import '../logic/create_bid_logic.dart';
import 'bid_fields.dart';
import 'bid_form_section.dart';

/// Form sections shared by the AI flow's Details step
/// (`BidInfoStepView`) and the manual flow's Details step
/// (`BidDetailsReviewView`), so both write to the same controllers.

const _gap = SizedBox(height: 12);

class BidBasicsSection extends StatelessWidget {
  final CreateBidLogic logic;
  const BidBasicsSection({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    return BidFormSection(
      title: 'Bid Details',
      subtitle: 'Give this bid a name and set the date it applies to.',
      children: [
        CustomTextField(
            heading: 'Bid Name', controller: logic.bidNameCtrl, hintText: 'e.g. Q3 CD'),
        _gap,
        Obx(() => BidDateField(
              label: 'Bid Date',
              value: logic.bidDate.value,
              onChanged: logic.setBidDate,
            )),
      ],
    );
  }
}

/// Manual flow only (muted card with "Link to CRM" in the Figma).
class BidCrmSection extends StatelessWidget {
  final CreateBidLogic logic;
  const BidCrmSection({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    return BidFormSection(
      title: 'CRM Integration',
      muted: true,
      trailing: TextButton(
        onPressed: logic.useSavedContact,
        child: const Text('Link to CRM'),
      ),
      children: [
        Obx(() => BidDropdownField(
              label: 'CRM Contact / Organization',
              hint: 'Select CRM contact',
              options: CreateBidMockData.crmContacts,
              value: logic.crmContactOrg.value,
              onChanged: (v) => logic.crmContactOrg.value = v,
            )),
        _gap,
        Obx(() => BidDropdownField(
              label: 'Organization Status',
              hint: 'Select organization status',
              options: CreateBidMockData.orgStatuses,
              value: logic.crmOrgStatus.value,
              onChanged: (v) => logic.crmOrgStatus.value = v,
            )),
      ],
    );
  }
}

class BidClientSection extends StatelessWidget {
  final CreateBidLogic logic;
  final String title;
  final String? subtitle;
  final bool showSavedContact;
  final bool showEstimatedAmount;

  const BidClientSection({
    super.key,
    required this.logic,
    this.title = 'Client Details',
    this.subtitle,
    this.showSavedContact = false,
    this.showEstimatedAmount = false,
  });

  @override
  Widget build(BuildContext context) {
    return BidFormSection(
      title: title,
      subtitle: subtitle,
      children: [
        if (showSavedContact) ...[
          InkWell(
            onTap: logic.useSavedContact,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Use saved contact',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7F7EE),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'CRM Contacts',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1FA463)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _gap,
        ],
        CustomTextField(
            heading: 'Client Name', controller: logic.orgNameCtrl,hintText: 'Name',),
        _gap,
        CustomTextField(heading: 'Contact Name', controller: logic.contactNameCtrl,hintText: 'Name',),
        _gap,
        CustomTextField(
          heading: 'Contact Email',
          controller: logic.contactEmailCtrl,
          keyboardType: TextInputType.emailAddress,
          hintText: 'Email',
        ),
        _gap,
        CustomTextField(
          heading: 'Contact Phone',
          controller: logic.contactPhoneCtrl,
          keyboardType: TextInputType.phone,
          hintText: 'Phone',
        ),
        if (showEstimatedAmount) ...[
          _gap,
          BidTextField(
            label: 'Est. Amount',
            controller: logic.estimatedAmountCtrl,
            hint: 'e.g. 50000',
            keyboardType: TextInputType.number,
          ),
        ],
      ],
    );
  }
}

class BidLocationSection extends StatelessWidget {
  final CreateBidLogic logic;
  final String title;
  final bool showKeywords;

  const BidLocationSection({
    super.key,
    required this.logic,
    this.title = 'Project Location',
    this.showKeywords = false,
  });

  @override
  Widget build(BuildContext context) {
    return BidFormSection(
      title: title,
      children: [
        CustomTextField(heading: 'Address', controller: logic.addressCtrl, hintText: 'Address',),
        _gap,
        CustomTextField(
          heading: 'City',
          controller: logic.cityCtrl,
          hintText: 'City',
        ),
       _gap,
        CustomTextField(
            heading: 'State', controller: logic.stateCtrl, hintText: 'State',),
        _gap,
        CustomTextField(
          heading: 'Description / Notes',
          controller: logic.locationNotesCtrl,
          maxLines: 3,
          hintText: 'Describe the project',
        ),
        if (showKeywords) ...[
          _gap,
          BidTextField(
            label: 'Setup Text-to-Text Keywords',
            controller: logic.keywordsCtrl,
            hint: 'e.g. CONTRACT2026',
          ),
        ],
      ],
    );
  }
}

/// Green "ready" banner at the bottom of the manual flow's Details step.
class BidReadyBanner extends StatelessWidget {
  const BidReadyBanner({super.key});

  @override
  Widget build(BuildContext context) {
    // AppColors.success is unconfirmed — literal green placeholder.
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE7F7EE),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        children: [
          Icon(Icons.check_circle, color: Color(0xFF1FA463), size: 18),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Everything looks good & ready for submission.',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

/// Orange full-width primary button used at the bottom of wizard screens.
class BidPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  const BidPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryOrange,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: loading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : Text(label),
      ),
    );
  }
}
