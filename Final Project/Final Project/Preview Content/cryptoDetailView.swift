//
//  cryptoDetailView.swift
//  Final Project
//
//  Created by Hugo Leander on 2021-12-06.
//

import SwiftUI

struct cryptoDetailView: View {
    let crypto: Currency
    @EnvironmentObject var cryptoFunctions : CurrencyModel
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text(crypto.name)
                        .font(.title)
                        .fontWeight(.bold)
                    AsyncImage(url: URL(string: crypto.icon)) { image in // denna laddar in bilden när man startar previewen.
                        image
                            .aspectRatio(contentMode: .fit)
                    }placeholder: {
                        Text(crypto.symbol)
                    }
                }
                Text("Crypto Rank: \(crypto.rank)")
                    .font(.title2)
                    .padding()
                HStack {
                    Text("Current Price: $\(cryptoFunctions.turnIntoDecimals(amountOfDecimals: 4, price: crypto.price))")
                        .font(.title3)
                        .padding(3)
                    Text("Price in Bitcoins: \(crypto.priceBtc) BTC")
                        .font(.title3)
                        .padding(3)
                }
                
                Text("Price change for different times:")
                    .font(.title3)
                HStack {
                    let price1h = String(format: "%.2f", crypto.priceChange1h)
                    let price1d = String(format: "%.2f", crypto.priceChange1d)
                    let price1w = String(format: "%.2f", crypto.priceChange1w)
                    
                    
                    if price1h.prefix(1) == "-" {
                        Text("1H: \(cryptoFunctions.turnIntoDecimals(amountOfDecimals: 2, price: crypto.priceChange1h))%")
                            .foregroundColor(.red)
                    } else {
                        Text("1H: \(cryptoFunctions.turnIntoDecimals(amountOfDecimals: 2, price: crypto.priceChange1h))%")
                            .foregroundColor(.green)
                    }
                    if price1d.prefix(1) == "-" {
                        Text("1D: \(cryptoFunctions.turnIntoDecimals(amountOfDecimals: 2, price: crypto.priceChange1d))%")
                            .foregroundColor(.red)
                    } else {
                        Text("1D: \(cryptoFunctions.turnIntoDecimals(amountOfDecimals: 2, price: crypto.priceChange1d))%")
                            .foregroundColor(.green)
                    }
                    if price1w.prefix(1) == "-" {
                        Text("1W: \(cryptoFunctions.turnIntoDecimals(amountOfDecimals: 2, price: crypto.priceChange1w))%")
                            .foregroundColor(.red)
                    } else {
                        Text("1W: \(cryptoFunctions.turnIntoDecimals(amountOfDecimals: 2, price: crypto.priceChange1w))%")
                            .foregroundColor(.green)
                    }
                }
                .font(.title3)
                Spacer()
                HStack {
                    NavigationLink(destination: buyView(crypto: crypto)) {
                        Text("BUY")
                            .padding()
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding(.horizontal,30)
                            .background(
                                Color.blue
                                    .cornerRadius(10)
                                    .shadow(radius: 10)
                            )
                    }
                }
            }
        }
    }
}

struct cryptoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        cryptoDetailView(crypto: Currency(id: "ethereum", icon: "https://static.coinstats.app/coins/EthereumOCjgD.png", name: "Ethereum", symbol: "ETH", rank: 2, price: 4025.1079331626697, priceBtc: 0.08364918979276868, volume: 37750027648.53152, marketCap: 477495213770.61633, availableSupply: 118629170.124, totalSupply: 0, priceChange1h: -1.11, priceChange1d: -4.59, priceChange1w: -6.62, websiteUrl: "https://www.ethereum.org/", redditUrl: "https://www.google.com/?client=safari", twitterUrl: "https://twitter.com/ethereum", contractAddress: "0x2170ed0880ac9a755fd29b2688956bd959f933f8", decimals: 18, exp: ["https://etherscan.io/","https://ethplorer.io/","https://blockchair.com/ethereum","https://eth.tokenview.com/","https://hecoinfo.com/token/0x64ff637fb478863b7468bc97d30a5bf3a428a1fd","https://bscscan.com/token/0x2170ed0880ac9a755fd29b2688956bd959f933f8","https://snowtrace.io/token/0xf20d962a6c8f70c731bd838a3a388d7d48fa6e15"]))
    }
}
