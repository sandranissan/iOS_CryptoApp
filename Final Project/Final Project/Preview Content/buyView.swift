//
//  buyView.swift
//  Final Project
//
//  Created by Hugo Leander on 2021-12-07.
//

import SwiftUI

struct buyView: View {
    @State var amount: String = ""
    @EnvironmentObject var cryptoFunctions: CurrencyModel
    @Environment(\.managedObjectContext) var viewContext
    let crypto: Currency
    @State private var showMessage = false
    @State private var succesfullPurchase = false
    
    func addToOwned(name: String, amountBought: Double, boughtPrice: Double, worthNowPrice: Double) {
        let newOwned = OwnedCrypto(context: viewContext)
        newOwned.id = UUID().uuidString
        newOwned.name = name
        newOwned.amountBought = amountBought
        newOwned.boughtPrice = boughtPrice
        newOwned.worthNowPrice = worthNowPrice * amountBought
        
        try? viewContext.save()
    }
    
    var calculation : Double { // skapar en funktion som returnerar en double
        guard let amountOfShares = Double(amount) // tar input från amount och gör den till en double som heter amountOfShares
        else {return 0} // annars returnera 0. alltså om man ej skrivit något eller skriver något annat än ett tal. tex "abc"
        return amountOfShares * crypto.price
    }
    
    var calcNewTotal : Double {
        guard let amountOfMoney = Double(amount)
        else { return 0}
        return cryptoFunctions.availableToBuyFor - (amountOfMoney * crypto.price) // returnerar den nya totalSumman
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Buy \(crypto.name)")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                Text("Available to buy for")
                    .padding(5)
                    .font(.title3)
                let totalNoDecimals = String(format: "%.0f", cryptoFunctions.availableToBuyFor)
                Text("\(totalNoDecimals) $")
                    .padding(5)
                    .padding(.horizontal,50)
                    .background(Color.mint
                                    .cornerRadius(10))
                    .padding(.bottom, 80)
                Text("Current price")
                    .padding(5)
                    .font(.title3)
                let priceWith2Decimals = String(format: "%.2f", crypto.price)
                Text("\(priceWith2Decimals) $")
                    .padding(5)
                    .padding(.horizontal,50)
                    .background(Color.mint
                                    .cornerRadius(10))
                Text("Amount of shares")
                    .padding(5)
                    .font(.title3)
                    .padding(.top, 10)
                ZStack {
                    Rectangle()
                        .foregroundColor(Color.mint)
                        .frame(height: 40)
                        .cornerRadius(10)
                        .padding(.horizontal,100)
                    TextField("Enter amount...", text: $amount)
                        .multilineTextAlignment(.center)
                        .keyboardType(.decimalPad)
                }.padding(13)
                
                Text("Total buy price")
                    .padding(5)
                    .font(.title3)
                    .padding(.top, 10)
                let calcWith2Decimals = String(format: "%.2f", calculation)
                Text("\(calcWith2Decimals) $")
                    .padding(10)
                    .padding(.horizontal,50)
                    .background(Color.mint
                                    .cornerRadius(10))
            }
            Button(action:{
                if ( calculation  > cryptoFunctions.availableToBuyFor || calculation == 0){
                    showMessage = true
                } else {
                    succesfullPurchase = true

                    let newTotal = calcNewTotal // ger det nya totalvardet till newTotal
                    cryptoFunctions.availableToBuyFor = newTotal // tilldelar sen totalPengarna det nya totalVärdet
                    UserDefaults.standard.set(cryptoFunctions.availableToBuyFor, forKey: "DOUBLE_KEY")
                    
                    if let boughtAmount = Double(amount) {
                        let boughtPrice = crypto.price
                        addToOwned(name: crypto.name, amountBought: boughtAmount, boughtPrice: boughtPrice, worthNowPrice: crypto.price)
                    }
                }
            }, label: {
                Text("Place order")
            })
                .alert("Not enough money, Please try again! ", isPresented: $showMessage){
                    Button("Ok", role: .cancel) {}
                    
                }
                .alert("Successful purchase" , isPresented:  $succesfullPurchase) {
                    Button("Great", role: .cancel)  {}
                }
                .padding()
                .foregroundColor(.white)
                .font(.headline)
                .padding(.horizontal,20)
                .background(
                    Color.blue
                        .cornerRadius(10)
                        .shadow(radius: 10)
                )
        }
    }
}

