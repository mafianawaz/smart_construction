import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_button.dart';
import 'package:smart_construction/src/widgets/app_empty_filter.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';
import '../../../../utils/app_color.dart';
import '../../calendar/model/calendar_event_model.dart';
import '../../calendar/widget/picker_field.dart';
import '../logic.dart';
import '../models/account_settings_models.dart';


class CertificationsSubTabView extends StatelessWidget {
  const CertificationsSubTabView({super.key, required this.logic});

  final AccountSettingsLogic logic;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My Certifications',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark),
        ),
        const SizedBox(height: 16),
        Text(
          'ADD CERTIFICATION',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 12),
        CustomTextField(
          heading: 'Certificate Name',
          hintText: 'e.g. OSHA 30',
          controller: logic.newCertNameController,
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: Obx(() => PickerFormField(
                label: 'Issue Date',
                placeholder: 'Pick a date',
                type: PickerFieldType.date,
                valueText: logic.newCertIssueDate.value == null ? null : formatCompactDate(logic.newCertIssueDate.value!),
                onTap: () => logic.pickNewCertificateDate(context),
              ),),
            ),
            SizedBox(width: 10,),
            Expanded(
              child: Obx(() => PickerFormField(
                label: 'Expiry Date',
                placeholder: 'Pick a date',
                type: PickerFieldType.date,
                valueText: logic.newCertExpiryDate.value == null ? null : formatCompactDate(logic.newCertExpiryDate.value!),
                onTap: () => logic.pickNewCertificateExpiryDate(context),
              ),),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Upload File',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: logic.pickCertificationFile,
          child: DottedUploadBox(fileName: logic.newCertUploadedFileName),
        ),
        const SizedBox(height: 20),
        CustomButton(
          text: 'Add certification',
          onPressed: logic.addCertification,
        ),
        const SizedBox(height: 24),
        if (logic.certifications.isEmpty)
          const AppEmptyState(
            showButton: false,
            title: 'No Certificates yet',
            message: 'Add your first certification using the form above.',
          )
        else
          for (final cert in logic.certifications)
            _CertificationCard(logic: logic, cert: cert),
      ],
    );
  }
}

/// Dashed drop-zone box for the (placeholder) file upload flow — wire a
/// real `file_picker` call into `logic.pickCertificationFile()`.
class DottedUploadBox extends StatelessWidget {
  const DottedUploadBox({super.key, required this.fileName});

  final String? fileName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.fieldBorder, style: BorderStyle.solid),
      ),
      child: Column(
        children: [
          Icon(Icons.cloud_upload_outlined, size: 28, color: AppColors.textMuted),
          const SizedBox(height: 8),
          Text(
            fileName ?? 'Click to upload or drag and drop',
            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _CertificationCard extends StatelessWidget {
  const _CertificationCard({required this.logic, required this.cert});

  final AccountSettingsLogic logic;
  final CertificationEntry cert;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Row(
        children: [
          Icon(Icons.workspace_premium_outlined, color: AppColors.primaryOrange),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cert.nameController.text,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark),
                ),
                if (cert.issueDate != null || cert.expiryDate != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    _dateRangeLabel(cert),
                    style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: () => logic.removeCertification(cert.id),
            icon: Icon(Icons.delete_outline, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  String _dateRangeLabel(CertificationEntry cert) {
    final issue = cert.issueDate != null ? _formatDate(cert.issueDate!) : '—';
    final expiry = cert.expiryDate != null ? _formatDate(cert.expiryDate!) : '—';
    return 'Issued $issue · Expires $expiry';
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
