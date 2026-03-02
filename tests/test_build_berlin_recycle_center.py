import importlib.util
import json
from pathlib import Path


MODULE_PATH = (
    Path(__file__).resolve().parents[1] / "scripts" / "build_berlin_recycle_center.py"
)
SPEC = importlib.util.spec_from_file_location("build_berlin_recycle_center", MODULE_PATH)
assert SPEC and SPEC.loader
MODULE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MODULE)
build_rows = MODULE.build_rows


def test_build_rows_maps_berlin_payload_to_import_shape():
    payload = {
        "objs": [
            {
                "_obj_class": "Recyclinghof",
                "content_title": ["string", "Recyclinghof Asgardstra\u00c3\u0178e"],
                "address_street": ["string", "Asgardstra\u00c3\u0178e 3"],
                "address_zip": ["string", "13089"],
                "address_district": ["string", "Berlin (Pankow)"],
                "geo_lat": ["string", "52.580672"],
                "geo_long": ["string", "13.4358179"],
                "returnable_materials": ["string", "schadstoffe_gebrauchtwaren"],
                "disposal_positive": [
                    "stringlist",
                    [
                        "Restabfall-Tonne",
                        "Recyclingh\u00c3\u00b6fe",
                        "Sperrm\u00c3\u00bcllabfuhr",
                    ],
                ],
                "hof_i_d": ["string", "AS"],
            }
        ]
    }

    rows = build_rows(payload)
    assert len(rows) == 1
    row = rows[0]
    assert row["external_id"] == "AS"
    assert row["typ_code"] == 4
    assert row["typ_label"] == "Recyclinghof Plus (Schadstoffe + Gebrauchtwaren)"
    assert row["name"] == "Recyclinghof Asgardstraße"
    assert row["address"] == "Asgardstraße 3, 13089 Berlin (Pankow)"
    assert row["lat"] == 52.580672
    assert row["lng"] == 13.4358179
    assert json.loads(row["disposal_positive"]) == [
        "Restabfall-Tonne",
        "Recyclinghöfe",
        "Sperrmüllabfuhr",
    ]


def test_build_rows_skips_non_recyclinghof_entries():
    payload = {
        "objs": [
            {
                "_obj_class": "SomeOtherType",
                "content_title": ["string", "Ignore me"],
                "geo_lat": ["string", "52.0"],
                "geo_long": ["string", "13.0"],
            }
        ]
    }

    assert build_rows(payload) == []
