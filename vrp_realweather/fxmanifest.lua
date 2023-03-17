fx_version 'bodacious'
game 'gta5'
author 'TeodorCristian'
dependency "vrp"

client_scripts{ 
  "lib/Proxy.lua",
  "lib/Tunnel.lua",
  "client.lua"
}

server_scripts{ 
  "@vrp/lib/utils.lua",
  "server.lua"
}
