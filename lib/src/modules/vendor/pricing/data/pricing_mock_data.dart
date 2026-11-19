import '../models/pricing_category.dart';
import '../models/pricing_item_model.dart';
import '../models/pricing_status.dart';

/// Static stand-in for the pricing items API. Swap
/// PricingMockData.getAll() for a real GET /api/pricing-items call once
/// the backend is ready.
class PricingMockData {
  // TODO(api): replace with GET /api/pricing-items
  static List<PricingItemModel> getAll() {
    return [
      PricingItemModel(
        id: 'price-001',
        category: PricingCategory.material,
        name: 'Ready Mix Concrete 4000 PSI',
        code: 'RMC-4000',
        subCategory: 'Concrete & Masonry',
        unit: 'CY',
        description: '4000 PSI ready mix concrete, delivered by truck.',
        unitPrice: 145.00,
        minimumOrder: 3,
        deliveryFee: 75.00,
        leadTimeDays: 2,
        status: PricingStatus.approved,
        submittedAt: DateTime(2026, 1, 21),
      ),
      PricingItemModel(
        id: 'price-002',
        category: PricingCategory.material,
        name: 'test',
        code: 'RMC-4080',
        subCategory: 'Concrete & Masonry',
        unit: 'CY',
        description: 'test',
        unitPrice: 1.00,
        minimumOrder: 1,
        deliveryFee: 0.00,
        leadTimeDays: 1,
        status: PricingStatus.pending,
        submittedAt: DateTime(2026, 1, 23),
      ),
    ];
  }
}
