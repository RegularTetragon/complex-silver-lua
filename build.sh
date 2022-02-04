# Install dependencies
./install-deps.sh
# Build maps
ls ./tiled/maps/ | sed -e 's/\.tmx$//' | xargs -I% tiled --export-map lua ./tiled/maps/%.tmx ./assets/maps/%.lua
ls ./tiled/tilesets/ | sed -e 's/\.tsx$//' | xargs -I% tiled --export-tileset lua ./tiled/tilesets/%.tsx ./assets/tilesets/%.lua
# Add game files
zip -FSr builds/latest.zip main.lua engine assets
# Add libraries
cd lua_modules/share/lua/*/
zip -r ../../../../builds/latest.zip *
cd ../../../../
cp builds/latest.zip builds/$(date +"%Y-%m-%d_%H-%M-%S").zip