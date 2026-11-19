import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_icons.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';

import '../models/worker_model.dart';
import '../widgets/wf_common.dart';
import '../widgets/wf_palette.dart';
import '../widgets/worker_widgets.dart';

/// Read-only worker profile. No controller: the model is passed directly.
class WorkerDetailsView extends StatelessWidget {
  const WorkerDetailsView({super.key, required this.worker});
  final WorkerModel worker;

  @override
  Widget build(BuildContext context) {
    final w = worker;
    final active = w.status == WorkerStatus.active;
    return Scaffold(
      appBar: AppPrimaryBar(
        title: 'Worker Details',
        centerTitle: true,
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(child: WfAvatar(worker: w, radius: 40)),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  w.fullName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: WfPalette.text,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WfTag(w.title),
                  const SizedBox(width: 6),
                  WfStatusChip(
                    w.status.label,
                    fg: active ? WfPalette.success : WfPalette.muted,
                    bg: active ? WfPalette.successBg : WfPalette.fill,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              WfSectionCard(
                title: 'Personal Information',
                child: Column(
                  children: [
                    WfKvRow('Full Name', w.fullName),
                    WfKvRow('Email', w.email),
                    WfKvRow('Phone', w.phone),
                    WfKvRow('Emergency Contact', w.emergencyContact),
                  ],
                ),
              ),
              WfSectionCard(
                title: 'Employment Details',
                child: Column(
                  children: [
                    WfKvRow('Employee ID', w.employeeId),
                    WfKvRow('Department', w.department),
                    WfKvRow('Trade / Role', w.title),
                    WfKvRow('Hire Date', WorkforceDates.full(w.hireDate)),
                    WfKvRow('Employment Type', w.employmentType.label),
                  ],
                ),
              ),
              WfSectionCard(
                title: 'Certifications & Skills',
                trailing:  SvgPicture.asset(AppIcons.assigned, height: 18, color: WfPalette.orange),
                child: w.certifications.isEmpty
                    ? const Text(
                        'No certifications on file.',
                        style: TextStyle(fontSize: 10.5, color: WfPalette.muted),
                      )
                    : Column(
                        children: [
                          for (final c in w.certifications)
                            CertificationRow(cert: c),
                        ],
                      ),
              ),
              WfSectionCard(
                title: 'Work History & Projects',
                trailing: SvgPicture.asset(AppIcons.progress, height: 18, color: WfPalette.orange),
                child: Column(
                  children: [
                    WfKvRow('Current Assignment', w.currentAssignment),
                    WfKvRow(
                      'Hours Logged (This Week)',
                      '${_hours(w.hoursThisWeek)} hrs',
                      valueColor: WfPalette.orange,
                    ),
                    WfKvRow('Total Program Hours', '${_hours(w.totalProgramHours)} hrs'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _hours(double h) {
    final s = h % 1 == 0 ? h.toStringAsFixed(0) : h.toStringAsFixed(1);
    final parts = s.split('.');
    final whole = parts.first.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
      (m) => '${m[1]},',
    );
    return parts.length > 1 ? '$whole.${parts[1]}' : whole;
  }
}

