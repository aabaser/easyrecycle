from app.disposal_methods import DISPOSAL_METHOD_SEEDS, find_disposal_method_seed


def test_disposal_method_seeds_are_unique_by_code() -> None:
  codes = [seed.code for seed in DISPOSAL_METHOD_SEEDS]
  assert len(codes) == len(set(codes))


def test_hannover_recycle_center_type_mappings_are_stable() -> None:
  wertstoffinsel = find_disposal_method_seed("hannover", "Wertstoffinsel")
  wertstoffhof = find_disposal_method_seed("hannover", "Wertstoffhof")
  deponie = find_disposal_method_seed("hannover", "Deponie")

  assert wertstoffinsel is not None
  assert wertstoffinsel.recycle_center_typ_code == 5

  assert wertstoffhof is not None
  assert wertstoffhof.recycle_center_typ_code == 1

  assert deponie is not None
  assert deponie.recycle_center_typ_code == 2


def test_seed_lookup_normalizes_spacing_and_case() -> None:
  seed = find_disposal_method_seed("berlin", "  recyclinghöfe mit schadstoff-annahme ")
  assert seed is not None
  assert seed.code == "recyclinghoefe_mit_schadstoff_annahme"
