local Config = {
    apikey = "",
    city = "Bucharest",
    refreshTime = 5 * 60000, --min
}

local weatherType, windSpeed, windDirection, clock

local apiString = "http://api.weatherapi.com/v1/current.json?key=" .. Config.apikey .. "&q=" .. Config.city


Citizen.CreateThread(function()
    while true do
    syncWeather()
    Citizen.Wait(Config.refreshTime)
    end
end)

RegisterServerEvent('luck-weathersync:server:syncWeather')
AddEventHandler('luck-weathersync:server:syncWeather', function()
    TriggerClientEvent('luck-weathersync:client:setWeather', source, windSpeed, windDirection, weatherType, clock)
end)

function syncWeather()
    PerformHttpRequest(apiString, function (errorCode, resultData, resultHeaders)
        weatherType = json.decode(resultData).current.condition.code
        windSpeed = json.decode(resultData).current.wind_mph
        windDirection = json.decode(resultData).current.wind_degree
        clock = json.decode(resultData).location.localtime
        TriggerClientEvent('luck-weathersync:client:setWeather', -1, windSpeed, windDirection, weatherType, clock)
    end)
end
