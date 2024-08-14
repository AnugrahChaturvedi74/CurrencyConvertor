//
//  CurrencyModel.swift
//  CurrencyConvertor
//
//  Created by Anugrah on 14/08/24.
//

import Foundation

struct CurrencyModel: Codable {
    let disclaimer: String
    let license: String
    let timestamp: Int
    let base: String
    let rates: [String: Double]?
}
