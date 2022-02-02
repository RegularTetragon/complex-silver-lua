./install-deps.sh
zip -FSr builds/latest.zip main.lua lib assets
cd lua_modules/share/lua/*/
zip -r ../../../../builds/latest.zip *
cd ../../../../
cp builds/latest.zip builds/$(date +"%Y-%m-%d_%H-%M-%S").zip