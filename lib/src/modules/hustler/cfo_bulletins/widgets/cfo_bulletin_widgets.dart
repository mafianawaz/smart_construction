import 'package:flutter/material.dart';

import '../models/cfo_bulletin_models.dart';
import 'cfo_bulletin_palette.dart';

/// Back-arrow circle + centered title.
class CfoBulletinHeaderBar extends StatelessWidget {
  const CfoBulletinHeaderBar({super.key, required this.title, this.onBack});

  final String title;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onBack ?? () => Navigator.of(context).maybePop(),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: CfoBulletinPalette.border),
                ),
                child: const Icon(Icons.chevron_left,
                    size: 20, color: CfoBulletinPalette.text),
              ),
            ),
          ),
          Text(title,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: CfoBulletinPalette.text)),
        ],
      ),
    );
  }
}

/// Small rounded tag (role badge, NEW badge).
class CfoBulletinTag extends StatelessWidget {
  const CfoBulletinTag({
    super.key,
    required this.label,
    required this.foreground,
    required this.background,
    this.fontSize = 7.5,
  });

  final String label;
  final Color foreground;
  final Color background;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: foreground)),
    );
  }
}

class CfoBulletinAvatar extends StatelessWidget {
  const CfoBulletinAvatar({super.key, required this.bulletin, this.size = 30});

  final CfoBulletin bulletin;
  final double size;

  static const _fallbacks = <Color>[
    Color(0xFF5B5BF0),
    Color(0xFF10B981),
    Color(0xFFF59E0B),
    Color(0xFFEF4444),
    Color(0xFF7C3AED),
    Color(0xFF0EA5E9),
  ];

  Widget _initials() {
    final color =
        _fallbacks[bulletin.authorName.hashCode.abs() % _fallbacks.length];
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      color: color.withOpacity(0.18),
      child: Text(bulletin.initials,
          style: TextStyle(
              fontSize: size * 0.34,
              fontWeight: FontWeight.w700,
              color: color)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final url = bulletin.avatarUrl;
    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: url == null
            ? _initials()
            : Image.network(url,
                fit: BoxFit.cover, errorBuilder: (_, __, ___) => _initials()),
      ),
    );
  }
}

/// One bulletin row: avatar, name + role, timestamp, project chip, message.
class CfoBulletinTile extends StatelessWidget {
  const CfoBulletinTile({super.key, required this.bulletin});

  final CfoBulletin bulletin;

  (Color, Color) get _roleColors {
    switch (bulletin.role) {
      case CfoBulletinRole.fieldWorker:
        return (CfoBulletinPalette.green, CfoBulletinPalette.greenSoft);
      case CfoBulletinRole.admin:
      case CfoBulletinRole.manager:
      case CfoBulletinRole.other:
        return (CfoBulletinPalette.muted, CfoBulletinPalette.chipFill);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (fg, bg) = _roleColors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CfoBulletinAvatar(bulletin: bulletin),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 5,
                  runSpacing: 2,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(bulletin.authorName,
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: CfoBulletinPalette.text)),
                    CfoBulletinTag(
                        label: bulletin.role.label,
                        foreground: fg,
                        background: bg),
                  ],
                ),
                const SizedBox(height: 1),
                Text(bulletin.postedLabel,
                    style: const TextStyle(
                        fontSize: 10, color: CfoBulletinPalette.muted)),
                if (bulletin.hasProject) ...[
                  const SizedBox(height: 5),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: CfoBulletinPalette.chipFill,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.attach_file,
                            size: 10, color: CfoBulletinPalette.muted),
                        const SizedBox(width: 2),
                        Flexible(
                          child: Text(bulletin.projectLabel,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: CfoBulletinPalette.text)),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 5),
                Text(bulletin.message,
                    style: const TextStyle(
                        fontSize: 10,
                        height: 1.35,
                        color: CfoBulletinPalette.text)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Collapsible organization section.
class CfoBulletinOrgSection extends StatelessWidget {
  const CfoBulletinOrgSection({
    super.key,
    required this.org,
    required this.expanded,
    required this.onToggle,
  });

  final CfoBulletinOrg org;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final items = org.sorted;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: CfoBulletinPalette.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(org.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: CfoBulletinPalette.text)),
                            ),
                            if (org.isNew) ...[
                              const SizedBox(width: 6),
                              const CfoBulletinTag(
                                label: 'NEW',
                                foreground: CfoBulletinPalette.green,
                                background: CfoBulletinPalette.greenSoft,
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(org.type,
                            style: const TextStyle(
                                fontSize: 10, color: CfoBulletinPalette.muted)),
                      ],
                    ),
                  ),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 18,
                    color: CfoBulletinPalette.muted,
                  ),
                ],
              ),
            ),
          ),
          if (expanded) ...[
            const Divider(height: 1, color: CfoBulletinPalette.border),
            if (org.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 18),
                child: Text('No bulletins yet for this organization.',
                    style: TextStyle(
                        fontSize: 11, color: CfoBulletinPalette.muted)),
              )
            else
              for (var i = 0; i < items.length; i++) ...[
                CfoBulletinTile(bulletin: items[i]),
                if (i != items.length - 1)
                  const Divider(height: 1, color: CfoBulletinPalette.border),
              ],
          ],
        ],
      ),
    );
  }
}
