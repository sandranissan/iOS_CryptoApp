//
//  CurrencyModel.swift
//  Final Project
//
//  Created by Sandra Nissan on 2021-12-01.
//

import Foundation
import Combine
import SwiftUI

class CurrencyModel : ObservableObject {
    private var cancellableTask: AnyCancellable?
    @Published var currencySet : CurrencySet?
    @Published var isLoading = false
    @Published var list = [Currency]()
    @Published var owndCryptoList = [MyCryptos]()
    @Published var availableToBuyFor: Double = UserDefaults.standard.double(forKey: "DOUBLE_KEY")
    @Published var startMoney = Double(200000)
    
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [])
    private var ownedCryptos: FetchedResults<OwnedCrypto>
    
    func calcPercentage(worthNow: Double) -> Double {
        let totalChange = worthNow / self.startMoney
        let percentage = (totalChange - 1) * 100
        return percentage
    }
    
    @AppStorage("user_persistent", store: .standard) var storedFavRest: Data = Data ()
    
    func decode(){
        do{
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode([Currency].self, from: storedFavRest)
            
            self.list = decodedResponse
        }
        catch {
            print(error)
        }
    }
    
    func encode() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(self.list)
            storedFavRest = data
        }
        catch {
            print(error)
        }
    }
    
    func turnIntoDecimals(amountOfDecimals: Int, price: Double) -> String {
        let newString = String(format: "%.\(amountOfDecimals)f", price)
        return newString
    }
    
    func fetch(){
        if let url = URL(string: "https://api.coinstats.app/public/v1/coins?skip=0&limit=10"){
            isLoading = true
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            cancellableTask = URLSession.shared
            
                .dataTaskPublisher(for: url)
                .tryMap { element -> Data in
                    guard let httpResponse = element.response as? HTTPURLResponse, httpResponse.statusCode == 200
                    else {
                        throw URLError(.badServerResponse)
                    }
                    return element.data
                    
                }
                .decode(type: CurrencySet.self , decoder: jsonDecoder)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [weak self] error in
                    print(error)
                    self?.isLoading = false
                }, receiveValue: { [weak self] data in
                    print(data)
                    self?.currencySet = data
                })
        }
    }
}

