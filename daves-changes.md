# Layer creation

Testing geometries
```sql
SELECT * FROM geovey_ai(ST_MakeEnvelope(
    -393803.56972543895, -- MinX
    6513657.802353076,   -- MinY
    -391357.584820312,   -- MaxX
    6516103.787258202,   -- MaxY
    3857                 -- SRID (Change to your spatial reference system)
), 14) where poi_id is not null

```

# Config for local server

FROM:

cd /opt/dev/geovey_ai
git clone https://github.com/citizenfish/openmaptiles.git
cd openmaptiles

-- In .env change PG_PORT to 5439 so that the docker postgres does not clash 
with local

make
make list-geofabrik | grep Devon --europe/united-kingdom/england/devon --
make start-db
make import-data
make download area=europe/united-kingdom/england/devon
make import-osm
make import-wikidata

__ THIS MUST BE RUN AFTER LAYER DEFINITION CHANGES

make import-sql


--**NOTE you MUST regenerate both sets if you change layer definitions prior 
to merge

--edit .env and set MIN_ZOOM=0 and MAX_ZOOM=8 set MBTILES_FILE=planet_tiles.mbtiles
make generate-tiles-pg

--edit .env set MIN_ZOOM=9 and MAX_ZOOM=14 set MBTILES_FILE=devon_tiles.mbtiles 
make generate-tiles-pg

--must join from higher to lower zoom level order

tile-join -o data/devon_final.mbtiles data/devon_tiles.mbtiles data/planet_tiles.mbtiles --force

--edit style/config.json and change "mbtiles": "/data/devon_final.mbtiles" 
style/style-header.json and change "url": "mbtiles:///data/devon_final.mbtiles"

make start-tileserver

http://172.16.0.34:8080/styles/OSM%20OpenMapTiles/#10.99/50.4258/-3.4821
vt2geojson http://172.16.0.34:8080/data/openmaptiles/14/8032/10855.pbf
