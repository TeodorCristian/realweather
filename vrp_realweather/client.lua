local windSpeed, windDirection, weatherType, rain
local lastWeather = "OVERCAST"
local servertime = {h = 0, m = 0}

local weatherTypes = {
 [1000] = {
     type = "CLEAR",
     rain = -1,
 },

 [1003] = {
    type = "CLOUDS",
    rain = -1,
 },

 [1006] = {
    type = "CLOUDS",
    rain = -1,
 },

 [1030] = {
    type = "FOGGY",
    rain = -1,
 },

 [1063] = {
    type = "OVERCAST",
    rain = -1,
 },

 [1066] = {
    type = "OVERCAST",
    rain = -1,
 },

 [1069] = {
    type = "OVERCAST",
    rain = -1,
 },

 [1072] = {
    type = "OVERCAST",
    rain = -1,
 },

 [1087] = {
    type = "OVERCAST",
    rain = 1.0,
 },

 [1114] = {
    type = "OVERCAST",
    rain = -1,
 },

 [1117] = {
    type = "BLIZZARD",
    rain = -1,
 },

 [1135] = {
    type = "FOGGY",
    rain = -1,
 },

 [1147] = {
    type = "FOGGY",
    rain = -1,
 },

 [1150] = {
    type = "FOGGY",
    rain = -1,
 },

 [1150] = {
    type = "RAIN",
    rain = 0.2,
 },

 [1153] = {
    type = "RAIN",
    rain = 0.3,
 },

 [1168] = {
    type = "RAIN",
    rain = 0.4,
 },

 [1171] = {
    type = "RAIN",
    rain = 0.4,
 },

 [1180] = {
    type = "RAIN",
    rain = 0.5,
 },

 [1183] = {
    type = "RAIN",
    rain = 0.5,
 },

 [1186] = {
    type = "RAIN",
    rain = 0.6,
 },

 [1189] = {
    type = "RAIN",
    rain = 0.6,
 },

 [1192] = {
    type = "RAIN",
    rain = 0.8,
 },

 [1195] = {
    type = "THUNDER",
    rain = 0.8,
 },

 [1198] = {
    type = "THUNDER",
    rain = 0.9,
 },

 [1201] = {
    type = "THUNDER",
    rain = 0.9,
 },

 [1204] = {
    type = "SNOWLIGHT",
    rain = 0.2,
 },

 [1207] = {
    type = "SNOWLIGHT",
    rain = 1.0,
 },

 [1210] = {
    type = "SNOWLIGHT",
    rain = -1,
 },

 [1213] = {
    type = "SNOWLIGHT",
    rain = -1,
 },

 [1216] = {
    type = "SNOWLIGHT",
    rain = -1,
 },

 [1219] = {
    type = "XMAS",
    rain = -1,
 },

 [1222] = {
    type = "XMAS",
    rain = -1,
 },

 [1225] = {
    type = "XMAS",
    rain = -1,
 },

 [1237] = {
    type = "XMAS",
    rain = -1,
 },

 [1240] = {
    type = "RAIN",
    rain = -1,
 },

 [1243] = {
    type = "THUNDER",
    rain = 1.0,
 },

 [1246] = {
    type = "THUNDER",
    rain = 1.0,
 },

 [1249] = {
    type = "SNOWLIGHT",
    rain = 0.3,
 },

 [1252] = {
    type = "SNOWLIGHT",
    rain = 1.0,
 },

 [1255] = {
    type = "SNOWLIGHT",
    rain = -1,
 },

 [1258] = {
    type = "XMAS",
    rain = -1,
 },

 [1261] = {
    type = "XMAS",
    rain = -1,
 },

 [1264] = {
    type = "XMAS",
    rain = -1,
 },

 [1273] = {
    type = "THUNDER",
    rain = 0.7,
 },

 [1276] = {
    type = "THUNDER",
    rain = 1.0,
 },

 [1279] = {
    type = "THUNDER",
    rain = 0.5,
 },

 [1282] = {
    type = "XMAS",
    rain = -1,
 },

}



RegisterNetEvent('luck-weathersync:client:setWeather')
AddEventHandler('luck-weathersync:client:setWeather', function(windSpeedd, windDirectionn, weatherTypee, clockk)
windSpeed = windSpeedd
windDirection = windDirectionn
weatherType = weatherTypes[weatherTypee].type
rain = weatherTypes[weatherTypee].rain
local tempTable = {}
local tempTable2 = {}
for time in string.gmatch(clockk, "[^%s]+") do
   table.insert(tempTable, time)
end
local time = tempTable[2]
for times in  string.gmatch(time, "([^:]+)") do
   table.insert(tempTable2, times)
end
servertime.h = tonumber(tempTable2[1])
servertime.m = tonumber(tempTable2[2])
end)

local tickcount = 0


Citizen.CreateThread(function()
	Wait(3000)
	while true do
		Wait(15000)
		NetworkOverrideClockTime(servertime.h, servertime.m, 0)
	end
end)

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    while true do
        if lastWeather ~= weatherType then
            lastWeather = weatherType
            SetWeatherTypeOverTime(weatherType, 15.0)
            SetRainLevel(rain)
            Citizen.Wait(15000)
        end
        Citizen.Wait(100)
        ClearOverrideWeather()
        ClearWeatherTypePersist()
        SetWeatherTypePersist(lastWeather)
        SetWeatherTypeNow(lastWeather)
        SetWeatherTypeNowPersist(lastWeather)
        if windSpeed and weatherType ~= nil then
            if windSpeed > 0.0 then
                SetWindSpeed(windSpeed)
                SetWindDirection(windDirection)
            else
                SetWindDirection(0.0)
                SetWindSpeed(0.0)
            end
            if weatherType == 'XMAS' then
                SetForceVehicleTrails(true)
                SetForcePedFootstepsTracks(true)
            else
                SetForceVehicleTrails(false)
                SetForcePedFootstepsTracks(false)
            end
        end
    end
end)

AddEventHandler('playerSpawned', function()
    TriggerServerEvent('luck-weathersync:server:syncWeather')
end)
