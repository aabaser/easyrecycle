import "dart:async";

import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../l10n/app_localizations.dart";
import "../models/admin_item.dart";
import "../services/admin_service.dart";
import "../state/app_state.dart";
import "../theme/design_tokens.dart";
import "../widgets/city_pill.dart";
import "../widgets/max_width_center.dart";
import "admin_item_detail_page.dart";
import "city_picker_page.dart";
import "language_picker_page.dart";

class AdminItemsPage extends StatefulWidget {
  const AdminItemsPage({super.key});

  @override
  State<AdminItemsPage> createState() => _AdminItemsPageState();
}

class _AdminItemsPageState extends State<AdminItemsPage> {
  final _service = AdminService();
  final _searchController = TextEditingController();
  Timer? _debounce;
  bool _loading = true;
  List<AdminItemSummary> _items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadItems({String? query}) async {
    final appState = context.read<AppState>();
    setState(() {
      _loading = true;
    });
    try {
      final items = await _service.listItems(
        lang: appState.locale.languageCode,
        query: query,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _items = items;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _items = [];
        _loading = false;
      });
    }
  }

  Widget _buildItemTile(AdminItemSummary item) {
    final imageUrl = item.imageUrl;
    final resolvedUrl = imageUrl == null
        ? null
        : (imageUrl.startsWith("http")
            ? imageUrl
            : "${AdminService.baseUrl}$imageUrl");
    return ListTile(
      leading: resolvedUrl == null
          ? Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.image_not_supported_outlined),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                resolvedUrl,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
            ),
      title: Text(item.title ?? item.canonicalKey),
      subtitle: Text(item.canonicalKey),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AdminItemDetailPage(itemId: item.id),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final appState = context.watch<AppState>();
    final city = appState.selectedCity;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.t("admin_title"), style: DesignTokens.titleM),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: DesignTokens.baseSpacing),
            child: CityPill(
              label: appState.locale.languageCode.toUpperCase(),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const LanguagePickerPage()),
                );
              },
            ),
          ),
          if (city != null)
            Padding(
              padding: const EdgeInsets.only(right: DesignTokens.baseSpacing),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 18),
                  const SizedBox(width: 4),
                  CityPill(
                    label: city.id == "berlin"
                        ? loc.t("city_berlin")
                        : loc.t("city_hannover"),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const CityPickerPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
      body: MaxWidthCenter(
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.sectionSpacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: loc.t("admin_search_hint"),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => _loadItems(
                      query: _searchController.text.trim(),
                    ),
                  ),
                ),
                onChanged: (value) {
                  _debounce?.cancel();
                  _debounce = Timer(const Duration(milliseconds: 300), () {
                    _loadItems(query: value.trim());
                  });
                },
                onSubmitted: (value) => _loadItems(query: value.trim()),
              ),
              const SizedBox(height: DesignTokens.sectionSpacing),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.separated(
                        itemCount: _items.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: DesignTokens.baseSpacing),
                        itemBuilder: (context, index) =>
                            _buildItemTile(_items[index]),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
