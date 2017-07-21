//
//  CardGenerationServiceTests.swift
//  CardValidator
//
//  Created by Eugene on 21.07.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import XCTest
@testable import CardValidator

class CardGenerationServiceTests: XCTestCase {
    
    
    func testRandomPartGenerationCount()
    {
        let result = CardGenerationService.generateRandomPart()
        XCTAssertTrue(result.count == 11)
    }
    
    func testLastNumberCalculation()
    {
        let numbers = [4013,5,1,8,6,1,6,4,1,5,3,5]
        let expected = 0
        
        let result = CardGenerationService.calculateLastNumber(from: numbers)
        XCTAssertEqual(expected, result)
    }
    
    func testFindLargestnumberDividableBy10()
    {
        var expected = 60
        var result = CardGenerationService.findLargerNumberDividableBy10(to: 51)
        XCTAssertEqual(expected, result)
        
        expected = 40
        result = CardGenerationService.findLargerNumberDividableBy10(to: 38)
        XCTAssertEqual(expected, result)
    }
}
