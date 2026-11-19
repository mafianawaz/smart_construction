import 'package:get/get.dart';
import '../../../services/session/session.dart';
import 'model/chat_models.dart';


/// Tagged per-instance (see MessagesScreen) so this can never collide
/// with another MessagesController if more than one is ever alive —
/// same convention used for the AppCalendar controllers.
class MessagesLogic extends GetxController {
  final MessagesScreenConfig config;
  MessagesLogic(this.config);

  final RxString searchQuery = ''.obs;

  List<ChatSection> get filteredSections {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return config.sections;

    return config.sections
        .map(
          (section) => ChatSection(
        title: section.title,
        items: section.items
            .where((item) => item.name.toLowerCase().contains(query))
            .toList(),
      ),
    )
        .where((section) => section.items.isNotEmpty)
        .toList();
  }

  void onSearchChanged(value) => searchQuery.value = value;
}