import "package:flutter/material.dart";

import "../../l10n/app_localizations.dart";
import "../../theme/design_tokens.dart";
import "../../widgets/max_width_center.dart";

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.t("terms_link_label")),
      ),
      body: MaxWidthCenter(
        child: ListView(
          padding: const EdgeInsets.all(DesignTokens.sectionSpacing),
          children: [
            Text(
              "Allgemeine Geschaeftsbedingungen (AGB)",
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Stand: 15.03.2026",
              style: DesignTokens.caption.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Diese AGB regeln die Nutzung von Easy Recycle (Web und Mobile).",
              style: DesignTokens.body.copyWith(color: colorScheme.onSurface),
            ),
            const SizedBox(height: 16),
            const _TermsSection(
              title: "1. Geltungsbereich",
              body:
                  "Diese AGB gelten fuer alle Nutzerinnen und Nutzer der App in der jeweils aktuellen Fassung.",
            ),
            const _TermsSection(
              title: "2. Leistungsbeschreibung",
              body:
                  "Easy Recycle unterstuetzt bei der Einordnung von Gegenstaenden (z. B. per Foto/Text) und zeigt Entsorgungs- bzw. Recyclinghinweise. Die Ergebnisse dienen als Orientierung und ersetzen keine verbindliche Rechts- oder Behoerdenauskunft.",
            ),
            const _TermsSection(
              title: "3. Nutzung und Zugang",
              body:
                  "Die Nutzung kann als Gast erfolgen. Ein Anspruch auf bestimmte Funktionen, Verfuegbarkeit oder dauerhaft kostenfreie Bereitstellung besteht nicht.",
            ),
            const _TermsSection(
              title: "4. Pflichten der Nutzer",
              body:
                  "Nutzer duerfen die App nur rechtmaessig verwenden. Unzulaessig sind insbesondere missbraeuchliche Anfragen, sicherheitsgefaehrdende Nutzungen und das Einspeisen rechtswidriger Inhalte.",
            ),
            const _TermsSection(
              title: "5. Verfuegbarkeit",
              body:
                  "Die App kann wegen Wartung, Weiterentwicklung oder technischer Stoerungen zeitweise eingeschraenkt oder nicht verfuegbar sein.",
            ),
            const _TermsSection(
              title: "6. Preise",
              body:
                  "Sofern nicht anders angegeben, ist die Nutzung in der aktuellen Projektphase kostenfrei.",
            ),
            const _TermsSection(
              title: "7. Haftung",
              body:
                  "Fuer Schaeden haften wir unbeschraenkt bei Vorsatz und grober Fahrlaessigkeit. Bei leichter Fahrlaessigkeit haften wir nur bei Verletzung wesentlicher Vertragspflichten und begrenzt auf den vorhersehbaren, vertragstypischen Schaden. Gesetzliche zwingende Haftung bleibt unberuehrt.",
            ),
            const _TermsSection(
              title: "8. Inhalte Dritter",
              body:
                  "Die App kann Daten/Links von Drittanbietern enthalten (z. B. Karten, externe Dienste). Fuer deren Inhalte und Verfuegbarkeit sind die jeweiligen Anbieter verantwortlich.",
            ),
            const _TermsSection(
              title: "9. Geistiges Eigentum",
              body:
                  "Alle Rechte an App, Software, Design und Inhalten verbleiben beim jeweiligen Rechteinhaber. Ohne Erlaubnis ist keine weitergehende Nutzung gestattet.",
            ),
            const _TermsSection(
              title: "10. Datenschutz",
              body:
                  "Ergaenzend gelten die Datenschutzhinweise in der App.",
            ),
            const _TermsSection(
              title: "11. Aenderungen der AGB",
              body:
                  "Wir koennen diese AGB mit Wirkung fuer die Zukunft anpassen. Es gilt die jeweils in der App veroeffentlichte Fassung.",
            ),
            const _TermsSection(
              title: "12. Schlussbestimmungen",
              body:
                  "Es gilt deutsches Recht unter Beachtung zwingender Verbraucherschutzvorschriften. Sollten einzelne Bestimmungen unwirksam sein, bleibt die Wirksamkeit der uebrigen Regelungen unberuehrt.",
            ),
            const _TermsSection(
              title: "Rechtlicher Hinweis",
              body:
                  "Diese Fassung ist eine praxisnahe Standardvorlage fuer den aktuellen Projektstand und ersetzt keine individuelle Rechtsberatung.",
            ),
          ],
        ),
      ),
    );
  }
}

class _TermsSection extends StatelessWidget {
  const _TermsSection({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadius),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: DesignTokens.body.copyWith(
              color: colorScheme.onSurface,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
