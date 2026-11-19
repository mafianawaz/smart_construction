import 'package:flutter/material.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    this.icon = Icons.inventory_2_outlined,
    this.iconColor,
    this.iconBackgroundColor,
    this.title = 'Nothing to do here',
    this.message =
    'No work matches your filters. Try clearing them or switching the source.',
    this.buttonText = 'Clear Filters',
    this.onButtonPressed,
    this.showButton = true,
  });

  final IconData icon;
  final Color? iconColor;
  final Color? iconBackgroundColor;

  final String title;
  final String message;

  final String buttonText;
  final VoidCallback? onButtonPressed;

  final bool showButton;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 30,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon container
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: iconBackgroundColor ??
                    const Color(0xFFFFE9DE),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 30,
                  color: iconColor ??
                      const Color(0xFFFF5A0A),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF202124),
              ),
            ),

            const SizedBox(height: 7),

            // Description
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 320,
              ),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 11,
                  height: 1.45,
                  color: const Color(0xFF9AA0A6),
                ),
              ),
            ),

            if (showButton) ...[
              const SizedBox(height: 18),

              SizedBox(
                height: 38,
                child: ElevatedButton(
                  onPressed: onButtonPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    const Color(0xFFFF5A0A),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}