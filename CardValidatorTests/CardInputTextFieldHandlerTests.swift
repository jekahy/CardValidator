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
        let expected = CardInputTextFieldHandler.TextFieldChangeCommand.denyEdit
        
        let testText = "1234 1242 2411 1242"
        let testNextText = "12/12"
        let testRange = NSRange(location: 19, length: 0)
        let testReplacementString = "1"
        let result = sut.handleTextFieldChange(textFieldKind: .number, text: testText, nextTextFieldText:testNextText , shouldChangeCharactersIn: testRange, replacementString: testReplacementString)
        
        XCTAssertEqual(expected, result)
    }
    
    func testTextFieldMoveNumberLargerThan16WithNotFullNext()
    {
        let expected = CardInputTextFieldHandler.TextFieldChangeCommand.editAndMoveToNeighbour(.next)
        
        let testText = "1234 1242 2411 1242"
        let testNextText = ""
        let testRange = NSRange(location: 19, length: 0)
        let testReplacementString = "1"
        let result = sut.handleTextFieldChange(textFieldKind: .number, text: testText, nextTextFieldText:testNextText , shouldChangeCharactersIn: testRange, replacementString: testReplacementString)
        
        XCTAssertEqual(expected, result)
    }
    
    
    func testSpacesAddOnNumberInput()
    {

        var testText = "1234"
        var expected = CardInputTextFieldHandler.TextFieldChangeCommand.editAndUpdateText(testText + " ")
        
        let testReplacementString = "1"
        let testNextText = ""
        var testRange = NSRange(location: 4, length: 0)
        
        var result = sut.handleTextFieldChange(textFieldKind: .number, text: testText, nextTextFieldText:testNextText , shouldChangeCharactersIn: testRange, replacementString: testReplacementString)
        
        XCTAssertEqual(expected, result)
        
        testText = "1234 1234"
        testRange = NSRange(location: 9, length: 0)
        
        expected = CardInputTextFieldHandler.TextFieldChangeCommand.editAndUpdateText(testText + " ")
        
        result = sut.handleTextFieldChange(textFieldKind: .number, text: testText, nextTextFieldText:testNextText , shouldChangeCharactersIn: testRange, replacementString: testReplacementString)
        
        XCTAssertEqual(expected, result)
        
        testText = "1234 1234 1234"
        testRange = NSRange(location: 14, length: 0)
        
        expected = CardInputTextFieldHandler.TextFieldChangeCommand.editAndUpdateText(testText + " ")
        
        result = sut.handleTextFieldChange(textFieldKind: .number, text: testText, nextTextFieldText:testNextText , shouldChangeCharactersIn: testRange, replacementString: testReplacementString)
        
        XCTAssertEqual(expected, result)
    }
    
    
    func testSpacesDeleteOnNumberDelete()
    {
        
        let testReplacementString = "1"
        let testNextText = ""
        
        var expected = CardInputTextFieldHandler.TextFieldChangeCommand.editAndUpdateText("1234 ")
        var testText = "1234 2"
        var testRange = NSRange(location: 5, length: 1)
        
        var result = sut.handleTextFieldChange(textFieldKind: .number, text: testText, nextTextFieldText:testNextText , shouldChangeCharactersIn: testRange, replacementString: testReplacementString)
        
        XCTAssertEqual(expected, result)
        
        
        expected = CardInputTextFieldHandler.TextFieldChangeCommand.editAndUpdateText("1234 1234 ")
        
        testText = "1234 1234 2"
        testRange = NSRange(location: 10, length: 1)
        
        result = sut.handleTextFieldChange(textFieldKind: .number, text: testText, nextTextFieldText:testNextText , shouldChangeCharactersIn: testRange, replacementString: testReplacementString)
        
        XCTAssertEqual(expected, result)
        
        
        expected = CardInputTextFieldHandler.TextFieldChangeCommand.editAndUpdateText("1234 1234 1234 ")
        
        testText = "1234 1234 1234 2"
        testRange = NSRange(location: 15, length: 1)
        
        result = sut.handleTextFieldChange(textFieldKind: .number, text: testText, nextTextFieldText:testNextText , shouldChangeCharactersIn: testRange, replacementString: testReplacementString)
        
        XCTAssertEqual(expected, result)
    }
    
    func testNumberCharacterEnterDenied()
    {
        let expected = CardInputTextFieldHandler.TextFieldChangeCommand.denyEdit
        
        let testText = ""
        let testNextText = ""
        let testRange = NSRange(location: 0, length: 0)
        let testReplacementString = "a"
        let result = sut.handleTextFieldChange(textFieldKind: .number, text: testText, nextTextFieldText:testNextText , shouldChangeCharactersIn: testRange, replacementString: testReplacementString)
        
        XCTAssertEqual(expected, result)
    }
    
    
    func testExpirationDateInputLargerThan4WithFullNextDenied()
    {
        let expected = CardInputTextFieldHandler.TextFieldChangeCommand.denyEdit
        
        let testText = "12/12"
        let testNextText = "111"
        let testRange = NSRange(location: 5, length: 0)
        let testReplacementString = "1"
        let result = sut.handleTextFieldChange(textFieldKind: .expirationDate, text: testText, nextTextFieldText:testNextText , shouldChangeCharactersIn: testRange, replacementString: testReplacementString)
        
        XCTAssertEqual(expected, result)
    }
    
    
    func testExpirationDateInputMoveToNext()
    {
        let expected = CardInputTextFieldHandler.TextFieldChangeCommand.editAndMoveToNeighbour(.next)
        
        let testText = "12/12"
        let testNextText = ""
        let testRange = NSRange(location: 5, length: 0)
        let testReplacementString = "1"
        let result = sut.handleTextFieldChange(textFieldKind: .expirationDate, text: testText, nextTextFieldText:testNextText , shouldChangeCharactersIn: testRange, replacementString: testReplacementString)
        
        XCTAssertEqual(expected, result)
    }
    
    
    func testExpirationDateDeleteMoveToPrevious()
    {
        let expected = CardInputTextFieldHandler.TextFieldChangeCommand.moveToNeighbourAndClear(.previous)
        
        let testText = "1"
        let testNextText = ""
        let testRange = NSRange(location: 0, length: 1)
        let testReplacementString = "1"
        let result = sut.handleTextFieldChange(textFieldKind: .expirationDate, text: testText, nextTextFieldText:testNextText , shouldChangeCharactersIn: testRange, replacementString: testReplacementString)
        
        XCTAssertEqual(expected, result)
    }
    
    
    func testExpirationDateInputSlashAdd()
    {
        
        let testText = "12"
        let expected = CardInputTextFieldHandler.TextFieldChangeCommand.editAndUpdateText(testText + "/")
        
        let testReplacementString = "1"
        let testNextText = ""
        let testRange = NSRange(location: 2, length: 0)
        
        let result = sut.handleTextFieldChange(textFieldKind: .expirationDate, text: testText, nextTextFieldText:testNextText , shouldChangeCharactersIn: testRange, replacementString: testReplacementString)
        
        XCTAssertEqual(expected, result)
    }
    
    func testExpirationDateInputSlashDelete()
    {
        
        let testText = "12/1"
        let expected = CardInputTextFieldHandler.TextFieldChangeCommand.editAndUpdateText("12/")
        
        let testReplacementString = ""
        let testNextText = ""
        let testRange = NSRange(location: 3, length: 1)
        
        let result = sut.handleTextFieldChange(textFieldKind: .expirationDate, text: testText, nextTextFieldText:testNextText , shouldChangeCharactersIn: testRange, replacementString: testReplacementString)
        
        XCTAssertEqual(expected, result)
    }
    
    
    func testCVVInputLargerThan3Denied()
    {
        let expected = CardInputTextFieldHandler.TextFieldChangeCommand.denyEdit
        let testText = "111"
        let testNextText = ""
        let testRange = NSRange(location: 3, length: 0)
        let testReplacementString = "1"
        let result = sut.handleTextFieldChange(textFieldKind: .cvv, text: testText, nextTextFieldText:testNextText , shouldChangeCharactersIn: testRange, replacementString: testReplacementString)
        
        XCTAssertEqual(expected, result)
    }
    
    func testCVVDeleteMoveToPrevious()
    {
        let expected = CardInputTextFieldHandler.TextFieldChangeCommand.moveToNeighbourAndClear(.previous)
        let testText = "1"
        let testNextText = ""
        let testRange = NSRange(location: 0, length: 1)
        let testReplacementString = "1"
        let result = sut.handleTextFieldChange(textFieldKind: .cvv, text: testText, nextTextFieldText:testNextText , shouldChangeCharactersIn: testRange, replacementString: testReplacementString)
        
        XCTAssertEqual(expected, result)
    }

    func createSut()
    {
        let tfs = [TextField()]
        sut = CardInputTextFieldHandler(tfs)
        
    }
}
