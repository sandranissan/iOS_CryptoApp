//
//  popularDetailView.swift
//  Final Project
//
//  Created by Hugo Leander on 2021-12-06.
//

import SwiftUI

struct popularDetailView: View {
    @ObservedObject var crypto : CurrencyModel
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    if let popular = crypto.currencySet {
                        ForEach(popular.coins) { coin in
                            HStack {
                                NavigationLink(destination: cryptoDetailView(crypto: coin)) {
                                    HStack {
                                        Text(coin.name)
                                        Spacer()
                                        Button(action: {
                                            let cryptoIndex = popular.coins.firstIndex(){
                                                if(coin.name == $0.name){
                                                    return true
                                                }
                                                return false
                                            }
                                            if let safeIndex = cryptoIndex{
                                                let resault = crypto.list.filter{$0 == coin}
                                                if resault.isEmpty{
                                                    self.crypto.list
                                                        .append(coin)
                                                    print(String(crypto.list.count))
                                                }
                                            }
                                            crypto.encode()
                                        }) {
                                            Image(systemName: crypto.list.filter{$0 == coin}.isEmpty ? "star" : "star.fill" )
                                        }
                                        .foregroundColor(crypto.list.filter{$0 == coin}.isEmpty ? .black : .yellow) // svart om det ej är favorit, gul om det är favorit.
                                        .buttonStyle(.plain)
                                    }
                                    
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Top Crypto")
                .onAppear{
                    crypto.fetch()
                    crypto.decode()
                }
            }
        }
    }
}

struct popularDetailView_Previews: PreviewProvider {
    static var previews: some View {
        popularDetailView(crypto: CurrencyModel())
    }
}


