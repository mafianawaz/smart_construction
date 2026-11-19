import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import '../../../../utils/app_color.dart';
import '../equipment_form/view.dart';
import '../logic.dart';
import '../models/marketplace_models.dart';
import '../widgets/marketplace_cards.dart';
import '../widgets/marketplace_primitives.dart';

/// Owner view of one listing: Edit / Delete + Incoming Requests.
class ListingDetailsView extends StatelessWidget {
  final String equipmentId;
  const ListingDetailsView({super.key, required this.equipmentId});

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<MarketplaceLogic>();
    return Scaffold(
      appBar: AppPrimaryBar(
        title: 'Marketplace',
        showBackButton: true,
        centerTitle: true,
      ),
      body: Obx(() {
        final item = logic.equipmentById(equipmentId);
        if (item == null) {
          return Center(
            child: Text('Listing not found',
                style: TextStyle(color: AppColors.textMuted)),
          );
        }
        final incoming = logic.incomingFor(equipmentId);
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name,
                            style: const TextStyle(
                                fontSize: 13.5, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 2),
                        Text('Incoming Requests',
                            style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryOrange)),
                      ],
                    ),
                  ),
                  _SmallOutlineButton(
                    label: 'Edit',
                    color: AppColors.textMuted,
                    onTap: () async {
                      final result = await Get.to<EquipmentModel>(
                          () => EquipmentFormView(existing: item));
                      if (result != null) {
                        logic.saveListing(result, isNew: false);
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  _SmallOutlineButton(
                    label: 'Delete',
                    color: AppColors.redColor,
                    onTap: () => _confirmDelete(logic, item),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              if (incoming.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 28),
                  child: Center(
                    child: Text('No incoming requests yet',
                        style: TextStyle(
                            fontSize: 12.5, color: AppColors.textMuted)),
                  ),
                )
              else
                for (final r in incoming)
                  RentalRequestTile(
                    request: r,
                    onRespond: () => _respond(logic, r),
                  ),
            ],
          ),
        );
      }),
    );
  }

  void _confirmDelete(MarketplaceLogic logic, EquipmentModel item) {
    Get.defaultDialog(
      title: 'Delete listing?',
      middleText: 'This removes "${item.name}" and its incoming requests.',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.redColor,
      onConfirm: () {
        logic.deleteListing(item.id);
        Get.back(); // dialog
        Get.back(); // details screen
      },
    );
  }

  void _respond(MarketplaceLogic logic, RentalRequestModel r) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Respond to ${r.requesterOrg}',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700)),
              const SizedBox(height: 14),
              MarketplacePrimaryButton(
                label: 'Approve',
                onPressed: () {
                  logic.respondToRequest(r.id, RentalRequestStatus.approved);
                  Get.back();
                },
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton(
                  onPressed: () {
                    logic.respondToRequest(r.id, RentalRequestStatus.declined);
                    Get.back();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.redColor,
                    side: BorderSide(color: AppColors.redColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Decline'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SmallOutlineButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _SmallOutlineButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color),
        minimumSize: const Size(52, 26),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 11)),
    );
  }
}
