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
    
     private let rootApiUrl = "https://api.bitcoinaverage.com/exchanges/all"
    
    
    private let CURRENCY_URL = "https://api.bitcoinaverage.com/exchanges/"
    private let ALL_EXCHANGES = "https://api.bitcoinaverage.com/exchanges/all"
    
    func getCurrency(currency: String, completionHandler: (JSON) -> ()){
        urlRequest(CURRENCY_URL + currency, completionHandler)
    }
    
    func getAllExchanges(completionHandler: (JSON) -> ()){
        urlRequest(ALL_EXCHANGES, completionHandler)
    }
    
    private func urlRequest(url: String, _ completionHandler: (JSON)->()){
        Alamofire.request(.GET, url).responseJSON{
            response in
            
            switch response.result{
            case .Success(let value):
                completionHandler(JSON(value))
                
            case .Failure(let error):
                print ("Erro ao fazer requisicao para o servidor:\n\n" + error.description)
            }
        }
        
    }

    
    
    //BRL
    
    func retrieveMarketsData(jsonHandler : (JSON) -> () ){
        
        Alamofire.request(.GET,(rootApiUrl)).responseJSON { response in
            
            if let data = response.data{
                
                let jsonObject = JSON(data: data)
                jsonHandler(jsonObject)
                return
                
                
            }
            
        }
        
        
}
    
    
    
    
}