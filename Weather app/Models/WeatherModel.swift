import Foundation

struct WeatherModel: Codable {
    var name: String
    var weather: [Weather]
    var main: Main
}

struct Weather: Codable {
    var main: String
    var description: String
}

struct Main: Codable {
    var temperature: Float
    
    private enum CodingKeys: String, CodingKey {
        case temperature = "temp"
    }
}
