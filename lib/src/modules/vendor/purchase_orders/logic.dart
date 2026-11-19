import 'package:get/get.dart';

import 'data/purchase_orders_mock_data.dart';
import 'models/purchase_order_model.dart';


class PurchaseOrdersLogic extends GetxController {
  final RxList<PurchaseOrderModel> orders = <PurchaseOrderModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  // TODO(api): replace with GET /purchase-orders
  Future<void> fetchOrders() async {
    isLoading.value = true;
    orders.assignAll(PurchaseOrdersMockData.list());
    isLoading.value = false;
  }

  int get activeCount =>
      orders.where((o) => o.status != PurchaseOrderStatus.delivered).length;

  double get totalValue => orders.fold(0.0, (sum, o) => sum + o.totalValue);

  int get deliveredCount =>
      orders.where((o) => o.status == PurchaseOrderStatus.delivered).length;
}
