import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../utils/app_icons.dart';

/// "Open Takeoff in Web View" card under the document tree — takeoff
/// authoring only exists on the web dashboard, so this points there.
class OpenTakeoffWebCard extends StatelessWidget {
  final VoidCallback onTap;
  const OpenTakeoffWebCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.grey.shade100,
                child: SvgPicture.asset(AppIcons.progress, height: 20, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 12),
              const Text('Open Takeoff in Web View',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(
                'If you want to use Takeoff all functionality you need to use in web dashboard.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
