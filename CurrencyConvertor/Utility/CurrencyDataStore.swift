//
//  CurrencyDataStore.swift
//  CurrencyConvertor
//
//  Created by Anugrah on 14/08/24.
//

import Foundation

class CurrencyDataStore {
    private let defaults = UserDefaults.standard
    private let lastFetchKey = "LastFetchTime"
    private let currencyRatesKey = "CurrencyRates"
    
    func saveCurrencyRates(_ rates: [String: Double]) {
        defaults.set(rates, forKey: currencyRatesKey)
        defaults.set(Date(), forKey: lastFetchKey)
    }
    
    func loadCurrencyRates() -> [String: Double]? {
        return defaults.dictionary(forKey: currencyRatesKey) as? [String: Double]
    }
    
    func canFetchNewData() -> Bool {
        if let lastFetch = defaults.object(forKey: lastFetchKey) as? Date {
            return Date().timeIntervalSince(lastFetch) > 1800 // 30 minutes
        }
        return true
    }
}
