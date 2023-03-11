//
//  ContentView.swift
//  Final Project
//
//  Created by Sandra Nissan on 2021-11-29.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var crypto: CurrencyModel
    @State var changeTotalToAvailable = false
    @State var showButton: Bool = UserDefaults.standard.bool(forKey: "BOOL_KEY")
    
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [])
    private var ownedCryptos: FetchedResults<OwnedCrypto>
    
    
    func sumWorthNow() -> Double { // found this on stackOverflow at: https://stackoverflow.com/questions/14822618/core-data-sum-of-all-instances-attribute 2021 - 12 - 14
        var amountTotal : Double = 0
        
        let expression = NSExpressionDescription()
        expression.expression =  NSExpression(forFunction: "sum:", arguments:[NSExpression(forKeyPath: "worthNowPrice")])
        expression.name = "amountTotal";
        expression.expressionResultType = NSAttributeType.doubleAttributeType
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "OwnedCrypto")
        fetchRequest.propertiesToFetch = [expression]
        fetchRequest.resultType = NSFetchRequestResultType.dictionaryResultType
        
        do {
            let results = try  viewContext.fetch(fetchRequest)
            let resultMap = results[0] as! [String:Double]
            amountTotal = resultMap["amountTotal"]!
        } catch let error as NSError {
            NSLog("Error when summing amounts: \(error.localizedDescription)")
        }
        
        return amountTotal
    }
    
    var body: some View {
        TabView{
            HStack{
                ZStack{
                    VStack{
                        HStack{
                            if changeTotalToAvailable == false {
                                Text("Total: ")
                                    .foregroundColor(.black)
                                    .font(.headline)
                            } else {
                                Text("To buy for: ")
                                    .foregroundColor(.black)
                                    .font(.headline)
                            }
                            Button(action: {
                                changeTotalToAvailable.toggle()
                            }, label: {
                                if changeTotalToAvailable == false {
                                    Text("\(crypto.turnIntoDecimals(amountOfDecimals: 0, price: crypto.availableToBuyFor + sumWorthNow())) $")
                                        .padding()
                                        .foregroundColor(.white)
                                        .font(.headline)
                                        .padding(.horizontal,10)
                                        .background(
                                            Color.mint
                                                .cornerRadius(10)
                                                .shadow(radius: 10) )
                                        .lineLimit(1)
                                } else {
                                    Text("\(crypto.turnIntoDecimals(amountOfDecimals: 0, price: crypto.availableToBuyFor)) $")
                                        .padding(12)
                                        .foregroundColor(.white)
                                        .font(.headline)
                                        .padding(.horizontal,5)
                                        .background(
                                            Color.mint
                                                .cornerRadius(10)
                                                .shadow(radius: 10))
                                }
                                
                            })
                            
                            Spacer()
                            
                            let procent = crypto.calcPercentage(worthNow: (crypto.availableToBuyFor + sumWorthNow() ) )
                            let procentChange = crypto.turnIntoDecimals(amountOfDecimals: 2, price: procent) // ändrar strängen så det bara blir 2 decimaler.
                            if changeTotalToAvailable == false {
                                Text("\(procentChange) %")
                                    .padding()
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .background(
                                        Color.mint
                                            .cornerRadius(10)
                                            .shadow(radius: 10) )
                            } else {
                                Text("\(procentChange) %")
                                    .padding(12)
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .background(
                                        Color.mint
                                            .cornerRadius(10)
                                            .shadow(radius: 10) )
                            }
                            
                        }
                        .padding(20)
                        if showButton == false {
                            Button(action: {
                                showButton = true
                                crypto.availableToBuyFor = crypto.startMoney
                                UserDefaults.standard.set(crypto.availableToBuyFor, forKey: "DOUBLE_KEY")
                                UserDefaults.standard.set(true, forKey: "BOOL_KEY")
                            }, label: {
                                Text("Start simulation")
                                    .padding(12)
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .background(
                                        Color.mint
                                            .cornerRadius(10)
                                            .shadow(radius: 10) )
                            })
                        }
                        
                        
                        Spacer()
                        Text("My Cryptos")
                            .padding()
                            .foregroundColor(.black)
                            .font(.system(size: 30, weight: .medium, design: .default))
                        List {
                            ForEach(ownedCryptos) { owned in
                                myCryptoRow(myCrypto: owned)
                            }
                        }
                    }
                }
            }
            .tabItem{
                Label("home", systemImage: "house.fill")
            }
            HStack{
                watchListView(crypto: crypto)
            }
            .tabItem{
                Label("watch list", systemImage: "eyeglasses")
            }
            popularDetailView(crypto: crypto)
            
                .tabItem{
                    Label("top crypto", systemImage: "heart")
                }
            HStack{
                searchView(crypto: crypto)
            }
            .tabItem{
                Label("search", systemImage: "magnifyingglass")
            }
        }
    }    
}
