mkdir lua_modules
xargs -I% -a "rockfile" luarocks install --tree lua_modules %