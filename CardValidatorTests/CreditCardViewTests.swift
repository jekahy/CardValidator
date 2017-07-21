//
//  CreditCardViewTests.swift
//  CardValidator
//
//  Created by Eugene on 21.07.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import XCTest
@testable import CardValidator

class CreditCardViewTests: XCTestCase {
    
    let sut:CreditCardView = CreditCardView()
    
//    MARK: Tests

    func testInitPropertiesNotNil()
    {
        XCTAssertNotNil(sut.inputField)
        XCTAssertNotNil(sut.validateButton)
        XCTAssertNotNil(sut.generateButton)
        XCTAssertNotNil(sut.activityIndicator)
        XCTAssertNotNil(sut.validityIndicator)
    }
    
    func testIniAllSubviewsAdded()
    {
        let expected = Set<UIView>(arrayLiteral: sut.inputField.view, sut.validateButton, sut.generateButton, sut.activityIndicator, sut.validityIndicator)
        
        let result = Set<UIView>(sut.subviews)
        XCTAssertEqual(expected, result)
    }
    
    func testToggleBusyMode()
    {
        sut.toggleBusyMode(true)
        XCTAssertFalse(sut.isUserInteractionEnabled)
        XCTAssertFalse(sut.activityIndicator.isHidden)
        XCTAssertTrue(sut.validityIndicator.isHidden)
        XCTAssertTrue(sut.activityIndicator.isAnimating)
        
        
        sut.toggleBusyMode(false)
        XCTAssertTrue(sut.isUserInteractionEnabled)
        XCTAssertTrue(sut.activityIndicator.isHidden)
        XCTAssertFalse(sut.validityIndicator.isHidden)
        XCTAssertFalse(sut.activityIndicator.isAnimating)
    }
    
    func testGenerateTapClosureSetCurrentCard()
    {
        let expiration = Expiration(string: "11/11")
        let testCreditCard = CreditCard(number: "1111111122222222", expiration: expiration, cvv: "123")

        sut.generateTapClosure = {
            return testCreditCard
        }
        sut.generateButton.didTouchUpInside()
        
        let expected = testCreditCard
        
        let result = sut.inputField.currentCreditCard
        
        XCTAssertEqual(expected, result)
    }
    
    func testValidateTapClosureUpdateValidity()
    {
        let expiration = Expiration(string: "11/11")
        let testCreditCard = CreditCard(number: "1111111122222222", expiration: expiration, cvv: "123")
        
        sut.inputField.currentCreditCard = testCreditCard
        
        sut.validateTapClosure = { card, competion in
             competion(true)
        }
        
        sut.validateButton.didTouchUpInside()
        
        XCTAssertFalse(sut.validityIndicator.isHidden)
        XCTAssertTrue(sut.activityIndicator.isHidden)
        XCTAssertTrue(sut.validityIndicator.isValid)
        
    }
    
}
