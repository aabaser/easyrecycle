import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../state/app_state.dart";
import "../../theme/design_tokens.dart";
import "../../widgets/max_width_center.dart";
import "../../widgets/primary_button.dart";
import "../../widgets/secondary_button.dart";

class ThemePreviewScreen extends StatelessWidget {
  const ThemePreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Theme Preview",
          style: DesignTokens.titleM.copyWith(color: colorScheme.onSurface),
        ),
      ),
      body: MaxWidthCenter(
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.sectionSpacing),
          child: ListView(
            children: [
              SwitchListTile(
                title: const Text("Dark Mode"),
                value: appState.themeMode == ThemeMode.dark,
                onChanged: (value) {
                  appState.setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
                },
              ),
              const SizedBox(height: DesignTokens.sectionSpacing),
              Text("Title Large", style: Theme.of(context).textTheme.titleLarge),
              Text("Title Medium", style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: DesignTokens.baseSpacing),
              Text("Body text example", style: Theme.of(context).textTheme.bodyLarge),
              Text("Caption text", style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: DesignTokens.sectionSpacing),
              PrimaryButton(label: "Primary", onPressed: () {}),
              const SizedBox(height: DesignTokens.baseSpacing),
              SecondaryButton(label: "Secondary", onPressed: () {}),
              const SizedBox(height: DesignTokens.sectionSpacing),
              Wrap(
                spacing: DesignTokens.baseSpacing,
                children: const [
                  Chip(label: Text("Chip One")),
                  Chip(label: Text("Chip Two")),
                  Chip(label: Text("Chip Three")),
                ],
              ),
              const SizedBox(height: DesignTokens.sectionSpacing),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.place_outlined),
                  title: const Text("List Tile"),
                  subtitle: const Text("Subtitle text"),
                  trailing: const Icon(Icons.chevron_right),
                ),
              ),
              const SizedBox(height: DesignTokens.sectionSpacing),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Snackbar message")),
                        );
                      },
                      child: const Text("Show Snackbar"),
                    ),
                  ),
                  const SizedBox(width: DesignTokens.baseSpacing),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        showDialog<void>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Dialog"),
                            content: const Text("Dialog body text"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text("OK"),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text("Show Dialog"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: DesignTokens.sectionSpacing),
              const Divider(),
              SwitchListTile(
                value: true,
                onChanged: (_) {},
                title: const Text("Switch"),
              ),
              CheckboxListTile(
                value: true,
                onChanged: (_) {},
                title: const Text("Checkbox"),
              ),
              RadioListTile<int>(
                value: 1,
                groupValue: 1,
                onChanged: (_) {},
                title: const Text("Radio"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
