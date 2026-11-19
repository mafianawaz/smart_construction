import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_icons.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_button.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';
import 'package:smart_construction/src/widgets/custom_dropdown_button.dart';

import 'data/tm_format.dart';
import 'logic.dart';
import 'widgets/tm_widgets.dart';


/// Daily T&M Sheet screen.
///
/// Pass [tag] for a tagged controller; delete it at the navigation layer.
class DailyTmSheetView extends StatelessWidget {
  const DailyTmSheetView({super.key, this.tag});

  final String? tag;



  @override
  Widget build(BuildContext context) {
    final logic = Get.put(TmLogic(), tag: tag);
    return Scaffold(
      appBar: AppPrimaryBar(
        title: 'Daily T&M Sheet',
        subtitle: 'Document time and materials for project work',
        showBackButton: true,
        centerTitle: true,
      ),
      body: GetBuilder<TmLogic>(
        tag: tag,
        builder: (_) {
          if (logic.isLoading) {
            return const Center(child: CircularProgressIndicator(color: TmPalette.orange));
          }
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TmCard(
                    child: CustomDropdown(
                      heading: 'PROJECT',
                      items: logic.projects,
                      value: logic.selectedProject,
                      onChanged: logic.selectProject,
                      itemLabel: (p) => p.label,
                      isMuted: true,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text('T&M Daily Sheet',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: TmPalette.text)),
                  const SizedBox(height: 2),
                  Text(logic.selectedProject?.label ?? '',
                      style: const TextStyle(fontSize: 11, color: TmPalette.muted)),
                  const SizedBox(height: 12),

                  // Date + crew size
                  TmCard(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: CustomTextField(
                            heading: 'DATE',
                            leftIconPath: AppIcons.calendar,
                            hintText: TmFormat.longDate(logic.date),
                            onClick: () => logic.pickDate(context),
                            isMuted: true,
                            isFilled: true,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 3,
                          child: CustomTextField(
                            heading: 'CREW SIZE',
                            hintText: '0',
                            controller: logic.crewController,
                            leftIconPath: AppIcons.workforce,
                            keyboardType: TextInputType.number,
                            onChange: logic.onFieldChanged,
                            isMuted: true,
                            isFilled: true,
                            validate: (v){
                              logic.crewError;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Representatives
                  TmCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          heading: 'COMPANY REPRESENTATIVE',
                          controller: logic.companyRepController,
                          leftIconPath: AppIcons.personal,
                          hintText: 'Full name',
                          onChange: logic.onFieldChanged,
                          validate: (v){
                            logic.companyRepError;
                          },
                          isMuted: true,
                          isFilled: true,
                        ),
                        const SizedBox(height: 14),
                        CustomTextField(
                          heading: 'CLIENT REPRESENTATIVE',
                          controller: logic.clientRepController,
                          leftIconPath: AppIcons.personal,
                          hintText: 'Full name',
                          onChange: logic.onFieldChanged,
                          validate: (v){
                            logic.clientRepError;
                          },
                          isMuted: true,
                          isFilled: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Weather + description
                  TmCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          heading: 'WEATHER CONDITION',
                          controller: logic.weatherController,
                          leftIconPath: AppIcons.morning,
                          hintText: 'e.g. Sunny, 72°F',
                          onChange: logic.onFieldChanged,
                          isMuted: true,
                          isFilled: true,
                        ),
                        const SizedBox(height: 14),
                        CustomTextField(
                          heading: 'DESCRIPTION OF WORK',
                          controller: logic.descriptionController,
                          hintText: 'Detail the work performed today...',
                          onChange: logic.onFieldChanged,
                          validate: (v){
                            logic.descriptionError;
                          },
                          maxLines: 4,
                          isFilled: true,
                          isMuted: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  CustomIconButton(
                    text: 'Submit Daily Sheet',
                    isLoading: logic.isSubmitting,
                    onPressed: logic.submit,
                    icon: AppIcons.send,
                  ),
                  const SizedBox(height: 22),

                  // Recent sheets
                  const Text('Recent T&M Sheets',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: TmPalette.text)),
                  const SizedBox(height: 10),
                  TmCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Recent T&M Sheets',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: TmPalette.text)),
                        const SizedBox(height: 12),
                        if (logic.recentSheets.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Center(
                              child: Text('No T&M sheets found for this project',
                                  style: TextStyle(fontSize: 11, color: TmPalette.hint)),
                            ),
                          )
                        else
                          for (final s in logic.recentSheets)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: TmSheetTile(key: ValueKey(s.id), sheet: s),
                            ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
