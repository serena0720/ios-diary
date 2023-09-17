//
//  Weather.swift
//  Diary
//
//  Created by Zion, Serena on 2023/09/17.
//

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
