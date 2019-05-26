import Alamofire
import CoreLocation
import Foundation
import RxSwift
import SwiftyJSON


class WeatherDataViewModel : NSObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    static var weatherData = Variable([String:WeatherData]())
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        refreshWeatherData()
    }
    
    func updateWeatherData(forLocation: String, atLatitude: Double, atLongitude : Double) {

        let URL = "https://openweathermap.org/data/2.5/weather"
        let APP_ID = "b6907d289e10d714a6e88b30761fae22"
        let api_parameters = ["lat" : String(atLatitude), "lon" : String(atLongitude), "appid" : APP_ID]
        var weatherData = WeatherData(cityName: "", iconName: "", temperature: 0, windSpeed: 0, windDegree: 0, cloud: 0)
        
        Alamofire
            .request(URL, method: .get, parameters: api_parameters)
            .responseJSON {
                response in
                if response.result.isSuccess {
                    let weatherJSON = JSON(response.result.value!)
                    weatherData.cityName = forLocation
                    weatherData.iconName = weatherJSON["weather"][0]["icon"].stringValue
                    weatherData.temperature = weatherJSON["main"]["temp"].floatValue
                    weatherData.windSpeed = weatherJSON["wind"]["speed"].floatValue
                    weatherData.windDegree = weatherJSON["wind"]["deg"].floatValue
                    weatherData.cloud = weatherJSON["clouds"]["all"].floatValue
                    WeatherDataViewModel.weatherData.value.updateValue(weatherData, forKey: forLocation)
                } else {
                    print("Error \(response.result.error!)")
                }
            }

    }

    func refreshWeatherData() {
        locationManager.requestLocation()
        updateWeatherData(forLocation: "London", atLatitude: 51.51, atLongitude: -0.13)
        updateWeatherData(forLocation: "Tokyo", atLatitude: 35.6828, atLongitude: 139.759)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        updateWeatherData(forLocation: "Your Location", atLatitude: locations[locations.count-1].coordinate.latitude, atLongitude: locations[locations.count-1].coordinate.longitude)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
