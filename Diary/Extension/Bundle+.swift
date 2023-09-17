//
//  Bundle+.swift
//  Diary
//
//  Created by Zion, Serena on 2023/09/17.
//

import Foundation

extension Bundle {
    var APIKey: String {
        guard let file = self.path(forResource: "APIKey", ofType: "plist") else { return "" }
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["APIKey"] as? String else {
            fatalError("APIKey.plist에 Authorization를 설정해주세요.")
        }
        
        return key
    }
}
