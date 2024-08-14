//
//  DashboardVM.swift
//  CurrencyConvertor
//
//  Created by Anugrah on 14/08/24.
//

import Foundation

class CurrencyConverterViewModel {
    
    private let apiManager = APIManager()
    private let dataStore = CurrencyDataStore()
    
    var currencyRates: [String: Double] = [:]
    
    func fetchRatesIfNeeded(completion: @escaping (Bool) -> Void) {
       
        if dataStore.canFetchNewData() == false {
            
            // get data from Userdefault
            if let savedRates = dataStore.loadCurrencyRates() {
                currencyRates = savedRates
                completion(true)
            } else {
                completion(false)
            }
            return
        }
  
        guard let url = URL(string: "\(Constant.baseUrl)?app_id=\(Constant.apiKey)") else {
            completion(false)
            return
        }
        // get data from API
        apiManager.getApiData(url: url, resultType: CurrencyModel.self) { [weak self] result in
            switch result {
            case .success(let response):
                self?.currencyRates = response.rates ?? [:]
                self?.dataStore.saveCurrencyRates(response.rates ?? [:])
                completion(true)
            case .failure(let error):
                print("Error fetching currency rates: \(error)")
                if let savedRates = self?.dataStore.loadCurrencyRates() {
                    self?.currencyRates = savedRates
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    func convert(amount: Double, from currency: String) -> [String: Double] {
        guard let fromRate = currencyRates[currency] else { return [:] }
        var conversions: [String: Double] = [:]
        
        for (currencyCode, rate) in currencyRates {
            conversions[currencyCode] = (amount / fromRate) * rate
        }
        
        return conversions
    }
}
