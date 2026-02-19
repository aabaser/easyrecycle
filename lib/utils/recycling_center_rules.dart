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
    final code = raw.trim().toLowerCase();
    if (code.isEmpty) {
      continue;
    }
    if (kRecyclingCenterEligibleDisposalCodes.contains(code)) {
      return true;
    }
  }
  return false;
}

