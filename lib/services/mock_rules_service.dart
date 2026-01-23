import "../models/action_option.dart";
import "../models/scan_result.dart";
import "../models/warning.dart";
import "rules_service.dart";
import "vision_service.dart";

class MockRulesService implements RulesService {
  static const _supportedCities = ["berlin", "hannover"];

  @override
  FoundResolution resolveFound({
    required String cityId,
    required VisionInference inference,
  }) {
    if (!_supportedCities.contains(cityId)) {
      throw CityRulesMissingException("city_rules_missing");
    }

    switch (inference.category) {
      case "battery":
        return FoundResolution(
          disposalMethod: "Sondermüll",
          disposalSteps: [
            "Nicht in den Hausmüll geben.",
            "Bei einer Sammelstelle abgeben.",
          ],
          warnings: [
            Warning(
              severity: WarningSeverity.danger,
              messageKey: "warning_battery",
            ),
          ],
          bestOption: null,
          otherOptions: [],
        );
      case "glass":
        return FoundResolution(
          disposalMethod: "Altglas",
          disposalSteps: [
            "Leer machen.",
            "Nach Farbe trennen (falls möglich).",
            "In den Altglascontainer geben.",
          ],
          warnings: [],
          bestOption: ActionOption(
            type: ActionType.reuse,
            titleKey: "action_reuse_title",
            descriptionKey: "action_reuse_desc",
            ctaKey: "action_cta",
            priority: 1,
          ),
          otherOptions: [
            ActionOption(
              type: ActionType.donate,
              titleKey: "action_donate_title",
              descriptionKey: "action_donate_desc",
              ctaKey: "action_cta",
              priority: 2,
            ),
          ],
        );
      case "cable":
        return FoundResolution(
          disposalMethod: "Elektroschrott",
          disposalSteps: [
            "Als Elektroschrott entsorgen.",
            "Bei einer Sammelstelle abgeben.",
          ],
          warnings: [
            Warning(
              severity: WarningSeverity.warn,
              messageKey: "warning_electronics",
            ),
          ],
          bestOption: ActionOption(
            type: ActionType.repair,
            titleKey: "action_repair_title",
            descriptionKey: "action_repair_desc",
            ctaKey: "action_cta",
            priority: 1,
          ),
          otherOptions: [
            ActionOption(
              type: ActionType.sell,
              titleKey: "action_sell_title",
              descriptionKey: "action_sell_desc",
              ctaKey: "action_cta",
              priority: 2,
            ),
          ],
        );
      case "plastic_packaging":
        return FoundResolution(
          disposalMethod: "Gelber Sack / Gelbe Tonne",
          disposalSteps: [
            "Leer machen.",
            "Kurz ausspülen (optional).",
            "In den Gelben Sack / die Gelbe Tonne geben.",
          ],
          warnings: [],
          bestOption: null,
          otherOptions: [],
        );
      default:
        throw CityRulesMissingException("item_rules_missing");
    }
  }
}
