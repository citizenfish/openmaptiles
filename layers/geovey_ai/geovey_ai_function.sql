CREATE OR REPLACE FUNCTION geovey_ai(bbox geometry, zoom_level integer)
    RETURNS TABLE (
       geometry geometry,
       osm_id bigint,
       poi_id bigint,
       poi_name TEXT,
       poi_class TEXT,
       poi_subclass TEXT
       ) AS
$$

SELECT
    b.geometry,
    b.osm_id AS osm_id,
    p.osm_id AS poi_id,
    p.name,
    p.class,
    p.subclass
FROM
    (SELECT osm_id, geometry
     FROM layer_building(bbox, zoom_level)) AS b
LEFT JOIN LATERAL
    (SELECT p.osm_id, p.geometry, COALESCE(p.name,'') as name, p.class, p.subclass
     FROM layer_poi(bbox, zoom_level, 0) p
     WHERE ST_INTERSECTS(b.geometry, p.geometry)
     ORDER BY p.rank DESC NULLS LAST LIMIT 1) AS p
ON TRUE;
$$ LANGUAGE SQL;

alter function geovey_ai(geometry, integer) owner to openmaptiles_devon;