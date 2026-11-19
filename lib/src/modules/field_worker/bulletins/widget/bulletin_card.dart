import 'package:flutter/material.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';
import '../../../../utils/app_color.dart';
import '../model/bulletin_model.dart';


class BulletinCard extends StatelessWidget {
  final BulletinModel bulletin;
  final bool isOwnPost;
  final bool isEditing;
  final TextEditingController editController;
  final VoidCallback onEditTap;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const BulletinCard({
    super.key,
    required this.bulletin,
    required this.isOwnPost,
    required this.isEditing,
    required this.editController,
    required this.onEditTap,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.fieldBorder)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: AssetImage(bulletin.authorAvatarUrl),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bulletin.authorName,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      bulletin.formattedDate,
                      style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              if (isOwnPost && !isEditing)
                InkWell(
                  onTap: onEditTap,
                  child: Icon(Icons.edit_outlined, size: 18, color: AppColors.textMuted),
                ),
            ],
          ),
          const SizedBox(height: 10),
          if (isEditing) ...[
            CustomTextField(
              hintText: '',
              controller: editController,
              maxLines: 3,
              isFilled: true,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: onSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Save', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: onCancel,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.background),
                    backgroundColor: AppColors.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Cancel', style: TextStyle(color: AppColors.textDark)),
                ),
              ],
            ),
          ] else
            Text(bulletin.message, style: TextStyle(color: AppColors.textDark, height: 1.4)),
          if (!isEditing && bulletin.projectName != null) ...[
            const SizedBox(height: 8),
            Text(
              bulletin.projectName!,
              style: TextStyle(fontSize: 12, color: AppColors.primaryOrange, fontWeight: FontWeight.w600),
            ),
          ],
        ],
      ),
    );
  }
}