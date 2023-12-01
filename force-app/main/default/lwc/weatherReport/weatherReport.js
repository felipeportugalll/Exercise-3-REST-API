import { LightningElement } from 'lwc';
import getWeatherInfos from '@salesforce/apex/WeatherInfo.getWeatherInfos';

export default class WeatherScreen extends LightningElement {
    inputCityName = '';
    weatherInfos = {};
    showWeatherInfos = false;
    iconsVariations = {
        'clear_sky_day': '01d',
        'clear_sky_night': '01n',
        'few_clouds_day': '02d',
        'few_clouds_night': '02n',
        'scattered_clouds_day': '03d',
        'scattered_clouds_night': '03n',
        'broken_clouds_day': '04d',
        'broken_clouds_night': '04n',
        'shower_rain_day': '09d',
        'shower_rain_night': '09n',
        'rain_day': '10d',
        'rain_night': '10n',
        'thunderstorm_day': '11d',
        'thunderstorm_night': '11n',
        'snow_day': '13d',
        'snow_night': '13n',
        'mist_day': '50d',
        'mist_night': '50n'
      };
      
      iconsLink = {};
      
      connectedCallback() {
        for (const iconVariation in this.iconsVariations) {
          Object.assign(this.iconsLink, {
            [iconVariation]: `https://openweathermap.org/img/wn/${this.iconsVariations[iconVariation]}@2x.png`
          })
        }
      }

      get iconUrl() {
        return this.iconsLink[this.weatherInfos.icon];
      }
      
    handleInputChange(event) {
        this.inputCityName = event.detail.value;
    }

    handleWeatherInfos() {
        getWeatherInfos({ cityName: this.inputCityName })
            .then((result) => {
                this.showWeatherInfos = true;
                this.weatherInfos = result;
                console.log('result ' + JSON.stringify(this.weatherInfos));
            })
            .catch((error) => {
                this.showWeatherInfos = false;
                console.error('Some error occurred while fetching weather infos', error);
            });
    }
}
