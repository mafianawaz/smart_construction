import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';
import '../../../../../utils/app_color.dart';
import '../../../../../utils/app_icons.dart';

/// Single label/value pair shown inside [JobInfoCard].
class JobInfoItem {
  final String label;
  final String value;
  final Color? valueColor;

  const JobInfoItem({
    required this.label,
    required this.value,
    this.valueColor,
  });
}

/// "Job Info" section: a flat [items] list, auto-chunked two-per-row.
///
/// Screen-agnostic — pass in whichever fields matter for the job being
/// shown, the widget handles the row layout itself.
class JobInfoCard extends StatelessWidget {
  final List<JobInfoItem> items;
  final int columns;

  const JobInfoCard({
    super.key,
    required this.items,
    this.columns = 2,
  });

  List<List<JobInfoItem>> get _rows {
    final rows = <List<JobInfoItem>>[];
    for (var i = 0; i < items.length; i += columns) {
      rows.add(items.sublist(i, i + columns > items.length ? items.length : i + columns));
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      hasIcon: true,
      title: 'Job Info',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final row in _rows) ...[
            Row(
              children: [
                for (final item in row)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.label,
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.value,
                          style: TextStyle(
                            fontSize: 14,
                            color: item.valueColor ?? AppColors.textDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            if (row != _rows.last) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}


/// Single stat pill (value + icon + label) used inside [ProjectStatisticsCard].
class ProjectStatItem {
  final String value;
  final String label;
  final String icon;
  final Color color;

  const ProjectStatItem({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });
}

/// "Project Statistics" section — a row of stat items (Total Days,
/// Completed, Pending, ...). Takes a flat list so the number of stats
/// shown isn't hard-coded to three.
class ProjectStatisticsCard extends StatelessWidget {
  final List<ProjectStatItem> items;

  const ProjectStatisticsCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Project Statistics',
      child: Row(
        children: [
          for (final item in items)
            Expanded(
              child: Column(
                children: [
                  SvgPicture.asset(item.icon, width: 20, height: 20, color: item.color),
                  const SizedBox(height: 4),
                  Text(
                    item.value,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}


/// "Overall Progress" section — a single progress bar plus a
/// "x% Complete" label underneath. [progress] is 0.0–1.0.
class OverallProgressCard extends StatelessWidget {
  final double progress;

  const OverallProgressCard({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final percent = (progress.clamp(0, 1) * 100).round();
    return SectionCard(
      title: 'Overall Progress',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: LinearProgressIndicator(
              value: progress.clamp(0, 1),
              minHeight: 12,
              backgroundColor: AppColors.background,
              valueColor: const AlwaysStoppedAnimation(AppColors.primaryOrange),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '$percent% Complete',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            '8 out of 12 tasks Completed',
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}


/// Single team member entry shown inside [TeamMembersCard].
class TeamMember {
  final String name;
  final String role;
  final String? avatarUrl;

  const TeamMember({
    required this.name,
    required this.role,
    this.avatarUrl,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
  }
}

/// "Team Members" section — a flat list of members, each rendered as an
/// avatar (initials fallback until real photo assets are wired up) plus
/// name and role.
class TeamMembersCard extends StatelessWidget {
  final List<TeamMember> members;

  const TeamMembersCard({super.key, required this.members});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Team Members',
      child: Column(
        children: [
          for (final member in members) ...[
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primaryOrange.withOpacity(0.15),
                  backgroundImage: member.avatarUrl != null
                      ? NetworkImage(member.avatarUrl!)
                      : null,
                  child: member.avatarUrl == null
                      ? Text(
                    member.initials,
                    style: const TextStyle(
                      color: AppColors.primaryOrange,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  )
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        member.role,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (member != members.last) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}


/// "Change Order" section — links out to the full change order list and
/// shows an empty-state message when there isn't one yet.
class ChangeOrderCard extends StatelessWidget {
  final bool hasChangeOrder;
  final VoidCallback onViewTap;

  const ChangeOrderCard({
    super.key,
    required this.onViewTap,
    this.hasChangeOrder = false,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Change Order',
      trailing: SectionViewLink(onTap: onViewTap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Track status and cost of the project's change orders",
            style: TextStyle(fontSize: 13, color: AppColors.textMuted),
          ),
          const SizedBox(height: 10),
          if (!hasChangeOrder)
            const Text(
              'No change order yet',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textMuted,
              ),
            ),
        ],
      ),
    );
  }
}


enum CloseoutStatus { loading, complete, incomplete }

/// Single checklist row shown inside [CloseoutReadinessCard]
/// (Punch List, Closeout Docs, Uploaded Status, Cost Data, ...).
class CloseoutItem {
  final String label;
  final CloseoutStatus status;

  const CloseoutItem({required this.label, this.status = CloseoutStatus.loading});
}

/// "Closeout Readiness" section — a checklist of items with their
/// current readiness status. Defaults to a "Loading..." state per item
/// until real data is wired up.
class CloseoutReadinessCard extends StatelessWidget {
  final List<CloseoutItem> items;

  const CloseoutReadinessCard({super.key, required this.items});

  Widget _statusWidget(CloseoutStatus status) {
    switch (status) {
      case CloseoutStatus.complete:
        return Icon(Icons.check_circle, size: 16, color: AppColors.statusChip);
      case CloseoutStatus.incomplete:
        return Icon(Icons.cancel_outlined, size: 16, color: AppColors.primaryOrange);
      case CloseoutStatus.loading:
        return const Text(
          'Loading...',
          style: TextStyle(fontSize: 12, color: AppColors.textMuted),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Closeout Readiness',
      child: Column(
        children: [
          for (final item in items) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.label,
                  style: const TextStyle(fontSize: 13, color: AppColors.textDark),
                ),
                _statusWidget(item.status),
              ],
            ),
            if (item != items.last) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

/// "One-Time Enforcement" section — a toggle in the title row plus a
/// status message describing the current enforcement policy.
class EnforcementCard extends StatelessWidget {
  final bool enabled;
  final ValueChanged<bool> onChanged;
  final String subtitle;

  const EnforcementCard({
    super.key,
    required this.enabled,
    required this.onChanged,
    this.subtitle = 'No enforcement policy configured',
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Geo-fence Enforcement',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('No geofence checks on check-in', style: TextStyle(fontSize: 12, color: AppColors.textMuted),),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('One-Time Enforcement', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600,),),
            trailing: Switch(
              value: enabled,
              onChanged: onChanged,
              activeColor: AppColors.primaryOrange,
            ),
            subtitle : Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          ),
        ],
      ),
    );
  }
}


/// "Auto Charge Order From Plan Revisions" section — explains the
/// feature and offers a primary action to turn it on.
class AutoChargeOrderCard extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onEnableTap;
  final String description;

  const AutoChargeOrderCard({
    super.key,
    required this.onEnableTap,
    this.isEnabled = false,
    this.description =
    'Automatically generate a draft change order when plan revisions are uploaded',
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Auto Charge Order From Plan Revisions',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            description,
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 12),
          if (!isEnabled) ...[

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Enable Auto Generation', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,),),
                ElevatedButton(
                  onPressed: onEnableTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryOrange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Enable',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'No auto-generation configured',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          ],
        ],
      ),
    );
  }
}


/// "Certified Payroll Form" section — explains the WH-347 requirement
/// and offers a primary action to generate/verify it.
class CertifiedPayrollCard extends StatelessWidget {
  final VoidCallback onFollowTap;
  final String description;
  final String buttonLabel;

  const CertifiedPayrollCard({
    super.key,
    required this.onFollowTap,
    this.description =
    'Certified payroll costs are generated and verified against payroll for this project',
    this.buttonLabel = 'Follow WH-347',
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Certified Payroll Form',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            description,
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 2),
          TextButton(
            onPressed: onFollowTap,
            child: Text(
              buttonLabel,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark),
            ),
          ),
        ],
      ),
    );
  }
}


/// "Daily Field Report" section on the Daily Notes tab — a free-text
/// entry field plus an "Add Entry" action, with an optional linked
/// tracking chip (e.g. "Material Usage Tracking").
class DailyFieldReportCard extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onAddEntry;
  final String? linkedTrackingLabel;

  const DailyFieldReportCard({
    super.key,
    required this.controller,
    required this.onAddEntry,
    this.linkedTrackingLabel = 'Material Usage Tracking',
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      cardColor: AppColors.background,
      isBorder: true,
      title: 'Daily Field Report',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Document today's progress, issues, or important updates.",
            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 10),
          CustomTextField(
            heading: 'Notes & Progress',
            controller: controller,
            maxLines: 5,
            hintText: "Document today's progress, issues, or important updates...",
          ),
          if (linkedTrackingLabel != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                SvgPicture.asset(AppIcons.usage),
                const SizedBox(width: 6),
                Text(
                  linkedTrackingLabel!,
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onAddEntry,
              icon: const Icon(Icons.add, size: 18),
              label: const Text(
                'Add Entry',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


/// Single note entry shown inside [DailyNotesCard].
class DailyNoteEntry {
  final String authorName;
  final String authorRole;
  final String timestamp;
  final String note;
  final bool isVoiceTranscription;

  const DailyNoteEntry({
    required this.authorName,
    required this.authorRole,
    required this.timestamp,
    required this.note,
    this.isVoiceTranscription = false,
  });

  String get initials {
    final parts = authorName.trim().split(' ');
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
  }
}

/// "Daily Notes" section on the Daily Notes tab — links out to the full
/// note history and lists recent notes.
class DailyNotesCard extends StatelessWidget {
  final List<DailyNoteEntry> notes;
  final VoidCallback onViewTap;

  const DailyNotesCard({
    super.key,
    required this.notes,
    required this.onViewTap,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      cardColor: AppColors.background,
      isBorder: true,
      title: 'Daily Notes',
      // trailing: SectionViewLink(onTap: onViewTap),
      child: Column(
        children: [
          for (final note in notes) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.primaryOrange.withOpacity(0.15),
                  child: Text(
                    note.initials,
                    style: const TextStyle(
                      color: AppColors.primaryOrange,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            note.authorName,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            note.timestamp,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        note.note,
                        style: const TextStyle(fontSize: 13, color: AppColors.textDark),
                      ),
                    ],
                  ),
                ),

              ],
            ),
            if (note != notes.last) ...[
              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 10),
            ],
          ],
        ],
      ),
    );
  }
}



/// Job id + status chip + project title block shown at the top of
/// Project Detail, above the Overview / Daily Notes tabs.
///
/// Screen-agnostic: pass in whatever job is being viewed, this widget
/// doesn't know or care which tab is selected.
class ProjectHeaderInfo extends StatelessWidget {
  final String jobId;
  final String status;
  final String projectTitle;
  final String count;
  final Color statusColor;

  const ProjectHeaderInfo({
    super.key,
    required this.jobId,
    required this.projectTitle,
    this.status = 'Active',
    this.count = '93',
    this.statusColor = AppColors.statusChip,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              jobId,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 6),
            CircleAvatar(
              radius: 15,
              backgroundColor: AppColors.statusChip,
              child: Text(count, style: const TextStyle(color: Colors.white, fontSize: 12)),
            )
          ],
        ),
        const SizedBox(height: 6),
        Text(
          projectTitle,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }
}


/// Screen-agnostic card shell used across Project Detail (and reusable
/// anywhere else a titled, bordered section is needed).
///
/// Keeps the "title row + content" composition in one place so every
/// section (Job Info, Change Order, Closeout Readiness, etc.) shares the
/// same padding, radius and shadow instead of re-declaring a Container.
class SectionCard extends StatelessWidget {
  final String title;
  final bool hasIcon;
  final Widget? trailing;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color? cardColor;
  final bool? isBorder;

  const SectionCard({
    super.key,
    required this.title,
    this.hasIcon = false,
    required this.child,
    this.trailing,
    this.padding = const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
    this.margin = const EdgeInsets.only(bottom: 12),
     this.cardColor,
    this.isBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: cardColor ?? Colors.grey.shade200,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isBorder! ? Colors.grey.shade300 : Colors.transparent),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            hasIcon ?
                Row(
                  children: [
                    SvgPicture.asset(
                      AppIcons.job,
                      width: 16,
                      height: 16,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ) :
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}

/// Small "View" text-button used as a SectionCard trailing widget wherever
/// a section links out to a fuller list (Change Order, Daily Notes, ...).
class SectionViewLink extends StatelessWidget {
  final VoidCallback onTap;
  final String label;

  const SectionViewLink({super.key, required this.onTap, this.label = 'View'});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryOrange,
        ),
      ),
    );
  }
}