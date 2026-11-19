import 'package:flutter/material.dart';
import '../logic.dart';
import '../widgets/module_tile.dart';

/// Modules tab: tappable cards into the sub-modules of the hub.
class SafetyModulesTab extends StatelessWidget {
  final SafetyLogic logic;

  const SafetyModulesTab({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    final modules = logic.modules;
    return ListView.separated(
      itemCount: modules.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => SafetyModuleTile(
        module: modules[i],
        onTap: () => logic.openModule(modules[i]),
      ),
    );
  }
}
