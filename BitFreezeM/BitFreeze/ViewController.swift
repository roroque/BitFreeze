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

class ViewController: UIViewController,WCSessionDelegate {
    
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

        
    
     
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    @IBAction func buttonPressed(sender: AnyObject) {
        
       // sendData()
        
    }
    
    
    func sendData(reply : (([String : AnyObject]) -> Void)){
        
        let manager = BitCoinAverageService()
        manager.retrieveMarketsData { jsonObject in
            var market = self.dataManager.load("market") as? String
            
            if (market == nil){
                
                market = "mercado"
            }
            
            var currency = self.dataManager.load("currency") as? String
            
            if (currency == nil){
                
                currency = "BRL"
            }
            
            
            let askPartial = jsonObject[currency!][market!]["rates"]["ask"].stringValue
            let bidPartial = jsonObject[currency!][market!]["rates"]["bid"].stringValue
            let pricePartial = jsonObject[currency!][market!]["rates"]["last"].stringValue
            let applicationDict = ["ask" : askPartial,"bid" : bidPartial, "price" : pricePartial,"market" : market!, "currency" : currency!]
            reply(applicationDict)
            /*
            do {
                try WCSession.defaultSession().updateApplicationContext(applicationDict)
            } catch {
                // Handle errors here
            }
            */
            
        
            
        }
        
    }
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func session(session: WCSession,didReceiveMessage message: [String : AnyObject],replyHandler: ([String : AnyObject]) -> Void){
        
        sendData(replyHandler)
        
        
    }
   
    
    




}

