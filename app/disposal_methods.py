from __future__ import annotations

from dataclasses import dataclass


@dataclass(frozen=True, slots=True)
class DisposalMethodSeed:
  city_code: str
  code: str
  label_de: str
  recycle_center_typ_label: str | None = None
  recycle_center_typ_code: int | None = None


DISPOSAL_METHOD_SEEDS: tuple[DisposalMethodSeed, ...] = (
  DisposalMethodSeed("berlin", "biogut_tonne", "Biogut-Tonne"),
  DisposalMethodSeed("berlin", "glas_tonne_glas_iglu", "Glas-Tonne / Glas-Iglu"),
  DisposalMethodSeed("berlin", "laub_und_garten_tonne", "Laub- und Garten-Tonne"),
  DisposalMethodSeed("berlin", "papier_tonne", "Papier-Tonne"),
  DisposalMethodSeed("berlin", "recyclinghoefe", "Recyclinghöfe"),
  DisposalMethodSeed("berlin", "recyclinghoefe_mit_schadstoff_annahme", "Recyclinghöfe mit Schadstoff-Annahme"),
  DisposalMethodSeed("berlin", "restabfall_tonne", "Restabfall-Tonne"),
  DisposalMethodSeed("berlin", "sperrmuellabfuhr", "Sperrmüllabfuhr"),
  DisposalMethodSeed("berlin", "wertstoff_tonne", "Wertstoff-Tonne"),
  DisposalMethodSeed("hannover", "abholung_elektrogeraete", "Abholung Elektrogeräte"),
  DisposalMethodSeed("hannover", "altpapiersack", "Altpapiersack"),
  DisposalMethodSeed("hannover", "altpapiertonne", "Altpapiertonne"),
  DisposalMethodSeed("hannover", "biotonne", "Biotonne"),
  DisposalMethodSeed(
    "hannover",
    "deponie",
    "Deponie",
    recycle_center_typ_label="Deponien und angeschlossene Wertstoffhöfe",
    recycle_center_typ_code=2,
  ),
  DisposalMethodSeed(
    "hannover",
    "deponie_hannover_lahe",
    "Deponie Hannover Lahe",
    recycle_center_typ_label="Deponien und angeschlossene Wertstoffhöfe",
    recycle_center_typ_code=2,
  ),
  DisposalMethodSeed(
    "hannover",
    "deponie_hannover_sonderabfallannahmestelle",
    "Deponie Hannover - Sonderabfallannahmestelle",
    recycle_center_typ_label="Deponien und angeschlossene Wertstoffhöfe",
    recycle_center_typ_code=2,
  ),
  DisposalMethodSeed("hannover", "gelbe_tonne", "Gelbe Tonne"),
  DisposalMethodSeed(
    "hannover",
    "gruengutannahmestellen",
    "Grüngutannahmestellen",
    recycle_center_typ_label="Grüngutannahmestelle",
    recycle_center_typ_code=3,
  ),
  DisposalMethodSeed("hannover", "restabfalltonne", "Restabfalltonne"),
  DisposalMethodSeed("hannover", "sperrabfallabholung", "Sperrabfallabholung"),
  DisposalMethodSeed(
    "hannover",
    "wertstoffhof",
    "Wertstoffhof",
    recycle_center_typ_label="Wertstoffhöfe",
    recycle_center_typ_code=1,
  ),
  DisposalMethodSeed(
    "hannover",
    "wertstoffinsel",
    "Wertstoffinsel",
    recycle_center_typ_label="Wertstoffinsel",
    recycle_center_typ_code=5,
  ),
)


def normalize_disposal_label(label: str) -> str:
  return " ".join((label or "").strip().casefold().split())


_SEED_BY_CITY_AND_LABEL = {
  (seed.city_code, normalize_disposal_label(seed.label_de)): seed
  for seed in DISPOSAL_METHOD_SEEDS
}


def find_disposal_method_seed(city_code: str, label: str) -> DisposalMethodSeed | None:
  return _SEED_BY_CITY_AND_LABEL.get((city_code, normalize_disposal_label(label)))
