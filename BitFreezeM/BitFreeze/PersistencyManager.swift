//
//  PersistencyManager.swift
//  BitFreeze
//
//  Created by Lucas Bonin on 5/9/16.
//  Copyright © 2016 Ipsum. All rights reserved.
//

import UIKit

class PersistencyManager: NSObject {
    
    private let currencyKey = "CURRENCY_DATA"
    private let marketKey = "MARKET_DATA"
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    func saveCurrentMarket(currency: String, _ market: String){
        
        defaults.setValue(currency, forKey: currencyKey)
        defaults.setValue(market, forKey: marketKey)
        defaults.synchronize()
    }
    
    func loadCurrentMarket()->(currency: String, market: String)?{
        
        guard let cr = defaults.valueForKey(currencyKey) as? String else {
            print("Erro ao carregar currency")
            return nil
        }
        
        guard let mk = defaults.valueForKey(marketKey) as? String else {
            print("Erro ao carregar market")
            return nil
        }
        
        return (cr, mk)
    }

}
