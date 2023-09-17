//
//  WeatherInformation.swift
//  Diary
//
//  Created by Zion, Serena on 2023/09/17.
//

struct WeatherInformation: Decodable {
    let coordinate: String
    let weather: [Weather]
    let base: String
    let main: String
    let visibility: String
    let wind: String
    let rain: String
    let clouds: String
    let date: String
    let system: String
    let timeZone: String
    let id: String
    let name: String
    let code: String
    
    private enum CodingKeys: String, CodingKey {
        case coordinate = "coord"
        case weather
        case base
        case main
        case visibility
        case wind
        case rain
        case clouds
        case date = "dt"
        case system = "sys"
        case timeZone = "timezone"
        case id
        case name
        case code = "cod"
    }
}
