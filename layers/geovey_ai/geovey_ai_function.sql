--DROP FUNCTION layer_brixham_building(geometry,integer);
--DROP FUNCTION geovey_ai(geometry,integer);
CREATE OR REPLACE FUNCTION layer_brixham_building(bbox geometry, zoom_level int)
    RETURNS TABLE (
        geometry geometry,
        osm_id bigint,
        title text,
    description text,
    postcode text,
    address text,
    website text,
    thumbnail text,
    classify text,
    height double precision
                  )
AS
$$
  SELECT geometry,
    objectid as osm_id,
    title,
    description,
    postcode,
    address,
    url AS website,
    thumbnail,
    classify,
    relhmax as height
    FROM public.brixham_buildings_gmap_added
  WHERE zoom_level  > 13
$$ LANGUAGE SQL STABLE PARALLEL SAFE;

CREATE OR REPLACE FUNCTION geovey_ai(bbox geometry, zoom_level integer)
    RETURNS TABLE (
       geometry geometry,
       osm_id bigint,
       poi_id bigint,
       poi_name TEXT,
       poi_class TEXT,
       poi_subclass TEXT,
       title TEXT,
       description TEXT,
       postcode TEXT,
       address TEXT,
       website TEXT,
       thumbnail TEXT,
       classify TEXT,
       height double precision
       ) AS
$$

SELECT
    b.geometry,
    b.osm_id AS osm_id,
    p.osm_id AS poi_id,
    p.name,
    p.class,
    p.subclass,
    b.title,
    b.description,
    b.postcode,
    b.address,
    b.website,
    b.thumbnail,
    b.classify,
    b.height
FROM
    (SELECT *
     FROM layer_brixham_building(bbox, zoom_level)) AS b
LEFT JOIN LATERAL
    (SELECT p.osm_id, p.geometry, COALESCE(p.name,'') as name, '' AS class, p.subclass
     --FROM layer_poi(bbox, zoom_level, 0) --p
     FROM public.osm_poi_point p
     WHERE ST_INTERSECTS(b.geometry, p.geometry)
     LIMIT 1) AS p
ON TRUE;
$$ LANGUAGE SQL;

alter function geovey_ai(geometry, integer) owner to openmaptiles_devon;