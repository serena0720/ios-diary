//
//  DiaryContentDTO.swift
//  Diary
//
//  Created by Zion, Serena on 2023/09/14.
//

import Foundation

struct DiaryContentDTO: Hashable {
    var body: String
    var date: Double
    var title: String
    var identifier: UUID
}
