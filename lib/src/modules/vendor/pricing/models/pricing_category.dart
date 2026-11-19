/// The three top-level tabs on the My Pricing screen. Each tab is its own
/// slice of the same item list, filtered by this value — never a separate
/// screen or controller.
enum PricingCategory { material, rental, service }

extension PricingCategoryX on PricingCategory {
  String get tabLabel {
    switch (this) {
      case PricingCategory.material:
        return 'Material Pricing';
      case PricingCategory.rental:
        return 'Rental Equipment';
      case PricingCategory.service:
        return 'Service Pricing';
    }
  }

  /// Noun used in "No ... items found" and "Add ... Item".
  String get itemNoun {
    switch (this) {
      case PricingCategory.material:
        return 'pricing';
      case PricingCategory.rental:
        return 'rental equipment';
      case PricingCategory.service:
        return 'service';
    }
  }

  String get emptyStateTitle => 'No $itemNoun items found';

  String get addFormTitle {
    switch (this) {
      case PricingCategory.material:
        return 'Add Material Pricing Item';
      case PricingCategory.rental:
        return 'Add Rental Equipment Item';
      case PricingCategory.service:
        return 'Add Service Pricing Item';
    }
  }

  String get editFormTitle {
    switch (this) {
      case PricingCategory.material:
        return 'Edit Material Pricing Item';
      case PricingCategory.rental:
        return 'Edit Rental Equipment Item';
      case PricingCategory.service:
        return 'Edit Service Pricing Item';
    }
  }

  /// Sub-category options shown in the form's "Category" dropdown.
  /// Only material's options are confirmed from the reference screens
  /// ("General Material" default, "Concrete & Masonry" seen on an item);
  /// rental/service lists are a reasonable placeholder set — see
  /// NOTES_PRICING.md.
  List<String> get subCategoryOptions {
    switch (this) {
      case PricingCategory.material:
        return const [
          'General Material',
          'Concrete & Masonry',
          'Lumber & Framing',
          'Electrical',
          'Plumbing',
        ];
      case PricingCategory.rental:
        return const [
          'General Equipment',
          'Heavy Machinery',
          'Power Tools',
          'Scaffolding',
        ];
      case PricingCategory.service:
        return const [
          'General Service',
          'Labor',
          'Delivery',
          'Inspection',
        ];
    }
  }

  List<String> get unitOptions {
    switch (this) {
      case PricingCategory.material:
        return const ['EA', 'CY', 'SF', 'LF', 'LB', 'TON'];
      case PricingCategory.rental:
        return const ['DAY', 'WEEK', 'MONTH', 'HR'];
      case PricingCategory.service:
        return const ['EA', 'HR', 'JOB'];
    }
  }
}
