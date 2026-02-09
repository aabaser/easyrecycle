#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import csv
import os
import sys
import psycopg


def main() -> None:
    csv_path = "data/item_alias_seed.csv"
    if not os.path.exists(csv_path):
        print(f"CSV not found: {csv_path}")
        sys.exit(1)

    dsn = os.getenv("DATABASE_URL")
    if not dsn:
        print("DATABASE_URL is not set")
        sys.exit(1)

    rows = []
    with open(csv_path, newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for r in reader:
            rows.append(
                (
                    r["canonical_key"],
                    r["lang"],
                    r["alias_text"],
                    r["alias_norm"],
                    r["alias_type"],
                    r["source"],
                    float(r["confidence"]),
                )
            )

    if not rows:
        print("No rows to import.")
        return

    with psycopg.connect(dsn) as conn:
        with conn.cursor() as cur:
            cur.executemany(
                """
                INSERT INTO core.item_alias
                  (canonical_key, lang, alias_text, alias_norm, alias_type, source, confidence)
                VALUES (%s, %s, %s, %s, %s, %s, %s)
                ON CONFLICT (lang, alias_norm) DO NOTHING
                """,
                rows,
            )
        conn.commit()

    print(f"Imported {len(rows)} rows into core.item_alias (conflicts ignored).")


if __name__ == "__main__":
    main()
