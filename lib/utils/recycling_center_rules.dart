const Set<String> kRecyclingCenterEligibleDisposalCodes = {
  "recyclinghoefe",
  "recyclinghoefe_mit_schadstoff_annahme",
  "deponie_hannover_sonderabfallannahmestelle",
  "wertstoffhof",
  "deponie_hannover_lahe",
  "deponie",
  "gruengutannahmestellen",
};

bool hasEligibleRecyclingCenterDisposal(Iterable<String> codes) {
  for (final raw in codes) {
    final code = _normalizeDisposalToken(raw);
    if (code.isEmpty) {
      continue;
    }
    if (kRecyclingCenterEligibleDisposalCodes.contains(code)) {
      return true;
    }
  }
  return false;
}

String _normalizeDisposalToken(String raw) {
  var value = raw.trim().toLowerCase();
  if (value.isEmpty) {
    return value;
  }
  value = value
      .replaceAll("\u00E4", "ae")
      .replaceAll("\u00F6", "oe")
      .replaceAll("\u00FC", "ue")
      .replaceAll("\u00DF", "ss");
  value = value.replaceAll(RegExp(r"[^\w]+"), "_");
  value = value.replaceAll(RegExp(r"_+"), "_").replaceAll(RegExp(r"^_|_$"), "");
  return value;
}
