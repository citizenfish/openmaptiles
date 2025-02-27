git pull
make clean
make
make import-sql
rm -rf data/*.mbtiles
cp .env_planet .env
make generate-tiles-pg
cp .env_devon .env
make generate-tiles-pg
tile-join -o data/devon_final.mbtiles data/devon_tiles.mbtiles data/planet_tiles.mbtiles
make stop-tileserver
make start-tileserver
