//
//  URLManager.swift
//  R&M
//
//  Created by Stanislav Demyanov on 26.01.2023.
//

import Foundation

class URLManager {
    static let urlString = "https://rickandmortyapi.com/api"
    
    static func rickURLCreator(page: Int) -> String {
        return urlString + "/character/?page=\(page)"
    }
    static func charNameFinder(name: String) -> String {
        return urlString + "/character/?name=\(name)"
    }
}



