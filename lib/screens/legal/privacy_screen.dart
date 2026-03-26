import "package:flutter/material.dart";

import "../../l10n/app_localizations.dart";
import "../../theme/design_tokens.dart";
import "../../widgets/max_width_center.dart";

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.t("privacy_link_label")),
      ),
      body: MaxWidthCenter(
        child: ListView(
          padding: const EdgeInsets.all(DesignTokens.sectionSpacing),
          children: [
            Text(
              "Datenschutzhinweise",
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
              "Diese Hinweise gelten fuer die Nutzung von Easy Recycle (Web und Mobile).",
              style: DesignTokens.body.copyWith(color: colorScheme.onSurface),
            ),
            const SizedBox(height: 16),
            const _LegalSection(
              title: "1. Verantwortlicher",
              body:
                  "Easy Recycle (Projekt). Kontakt fuer Datenschutzanfragen bitte ueber die in App/Store hinterlegte Kontaktadresse.",
            ),
            const _LegalSection(
              title: "2. Welche Daten wir verarbeiten",
              body:
                  "- Session- und Auth-Daten (z. B. Session-ID, Guest-Token)\n"
                  "- Nutzungsdaten (z. B. Suchbegriffe, gewaehlte Stadt, Fehlerprotokolle)\n"
                  "- Bilddaten (hochgeladene Fotos zur Objekterkennung)\n"
                  "- Standortdaten (nur bei Freigabe fuer Recyclinghof-Suche)",
            ),
            const _LegalSection(
              title: "3. Zwecke und Rechtsgrundlagen",
              body:
                  "- Bereitstellung der App-Funktionen (Art. 6 Abs. 1 lit. b DSGVO)\n"
                  "- Sicherheit, Stabilitaet und Missbrauchsschutz (Art. 6 Abs. 1 lit. f DSGVO)\n"
                  "- Standort-/Bildverarbeitung nach Nutzeraktion bzw. Einwilligung (Art. 6 Abs. 1 lit. a DSGVO)",
            ),
            const _LegalSection(
              title: "4. Empfaenger und Auftragsverarbeitung",
              body:
                  "Zur technischen Bereitstellung koennen Hosting-, Storage- und Analyse-Dienstleister eingesetzt werden (z. B. Cloud/S3, KI-Analyse). Diese werden vertraglich als Auftragsverarbeiter eingebunden, soweit erforderlich.",
            ),
            const _LegalSection(
              title: "5. Speicherdauer",
              body:
                  "Daten werden nur so lange gespeichert, wie es fuer Betrieb, Sicherheit und Fehleranalyse erforderlich ist. Kurzlebige Auth-Tokens verfallen automatisch. Gesetzliche Aufbewahrungspflichten bleiben unberuehrt.",
            ),
            const _LegalSection(
              title: "6. Deine Rechte",
              body:
                  "Du hast nach DSGVO das Recht auf Auskunft, Berichtigung, Loeschung, Einschraenkung der Verarbeitung, Datenuebertragbarkeit sowie Widerspruch. Zudem besteht ein Beschwerderecht bei einer Datenschutzaufsichtsbehoerde.",
            ),
            const _LegalSection(
              title: "7. Datensicherheit",
              body:
                  "Wir setzen technische und organisatorische Massnahmen ein, um Daten angemessen zu schuetzen. Im Produktivbetrieb soll die Uebertragung ausschliesslich ueber HTTPS erfolgen.",
            ),
            const _LegalSection(
              title: "8. Drittlandtransfer",
              body:
                  "Soweit Anbieter ausserhalb EU/EWR eingesetzt werden, erfolgt dies auf Grundlage geeigneter Garantien gemaess DSGVO (z. B. Standardvertragsklauseln), sofern erforderlich.",
            ),
            const _LegalSection(
              title: "9. Aenderungen dieser Hinweise",
              body:
                  "Diese Datenschutzhinweise koennen aktualisiert werden. Es gilt die jeweils in der App veroeffentlichte Fassung.",
            ),
            const _LegalSection(
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

class _LegalSection extends StatelessWidget {
  const _LegalSection({
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
