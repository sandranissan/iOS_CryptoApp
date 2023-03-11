//
//  myCryptoRow.swift
//  Final Project
//
//  Created by Hugo Leander on 2021-12-14.
//

import SwiftUI
import CoreData
struct myCryptoRow: View {
    @EnvironmentObject var crypto: CurrencyModel
    let myCrypto: OwnedCrypto
    @State private var showAlert = false
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [])
    private var ownedCryptos: FetchedResults<OwnedCrypto>
    
    var body: some View {
        Button(action: {
            showAlert = true
        }, label: {
            VStack (alignment: .leading) {
                Text(myCrypto.name ?? "Untitled")
                    .font(.title2)
                HStack {
                    VStack {
                        Text("Amount")
                        let amountWith0Decimals = String(format: "%.0f", myCrypto.amountBought)
                        Text(amountWith0Decimals)
                    }
                    Spacer()
                    VStack {
                        Text("Average price: ")
                        let amountWith2Decimals = String(format: "%.2f", myCrypto.boughtPrice)
                        Text("\(amountWith2Decimals) $")
                    }
                    Spacer()
                    VStack {
                        Text("Total worth")
                        let totalWorth = String(format: "%.2f", myCrypto.worthNowPrice)
                        Text("\(totalWorth) $")
                    }
                }
            }
        })
            .alert("Are you sure you want to sell \(myCrypto.name ?? "Hej")?", isPresented: $showAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Yes") {
                    crypto.availableToBuyFor = crypto.availableToBuyFor + myCrypto.worthNowPrice
                    UserDefaults.standard.set(crypto.availableToBuyFor, forKey: "DOUBLE_KEY")
                    viewContext.delete(myCrypto)
                    try? viewContext.save()
                }
            }
            .foregroundColor(.black)
    }
}
