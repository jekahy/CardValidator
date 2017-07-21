//
//  CardGenerationService.swift
//  CardValidator
//
//  Created by Eugene on 20.07.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import UIKit

enum CreditCardKind {
    
    case masterCard
    case visa
    
    var startNumbers:String {
        switch self {
            case .masterCard:   return "5424"
            case .visa:         return "4013"
        }
    }
}


final class CardGenerationService {
    
    
    static func generateCard(kind:CreditCardKind)->CreditCard
    {

        let beginning = kind.startNumbers.components(separatedBy: "").flatMap{Int($0)}
        
        let middle = generateRandomPart()
        let lastNumber = calculateLastNumber(from: beginning + middle)
        
        let wholeNumber = (beginning + middle + [lastNumber]).reduce(""){$0.0 + String($0.1)}
        
        return  CreditCard(number: wholeNumber, expiration: nil, cvv: nil)
    }
    
    static func generateRandomPart()->[Int]
    {
        var randomPart = [Int]()
        for _ in 0...10 {
            // Generates a random integer within a range [0,9]
            let randomNum = Int(arc4random_uniform(10))
            randomPart.append(randomNum)
        }
        return randomPart
    }
    
    static func calculateLastNumber(from numbers:[Int])->Int
    {
        let sumOfEverySecondNum = numbers.enumerated()
            .filter{$0.offset % 2 == 0}
            .map{$0.1}
            .reduce(0){$0 + $1}
        
        let sumOfOtherNumsMulitpliedBy2 = numbers.enumerated()
            .filter{$0.offset % 2 != 0}
            .map{$0.1*2}
            .map{ $0 > 9 ? $0 - 9 : $0}
            .reduce(0){$0 + $1}
        
        let sumOf2nums = sumOfEverySecondNum + sumOfOtherNumsMulitpliedBy2
        
        let largerNumber = findLargerNumberDividableBy10(to: sumOf2nums)
        
        let finalNumber = largerNumber - sumOf2nums
        return finalNumber
    }
    
    static func findLargerNumberDividableBy10(to number:Int)->Int
    {
        
        let  remainder = number % 10
        if remainder == 0 {
            return number
        }
        return number - remainder + 10
    }
    
}
