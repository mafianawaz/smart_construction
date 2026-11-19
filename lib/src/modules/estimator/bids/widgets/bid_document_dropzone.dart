import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import '../../../../utils/app_icons.dart';
import 'dashed_border_box.dart';

/// Dashed-border upload target on the Upload step.
class BidDocumentDropzone extends StatelessWidget {
  final String? fileName;
  final VoidCallback onTap;

  const BidDocumentDropzone({
    super.key,
    required this.onTap,
    this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DashedBorderBox(
        color: AppColors.primaryOrange,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 20),
          child: fileName == null
              ? Column(
                  children: [
                    Container(
                      height: 38,
                      width: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ]
                      ),
                      child: Center(child: SvgPicture.asset(AppIcons.export, color: AppColors.primaryOrange,)),
                    ),

                    const SizedBox(height: 10),
                    const Text(
                      'Click to upload or drag and drop',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'PDF, DOCX, or images up to 25MB per file',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 11, color: Colors.grey.shade500),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Icon(Icons.description_outlined,
                        color: AppColors.primaryOrange, size: 26),
                    const SizedBox(height: 8),
                    Text(
                      fileName!,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap to replace',
                      style:
                          TextStyle(fontSize: 11, color: Colors.grey.shade500),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
