//
//  MarketManager.swift
//  AppBitcoin
//
//  Created by Lucas Bonin on 5/6/16.
//  Copyright © 2016 Lucas Bonin. All rights reserved.
//

import Foundation
import SwiftyJSON

class MarketManager{
    
    //singleton para a classe
    static let sharedInstance = MarketManager()
    
    //private init para que só possa ser acessado atraves do singleton
    private init() {}
    
    func getAllData(completionHandler: [CurrencyData]?->()){
        
        
        BitCoinAverageService().getAllExchanges(){
            response in
            
            var currencies: [CurrencyData] = []
            
            for (currency,subJSON):(String, JSON)in response{
                
                if currency == "timestamp"{
                    continue
                }
                
                guard let newCurrency = CurrencyData(currency, subJSON) else{
                    print("Falha ao parsear currency: \(currency)")
                    completionHandler(nil)
                    return
                }
                
                currencies.append(newCurrency)
            }
            
            completionHandler(currencies)
        }
    }
    
}
