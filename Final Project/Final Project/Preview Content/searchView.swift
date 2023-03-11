//
//  searchView.swift
//  Final Project
//
//  Created by Hugo Leander on 2021-12-07.
//

import SwiftUI

struct searchView: View {
    @ObservedObject var crypto : CurrencyModel
    @State var searchText = ""
    @State var searching = false
    
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                ZStack {
                    Rectangle()
                        .foregroundColor(Color(.systemGray5))
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("Search..", text: $searchText) { startedEditing in
                            if startedEditing {
                                withAnimation {
                                    searching = true
                                }
                            }
                        } onCommit: {
                            withAnimation {
                                searching = false
                            }
                        }
                    }
                    .foregroundColor(.black)
                    .padding(.leading, 13)
                    
                }
                .frame(height: 40)
                .cornerRadius(10)
                .padding()
                List {
                    if let allCoins = crypto.currencySet {
                        ForEach((allCoins.coins).filter({"\($0)".contains(searchText) || searchText == ""}), id:\.self) { coin in
                            HStack {
                                NavigationLink(destination: cryptoDetailView(crypto: coin)) {
                                    Text(coin.name)
                                }
                            }
                        }
                    }
                }
                .onAppear(perform: crypto.fetch)
                .listStyle(GroupedListStyle())
                .navigationTitle(searching ? "Searching" : "All Cryptos")
                .toolbar {
                    if searching {
                        Button("Cancel") {
                            searchText = ""
                            withAnimation {
                                searching = false
                            }
                        }
                    }
                }
            }
        }
    }
}

