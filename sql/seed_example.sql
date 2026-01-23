-- Minimal seed to test /resolve
INSERT INTO core.city(code, name_key, base_city_id)
VALUES
  ('hannover', 'city.hannover', NULL)
ON CONFLICT (code) DO NOTHING;

INSERT INTO core.city(code, name_key, base_city_id)
SELECT 'berlin', 'city.berlin', c.city_id
FROM core.city c
WHERE c.code='hannover'
ON CONFLICT (code) DO NOTHING;

INSERT INTO core.i18n_translation(key, lang, text) VALUES
  ('city.hannover','de','Hannover'),
  ('city.hannover','en','Hanover'),
  ('city.berlin','de','Berlin'),
  ('city.berlin','en','Berlin')
ON CONFLICT (key,lang) DO NOTHING;

INSERT INTO core.category(code, name_key) VALUES
  ('electronics','category.electronics')
ON CONFLICT (code) DO NOTHING;

INSERT INTO core.i18n_translation(key, lang, text) VALUES
  ('category.electronics','de','Elektronik'),
  ('category.electronics','en','Electronics')
ON CONFLICT (key,lang) DO NOTHING;

INSERT INTO core.disposal_method(code, name_key) VALUES
  ('E_SCHROTT','disposal.e_schrott')
ON CONFLICT (code) DO NOTHING;

INSERT INTO core.i18n_translation(key, lang, text) VALUES
  ('disposal.e_schrott','de','Elektroschrott'),
  ('disposal.e_schrott','en','E-waste')
ON CONFLICT (key,lang) DO NOTHING;

-- Item (battery) with Hannover base rule
INSERT INTO core.item(external_document_id, source, canonical_key, title_key, desc_key)
VALUES ('doc_battery', 'hannover', 'item.battery', 'item.battery.title', 'item.battery.desc')
ON CONFLICT (external_document_id) DO NOTHING;

INSERT INTO core.i18n_translation(key, lang, text) VALUES
  ('item.battery.title','de','Batterie'),
  ('item.battery.title','en','Battery'),
  ('item.battery.desc','de','Nicht in den Hausmüll werfen.'),
  ('item.battery.desc','en','Do not throw into household waste.')
ON CONFLICT (key,lang) DO NOTHING;

-- Hannover disposal/category
INSERT INTO core.item_city_disposal(city_id, item_id, disposal_id, priority)
SELECT c.city_id, i.item_id, d.disposal_id, 1
FROM core.city c, core.item i, core.disposal_method d
WHERE c.code='hannover' AND i.canonical_key='item.battery' AND d.code='E_SCHROTT'
ON CONFLICT DO NOTHING;

INSERT INTO core.item_city_category(city_id, item_id, category_id, priority)
SELECT c.city_id, i.item_id, cat.category_id, 1
FROM core.city c, core.item i, core.category cat
WHERE c.code='hannover' AND i.canonical_key='item.battery' AND cat.code='electronics'
ON CONFLICT DO NOTHING;
