import "../models/action_option.dart";
import "../models/warning.dart";
import "vision_service.dart";

class FoundResolution {
  FoundResolution({
    required this.disposalMethod,
    required this.disposalSteps,
    required this.warnings,
    required this.bestOption,
    required this.otherOptions,
  });

  final String disposalMethod;
  final List<String> disposalSteps;
  final List<Warning> warnings;
  final ActionOption? bestOption;
  final List<ActionOption> otherOptions;
}

class CityRulesMissingException implements Exception {
  CityRulesMissingException(this.message);
  final String message;
}

abstract class RulesService {
  FoundResolution resolveFound({
    required String cityId,
    required VisionInference inference,
  });
}
