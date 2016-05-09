//
//  MarketData.swift
//  AppBitcoin
//
//  Created by Lucas Bonin on 5/6/16.
//  Copyright © 2016 Lucas Bonin. All rights reserved.
//

import Foundation
import SwiftyJSON

class MarketData: NSObject{
    var display_URL: String
    var display_Name: String
    var ask: String
    var bid: String
    var last: String
    var volume_btc: String
    var volume_percent: String
    
    init?(_ jsonMarket: JSON){
        
        guard let display_URL = jsonMarket["display_URL"].string else {
            print(jsonMarket["display_URL"].error)
            return nil
        }
        
        guard let display_Name = jsonMarket["display_name"].string else {
            print(jsonMarket["display_name"].error)
            return nil
            
        }
        
        
        guard let ask = jsonMarket["rates"]["ask"].number else {
            print(jsonMarket["rates"]["ask"].error)
            return nil
            
        }
        
        guard let bid = jsonMarket["rates"]["bid"].number else {
            print(jsonMarket["rates"]["last"].error)
            return nil
            
        }
        
        guard let last = jsonMarket["rates"]["last"].number else {
            print(jsonMarket["rates"]["last"].error)
            return nil
            
        }
        
        guard let volume_btc = jsonMarket["volume_btc"].number else {
            print(jsonMarket["volume_btc"].error)
            return nil
            
        }
        
        guard let volume_percent = jsonMarket["volume_percent"].number else {
            print(jsonMarket["volume_percent"].error)
            return nil
            
        }
        
        self.display_URL = display_URL
        self.display_Name = display_Name
        self.ask = ask.stringValue
        self.bid = bid.stringValue
        self.last = last.stringValue
        self.volume_btc = volume_btc.stringValue
        self.volume_percent = volume_percent.stringValue
        
    }
}