//
//  ArticleEntity.swift
//  VIPER_Sample_swift
//
//  Created by park kyung seok on 2021/11/09.
//

import Foundation

struct ArticleEntity: Codable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}
