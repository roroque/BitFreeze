//
//  CurrencyData.swift
//  AppBitcoin
//
//  Created by Lucas Bonin on 5/6/16.
//  Copyright © 2016 Lucas Bonin. All rights reserved.
//

import Foundation
import SwiftyJSON
class CurrencyData: NSObject{
    var currency: String
    var exchanges: [MarketData] = []
    
    init?(_ currency: String, _ currencyJSON: JSON){
        
        self.currency = currency
        
        for (exchange,subJSON):(String, JSON)in currencyJSON{
            
            if exchange == "timestamp"{
                continue
            }
            
            guard let newExchange = MarketData(exchange,subJSON) else{
                print("Falha ao parsear exchange: \(exchange)")
                return nil
            }
            
            self.exchanges.append(newExchange)
        }
        
    }
    
}
