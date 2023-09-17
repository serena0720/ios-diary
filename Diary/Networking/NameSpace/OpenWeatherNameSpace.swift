//
//  OpenWeatherNameSpace.swift
//  Diary
//
//  Created by Zion, Serena on 2023/09/17.
//

import Foundation

struct OpenWeatherNameSpace {
    static let scheme = "https"
    static let host = "api.openweathermap.org"
    static let phenomenaPath = "/data/2.5/weather"
    static let iconURL = "https://openweathermap.org/img/wn/"
    static let iconFormat = "@2x.png"
    static let apiKey = Bundle.main.APIKey
}
