import Foundation

enum WeatherError : Error {
    case requestFailed
    case decodeFailed
    case invalidURL
}

class WeatherService {
    
    private let key = "92138db50b8f29d7a4f86501eb7dfca6"

    func getWeather(forCity city: String, completion: @escaping (Result<WeatherModel?, WeatherError>) -> Void) {
        
        let fullURL = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=92138db50b8f29d7a4f86501eb7dfca6&units=metric"
        
        guard let weatherUrl = URL(string: fullURL) else {
            completion(.failure(.invalidURL))
            return }
        
        URLSession.shared.dataTask(with: weatherUrl) { (data, _, error) in
            guard let data = data else {
                completion(.failure(.requestFailed))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(WeatherModel.self, from: data)
                completion(.success(weatherData))
            } catch {
                completion(.failure(.decodeFailed))
            }
        }.resume()
    }
}
