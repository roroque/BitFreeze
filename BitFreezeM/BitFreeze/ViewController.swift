//
//  ViewController.swift
//  BitFreeze
//
//  Created by Gabriel Neves Ferreira on 03/05/16.
//  Copyright © 2016 Ipsum. All rights reserved.
//

import UIKit
import SwiftyJSON
import WatchConnectivity


let newDataFromBackgroundKey = "data.Background"

let newMarketCurrency = "newMarketCurrency"


class ViewController: UINavigationController,WCSessionDelegate {
    
    
    let session = WCSession.defaultSession()
    let dataManager = DataStore()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()

    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()

    }
    
    func commonInit() {
        
        // Initialize the `WCSession` and the `CLLocationManager`.
     
        session.delegate = self
        session.activateSession()
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.observerHandler(_:)), name: newMarketCurrency, object: nil)

        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    
    func backGroundSend(){
       
        var data = (currency : "BRL", market : "mercado")
        
        let manager = BitCoinAverageService()
        manager.retrieveMarketsData { jsonObject in
            
            if let aux = PersistencyManager().loadCurrentMarket(){
             
                data = aux
                
            }
            let askPartial = jsonObject[data.currency][data.market]["rates"]["ask"].stringValue
            let bidPartial = jsonObject[data.currency][data.market]["rates"]["bid"].stringValue
            let pricePartial = jsonObject[data.currency][data.market]["rates"]["last"].stringValue
            let applicationDict = ["ask" : askPartial,"bid" : bidPartial, "price" : pricePartial,"market" : data.market, "currency" : data.currency, "date" : NSDate()]
            self.notifyMarketChanged(jsonObject[data.currency][data.market])

            
            
            self.dataManager.saveDifferentData(applicationDict)
            
           
            if self.session.reachable{
                self.session.sendMessage([ "data" :  self.dataManager.loadData()!], replyHandler: { dict in

                    
                    print(dict)
                    
                }) { error in
                    print(error)
                    print("error background")
                }
                
            }
            
            
        }

        
        
   
        
    }
    
    
    
    func sendData(reply : (([String : AnyObject]) -> Void)){
        
        var data = (currency : "BRL", market : "mercado")
        
        let manager = BitCoinAverageService()
        manager.retrieveMarketsData { jsonObject in
            
            if let aux = PersistencyManager().loadCurrentMarket(){
                
                data = aux
                
            }
            let askPartial = jsonObject[data.currency][data.market]["rates"]["ask"].stringValue
            print(jsonObject)
            let bidPartial = jsonObject[data.currency][data.market]["rates"]["bid"].stringValue
            let pricePartial = jsonObject[data.currency][data.market]["rates"]["last"].stringValue
            let marketName = jsonObject[data.currency][data.market]["display_name"].stringValue
            let applicationDict = ["ask" : askPartial,"bid" : bidPartial, "price" : pricePartial,"market" : marketName, "currency" : data.currency, "date" : NSDate()]
            self.notifyMarketChanged(jsonObject[data.currency][data.market])
            
            
            
            self.dataManager.saveDifferentData(applicationDict)
            self.dataManager.saveDifferentData(applicationDict)
            
            reply([ "data" :  self.dataManager.loadData()!])
        
            
            
        }
        
    }
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func session(session: WCSession,didReceiveMessage message: [String : AnyObject],replyHandler: ([String : AnyObject]) -> Void){
      
        print(message)
        sendData(replyHandler)

        
        
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    
    func notifyMarketChanged(marketDataJSON:JSON){
                
        NSNotificationCenter.defaultCenter().postNotificationName(newDataFromBackgroundKey, object: self, userInfo: ["newBackgroundData":marketDataJSON.rawValue])
    }
    
    func observerHandler(notification: NSNotification){
       
        self.backGroundSend()
        
        
    }
    
    
    
   
}

