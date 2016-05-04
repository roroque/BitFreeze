//
//  BitCoinAverageService.swift
//  BitFreeze
//
//  Created by Gabriel Neves Ferreira on 03/05/16.
//  Copyright © 2016 Ipsum Corp. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class BitCoinAverageService {
    
     private let rootApiUrl = "https://api.bitcoinaverage.com/exchanges/"
    
    
    //BRL
    
    func retrieveMarketsData(currency : String, jsonHandler : (JSON) -> () ){
        
        Alamofire.request(.GET,(rootApiUrl + currency)).responseJSON { response in
            
            if let data = response.data{
                
                let jsonObject = JSON(data: data)
                jsonHandler(jsonObject)
                return
                
                
            }
            
        }
        
        
}
    
    
    
    
}