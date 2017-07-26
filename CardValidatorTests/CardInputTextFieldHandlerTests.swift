//
//  CardInputTextFieldHandlerTests.swift
//  CardInputTextFieldHandlerTests
//
//  Created by Eugene on 18.07.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import XCTest
@testable import CardValidator

class CardInputTextFieldHandlerTests: XCTestCase {
    
    typealias Command = CardInputTextFieldHandler.TextFieldChangeCommand
    
    lazy var sut:CardInputTextFieldHandler = {
        let tfs = [TextField()]
        return CardInputTextFieldHandler(tfs)
    }()
    
//    MARK: Tests
    
    func testInitTextFieldsSet()
    {
        let expected = [TextField()]
        sut = CardInputTextFieldHandler(expected)
        XCTAssertEqual(expected, sut.textFields)
    }
    
    
    func testNumberInputLargerThan16WithFullNextDenied()
    {
        let expected = Command.denyEdit
        
        let testText = "1234 1242 2411 1242"
        let testNextText = "12/12"
        let testReplacementString = "1"
        let change = TextFieldChange(text: testText, nextTFText: testNextText, location: 19, isDeleting: false, replacementString: testReplacementString)
        let result = sut.handleTextFieldChange(change, for: .number)
        
        XCTAssertEqual(expected, result)
    }
    
    func testTextFieldMoveNumberLargerThan16WithNotFullNext()
    {
        let expected = Command.editAndMoveToNeighbour(.next)
        
        let testText = "1234 1242 2411 1242"
        let testNextText = ""
        let testReplacementString = "1"
        let change = TextFieldChange(text: testText, nextTFText: testNextText, location: 19, isDeleting: false, replacementString: testReplacementString)
        let result = sut.handleTextFieldChange(change, for: .number)
        
        XCTAssertEqual(expected, result)
    }
    
    
    func testSpacesAddOnNumberInput()
    {

        let testReplacementString = "1"
        let testNextText = ""
        
        let testData = [("1234",4), ("1234 1234", 9), ("1234 1234 1234", 14)]
        
        for data in testData{
            
            let expected = Command.editAndUpdateText(data.0 + " ")
            let change = TextFieldChange(text: data.0, nextTFText: testNextText, location: data.1, isDeleting: false, replacementString: testReplacementString)
            let result = sut.handleTextFieldChange(change, for: .number)
            XCTAssertEqual(expected, result)
        }
    }
    
    
    func testSpacesDeleteOnNumberDelete()
    {
        
        let testReplacementString = "1"
        let testNextText = ""
        
        let testData = [("1234 2", 5), ("1234 1234 2", 10), ("1234 1234 1234 2", 15)]
        
        for data in testData{
            let testText = data.0
            let expectedText = testText.substring(to: testText.index(before: testText.endIndex))
            let expected = Command.editAndUpdateText(expectedText)
            let change = TextFieldChange(text: testText, nextTFText: testNextText, location: data.1, isDeleting: true, replacementString: testReplacementString)
            let result = sut.handleTextFieldChange(change, for: .number)
            XCTAssertEqual(expected, result)
        }

    }
    
    
    func testNumberCharacterEnterDenied()
    {
        let expected = Command.denyEdit
        
        let testText = ""
        let testNextText = ""
        let testReplacementString = "a"
        let change = TextFieldChange(text: testText, nextTFText: testNextText, location: 0, isDeleting: false, replacementString: testReplacementString)
        let result = sut.handleTextFieldChange(change, for: .expirationDate)
        
        XCTAssertEqual(expected, result)
    }
    
    
    func testExpirationDateInputLargerThan4WithFullNextDenied()
    {
        let expected = Command.denyEdit
        
        let testText = "12/12"
        let testNextText = "111"
        let testReplacementString = "1"
        let change = TextFieldChange(text: testText, nextTFText: testNextText, location: 5, isDeleting: false, replacementString: testReplacementString)
        let result = sut.handleTextFieldChange(change, for: .expirationDate)
        
        XCTAssertEqual(expected, result)
    }
    
    
    func testExpirationDateInputMoveToNext()
    {
        let expected = Command.editAndMoveToNeighbour(.next)
        
        let testText = "12/12"
        let testNextText = ""
        let testReplacementString = "1"
        let change = TextFieldChange(text: testText, nextTFText: testNextText, location: 5, isDeleting: false, replacementString: testReplacementString)
        let result = sut.handleTextFieldChange(change, for: .expirationDate)
        
        XCTAssertEqual(expected, result)
    }
    
    
    func testExpirationDateDeleteMoveToPrevious()
    {
        let expected = Command.moveToNeighbourAndClear(.previous)
        
        let testText = "1"
        let testNextText = ""
        let testReplacementString = "1"
        let change = TextFieldChange(text: testText, nextTFText: testNextText, location: 0, isDeleting: true, replacementString: testReplacementString)
        let result = sut.handleTextFieldChange(change, for: .expirationDate)
        
        XCTAssertEqual(expected, result)
    }
    
    
    func testExpirationDateInputSlashAdd()
    {
        
        let testText = "12"
        let expected = Command.editAndUpdateText(testText + "/")
        
        let testReplacementString = "1"
        let testNextText = ""
        let change = TextFieldChange(text: testText, nextTFText: testNextText, location: 2, isDeleting: false, replacementString: testReplacementString)
        let result = sut.handleTextFieldChange(change, for: .expirationDate)
        
        XCTAssertEqual(expected, result)
    }
    
    func testExpirationDateInputSlashDelete()
    {
        
        let testText = "12/1"
        let expected = Command.editAndUpdateText("12/")
        
        let testReplacementString = ""
        let testNextText = ""
        let change = TextFieldChange(text: testText, nextTFText: testNextText, location: 3, isDeleting: true, replacementString: testReplacementString)
        let result = sut.handleTextFieldChange(change, for: .expirationDate)
        
        XCTAssertEqual(expected, result)
    }
    
    
    func testCVVInputLargerThan3Denied()
    {
        let expected = Command.denyEdit
        let testText = "111"
        let testNextText = ""
        let testReplacementString = "1"
        let change = TextFieldChange(text: testText, nextTFText: testNextText, location: 3, isDeleting: false, replacementString: testReplacementString)
        let result = sut.handleTextFieldChange(change, for: .cvv)
        
        XCTAssertEqual(expected, result)
    }
    
    func testCVVDeleteMoveToPrevious()
    {
        let expected = Command.moveToNeighbourAndClear(.previous)
        let testText = "1"
        let testNextText = ""
        let testReplacementString = "1"
        let change = TextFieldChange(text: testText, nextTFText: testNextText, location: 0, isDeleting: true, replacementString: testReplacementString)
        let result = sut.handleTextFieldChange(change, for: .cvv)
        
        XCTAssertEqual(expected, result)
    }

    func createSut()
    {
        let tfs = [TextField()]
        sut = CardInputTextFieldHandler(tfs)
        
    }
}
