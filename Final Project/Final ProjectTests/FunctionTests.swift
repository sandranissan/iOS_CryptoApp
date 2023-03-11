//
//  FunctionTests.swift
//  Final ProjectTests
//
//  Created by Hugo Leander on 2021-12-13.
//

import XCTest
@testable import Final_Project
import SwiftUI
import CoreData

class FunctionTests: XCTestCase {
    
    var persistenceController = CoreDataTestStack.init()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testPercentageIsCorrectWileNotOwningAnyShares() throws {
        let currencyModel = CurrencyModel()
        
        //case 1, start point
        currencyModel.availableToBuyFor = currencyModel.startMoney
        let startPercentage = currencyModel.calcPercentage(worthNow: currencyModel.availableToBuyFor)
        XCTAssertEqual( startPercentage , 0)
        XCTAssertNotEqual(startPercentage, 100)
        XCTAssertNotEqual(startPercentage, 1)
        XCTAssertNotEqual(startPercentage, -1)
        
        //case 2, basic
        currencyModel.availableToBuyFor = 300000
        let basicPercentage = currencyModel.calcPercentage(worthNow: currencyModel.availableToBuyFor)
        XCTAssertEqual( basicPercentage , 50)
        XCTAssertNotEqual(basicPercentage, 150)
        XCTAssertNotEqual(basicPercentage, -50)
        
        //case 3, more extreme
        currencyModel.availableToBuyFor = 876543
        let moreExtremePercentage = currencyModel.calcPercentage(worthNow: currencyModel.availableToBuyFor)
        XCTAssertEqual( moreExtremePercentage , 338.2715)
        XCTAssertNotEqual(moreExtremePercentage, -338.2715)
        XCTAssertNotEqual(moreExtremePercentage, 438.2715)
        
        //case 4, no money left
        currencyModel.availableToBuyFor = 0
        let noMoneyPercentage = currencyModel.calcPercentage(worthNow: currencyModel.availableToBuyFor)
        XCTAssertEqual( noMoneyPercentage , -100)
        XCTAssertNotEqual(noMoneyPercentage, 100)
        XCTAssertNotEqual(noMoneyPercentage, 0)
    }
    
    func sumWorthNow() -> Double { // found this on stackOverflow at: https://stackoverflow.com/questions/14822618/core-data-sum-of-all-instances-attribute 2021 - 12 - 14
        let moc = persistenceController.persistentContainer.viewContext
        var amountTotal : Double = 0
        
        let expression = NSExpressionDescription()
        expression.expression =  NSExpression(forFunction: "sum:", arguments:[NSExpression(forKeyPath: "worthNowPrice")])
        expression.name = "amountTotal";
        expression.expressionResultType = NSAttributeType.doubleAttributeType
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "OwnedCrypto")
        fetchRequest.propertiesToFetch = [expression]
        fetchRequest.resultType = NSFetchRequestResultType.dictionaryResultType
        
        do {
            let results = try  moc.fetch(fetchRequest)
            print(results)
            let resultMap = results[0] as! [String:Double]
            amountTotal = resultMap["amountTotal"]!
        } catch let error as NSError {
            NSLog("Error when summing amounts: \(error.localizedDescription)")
        }
        
        return amountTotal
    }
    
    func testSum() {
        let moc = persistenceController.persistentContainer.viewContext
        let ownedCrypto = OwnedCrypto(context: moc)
        ownedCrypto.id = UUID().uuidString
        ownedCrypto.name = "Bitcoin"
        ownedCrypto.amountBought = 2.0
        ownedCrypto.boughtPrice = 49000.0
        ownedCrypto.worthNowPrice = 60000.0
        
        let ownedCrypto2 = OwnedCrypto(context: moc)
        ownedCrypto2.id = UUID().uuidString
        ownedCrypto2.name = "Dogecoin"
        ownedCrypto2.amountBought = 2.0
        ownedCrypto2.boughtPrice = 49000.0
        ownedCrypto2.worthNowPrice = 60000.0
        
        try? moc.save()
        
        let listWithOwnedCryptos = OwnedCrypto.fetchRequest()
        listWithOwnedCryptos.predicate = NSPredicate(format: "name == %@", name)
        do {
            _ = try moc.fetch(listWithOwnedCryptos).first
            XCTAssertEqual(sumWorthNow(), 120000.0)
        } catch {
            print("Error")
        }
    }
    
    func addToOwned(name: String, amountBought: Double, boughtPrice: Double, worthNowPrice: Double) {
        let moc = persistenceController.persistentContainer.viewContext
        let newOwned = OwnedCrypto(context: moc)
        newOwned.id = UUID().uuidString
        newOwned.name = name
        newOwned.amountBought = amountBought
        newOwned.boughtPrice = boughtPrice
        newOwned.worthNowPrice = worthNowPrice * amountBought
        
        try? moc.save()
    }
    
    func testAddToOwned() {
        
        addToOwned(name: "Bitcoin", amountBought: 2, boughtPrice: 40000, worthNowPrice: 60000)
        let moc = persistenceController.persistentContainer.viewContext
        let listWithOwnedCryptos = OwnedCrypto.fetchRequest()
        listWithOwnedCryptos.predicate = NSPredicate(format: "name == %@", name)
        do{
            let result = try moc.fetch(listWithOwnedCryptos).first
            XCTAssertEqual(result?.name, "Bitcoin")
        }catch{
            print("Error")
        }
        
    }
    
    func testConvertionFromDoubleToStringWithSpecificDecimals() throws {
        let currencyModel = CurrencyModel()
        let testPriceWith3Decimals = currencyModel.turnIntoDecimals(amountOfDecimals: 3, price: 30.123456)
        let testPriceWith6Decimals = currencyModel.turnIntoDecimals(amountOfDecimals: 6, price: 30000.987654321)
        XCTAssertEqual(testPriceWith3Decimals, "30.123")
        XCTAssertEqual(testPriceWith6Decimals, "30000.987654")
    }
    
    
}
