# Install dependencies
./install-deps.sh
# Build maps
ls ./tiled/maps/ | sed -e 's/\.tmx$//' | xargs -I% tiled --export-map lua ./tiled/maps/%.tmx ./assets/maps/%.lua
# Add game files
zip -FSr builds/latest.zip main.lua lib assets
# Add libraries
cd lua_modules/share/lua/*/
zip -r ../../../../builds/latest.zip *
cd ../../../../
cp builds/latest.zip builds/$(date +"%Y-%m-%d_%H-%M-%S").zip