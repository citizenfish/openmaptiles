# Config for local server

FROM:

cd /opt/dev/geovey_ai
git clone https://github.com/citizenfish/openmaptiles.git
cd openmaptiles

-- In .env change PG_PORT to 5439

make
make list-geofabrik | grep Devon --europe/united-kingdom/england/devon --
make start-db
make import-data
make download area=europe/united-kingdom/england/devon
make import-osm
make import-wikidata
make import-sql
--edit .env and set MIN_ZOOM=0 and MAX_ZOOM=8 set MBTILES_FILE=planet_tiles.mbtiles
make generate-tiles-pg
--edit .env set MIN_ZOOM=9 and MAX_ZOOM=14 set MBTILES_FILE=devon_tiles.mbtiles 
make generate-tiles-pg

tile-join -o data/devon_final.mbtiles data/planet_tiles.mbtiles data/devon_tiles.mbtiles
--edit style/config.json and change "mbtiles": "/data/devon_final.mbtiles" 
style/style-header.json and change "url": "mbtiles:///data/devon_final.mbtiles"

make start-tileserver

http://172.16.0.34:8080/styles/OSM%20OpenMapTiles/#10.99/50.4258/-3.4821
