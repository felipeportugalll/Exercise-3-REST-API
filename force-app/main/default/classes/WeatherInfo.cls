public class WeatherInfo {
    @AuraEnabled
    public static WeatherInfosWrapper getWeatherInfos(String cityName) {
        String apiKey = 'f7dfba1a2e72f2df24aff653a3de64bd';
        String endpoint = 'http://api.openweathermap.org/data/2.5/weather';
        endpoint += '?q=' + EncodingUtil.urlEncode(cityName, 'UTF-8'); // URL encode the city name
        endpoint += '&units=metric';
        endpoint += '&APPID=' + apiKey;
        System.debug('endPoint URL=> ' + endpoint);

        // Callout to Weather API
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        HttpResponse res = http.send(req);

        WeatherInfosWrapper weatherDet = new WeatherInfosWrapper();

        if (res.getStatusCode() == 200) {
            Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());

            weatherDet.city = String.valueOf(result.get('name'));

            // 'main' is a single map, not a list
            Map<String, Object> mainResult = (Map<String, Object>) result.get('main');
            weatherDet.temperature = String.valueOf(mainResult.get('temp'));

            // 'weather' is an array, so we need to cast it to a List
            List<Object> weatherResults = (List<Object>) result.get('weather');
            if (!weatherResults.isEmpty()) {
                Map<String, Object> weatherResult = (Map<String, Object>) weatherResults[0]; // Assuming the first entry in the array
                weatherDet.description = String.valueOf(weatherResult.get('description'));

                // 'icon' might be nested, so check if it's an object and navigate into it
                Object iconObj = weatherResult.get('icon');
                if (iconObj instanceof String) {
                    weatherDet.icon = (String) iconObj;
                }
            }
        }

        System.debug('weather details to return=> ' + weatherDet);
        return weatherDet;
    }

    // Wrapper class to weather infos in a serial manner
    public class WeatherInfosWrapper {
        @AuraEnabled public String city { get; set; }
        @AuraEnabled public String temperature { get; set; }
        @AuraEnabled public String description { get; set; }
        @AuraEnabled public String icon { get; set; }
    }
}
