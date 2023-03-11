//
//  Currency.swift
//  Final Project
//
//  Created by Sandra Nissan on 2021-12-01.
//

import Foundation

struct Currency : Decodable, Identifiable , Equatable, Hashable, Encodable {
    let id : String
    let icon : String
    let name : String
    let symbol : String
    let rank : Int
    let price : Double
    let priceBtc: Double
    let volume : Double
    let marketCap: Double
    let availableSupply : Double
    let totalSupply : Double
    let priceChange1h : Double
    let priceChange1d : Double
    let priceChange1w : Double
    let websiteUrl : String
    let redditUrl : String? 
    let twitterUrl : String?
    let contractAddress : String?
    let decimals : Int?
    let exp : [String]
    
}




