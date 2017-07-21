//
//  CreditCardInputFieldTests.swift
//  CardValidator
//
//  Created by Eugene on 21.07.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import XCTest
@testable import CardValidator

class CreditCardInputFieldTests: XCTestCase {
    
    var sut:CreditCardInputField!
    
    override func setUp()
    {
        super.setUp()
        createSut()
       
    }
    
//    MARK: Tests
    
    func testInitStackViewParamsSet()
    {
        XCTAssertEqual(sut.distribution, .fillProportionally)
        XCTAssertEqual(sut.spacing, sut.elementSpacing)
    }
    
    func testInitAllFieldsAndHandlerNotNil()
    {
        XCTAssertNotNil(sut.cardNumberTF)
        XCTAssertNotNil(sut.expirationDateTF)
        XCTAssertNotNil(sut.cvvTF)
        XCTAssertNotNil(sut.tfHandler)
    }
    
    func testInitPlaceholdersSet()
    {
        XCTAssertEqual(sut.cardNumberTF.placeholder,sut.numberPlaceholder)
        XCTAssertEqual(sut.expirationDateTF.placeholder,sut.expirationPlaceholder)
        XCTAssertEqual(sut.cvvTF.placeholder,sut.cvvPlaceholder)
    }
    
    func testInitTextFieldsAddToStackView()
    {
        XCTAssertEqual(sut.arrangedSubviews, sut.textFields)
    }
    
    
    func testInitTextFieldTagsSet()
    {
        let expected = [0,1,2]
        let result = sut.textFields.map{$0.tag}
        XCTAssertEqual(expected, result)
    }
    
    
    func testInitTextFieldsDelegateSet()
    {
        let expected = Array.init(repeating: sut.tfHandler, count: 3)
        let result = sut.textFields.flatMap{$0.delegate} as! [CardInputTextFieldHandler]
        XCTAssertEqual(expected, result)
    }
    
    
    func testTextFieldsContainTextFields()
    {
        XCTAssertEqual(sut.textFields, [sut.cardNumberTF, sut.expirationDateTF, sut.cvvTF])
    }
    
    func testCurrentCreditCardGet()
    {
        let expiration = Expiration(string: "11/11")
        let expected = CreditCard(number: "1111111122222222", expiration: expiration, cvv: "123")
        sut.cardNumberTF.text = "1111 1111 2222 2222"
        sut.expirationDateTF.text = "11/11"
        sut.cvvTF.text = "123"
        
        XCTAssertEqual(expected, sut.currentCreditCard)
    }
    
    func testCurrentCreditCardSetTextfieldsUpdate()
    {
        let expectedNumber = "1111 1111 2222 2222"
        let expectedDate = "11/12"
        let expectedCVV = "123"
        
        let expiration = Expiration(string: expectedDate)
        let expected = CreditCard(number: "1111111122222222", expiration: expiration, cvv: expectedCVV)
        sut.currentCreditCard = expected
        
        XCTAssertEqual(sut.cardNumberTF.text, expectedNumber)
        XCTAssertEqual(sut.expirationDateTF.text, expectedDate)
        XCTAssertEqual(sut.cvvTF.text, expectedCVV)
    }

    
//    MARK: Helpers
    
    func createSut()
    {
        sut = CreditCardInputField()
    }
    
}
