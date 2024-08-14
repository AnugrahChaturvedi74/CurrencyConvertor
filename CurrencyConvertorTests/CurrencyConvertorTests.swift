//
//  CurrencyConvertorTests.swift
//  CurrencyConvertorTests
//
//  Created by Anugrah on 14/08/24.
//

import XCTest
@testable import CurrencyConvertor

class CurrencyConverterTests: XCTestCase {
    
    var viewModel: CurrencyConverterViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = CurrencyConverterViewModel()
    }
    
    func testCurrencyConversion() {
        // Mock data
        viewModel.currencyRates = ["USD": 1.0, "EUR": 0.85, "JPY": 110.0]
        
        let conversions = viewModel.convert(amount: 100, from: "USD")
        
        XCTAssertEqual(conversions["EUR"], 85.0)
        XCTAssertEqual(conversions["JPY"], 11000.0)
    }
    
    func testFetchRatesFromAPI() {
        let expectation = self.expectation(description: "Fetch rates")
        
        viewModel.fetchRatesIfNeeded { success in
            XCTAssertTrue(success)
            XCTAssertFalse(self.viewModel.currencyRates.isEmpty)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
