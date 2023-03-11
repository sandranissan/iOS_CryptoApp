//
//  watchListView.swift
//  Final Project
//
//  Created by Hugo Leander on 2021-12-08.
//

import SwiftUI

struct watchListView: View {
    @ObservedObject var crypto: CurrencyModel
    var body: some View {
        NavigationView{
            VStack{
                List{
                    if let lista = crypto.list {
                        ForEach(lista){ c in
                            NavigationLink(destination: cryptoDetailView(crypto: c)){
                                Text(c.name)
                                Spacer()
                                Button(action: {
                                    let cryptoIndex = lista.firstIndex(){
                                        if(c.name == $0.name){
                                            return true
                                        }
                                        return false
                                    }
                                    if let safeIndex = cryptoIndex{
                                        self.crypto.list
                                            .remove(at: safeIndex)
                                        crypto.encode()
                                    }
                                }) {
                                    Image(systemName: "star.fill")
                                }.buttonStyle(.plain)
                                    .foregroundColor(.yellow)
                            }
                        }
                    }
                    else {
                        Text("ingen data")
                    }
                }.navigationTitle("Watch List")
                    .onAppear {
                        crypto.fetch()
                        crypto.decode()
                    }
            }
        }
    }
}


