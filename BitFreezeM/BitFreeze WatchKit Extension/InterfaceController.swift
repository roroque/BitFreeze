//
//  InterfaceController.swift
//  BitFreeze WatchKit Extension
//
//  Created by Gabriel Neves Ferreira on 03/05/16.
//  Copyright © 2016 Ipsum. All rights reserved.
//

import WatchKit
import Foundation
import SwiftyJSON
import WatchConnectivity
import Alamofire
import ClockKit




class InterfaceController: WKInterfaceController,WCSessionDelegate {
    
    let session = WCSession.defaultSession()
    let dataManager = DataStore()



    @IBOutlet var ask: WKInterfaceLabel!

    @IBOutlet var bid: WKInterfaceLabel!

    @IBOutlet var price: WKInterfaceLabel!
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        //Swift
        if (WCSession.isSupported()) {
           
            session.delegate = self
            session.activateSession()
            
        }
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        loadInterface()
        
        
        
        if session.reachable {

            session.sendMessage(["request": "watch"], replyHandler: { dict in
                
                
                    self.updateInterface(dict)
                
                }) { error in
                    print(error)
                    print("error activation")
            }
        }else{
            
            print("device not reacheable")
        }
        
        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    /*
    func session(session: WCSession,didReceiveApplicationContext applicationContext: [String : AnyObject]){

       
        updateInterface(applicationContext)
        
        
        
        
    }
    
    */
    func loadInterface(){
//        print ("voltando")
//        
//        let askPartial = dataManager.load("ask") as! String
//        let bidPartial = dataManager.load("bid") as! String
//        let pricePartial = dataManager.load("price") as! String
//        let marketPartial = dataManager.load("market") as! String
//        let currencyPartial = dataManager.load("currency") as! String
//        
//        
//        ask.setText(askPartial)
//        bid.setText(bidPartial)
//        price.setText(pricePartial)
        
    }
    
    
    func updateInterface( dataVector :[String : AnyObject]){
        
        print("update interfaco")
        
        
        let vector = dataVector["data"] as! [[String : NSObject]]
        let dataDict = vector.last!
        
        let askPartial = dataDict["ask"] as! String
        let bidPartial = dataDict["bid"] as! String
        let pricePartial = dataDict["price"] as! String
        let marketPartial = dataDict["market"] as! String
        let currencyPartial = dataDict["currency"] as! String
        
        
        dataManager.save("ask", object: askPartial)
        dataManager.save("bid", object: bidPartial)
        dataManager.save("price", object: pricePartial)
        dataManager.save("market", object: marketPartial)
        dataManager.save("currency", object: currencyPartial)

        print (askPartial)
        
        ask.setText(askPartial)
        bid.setText(bidPartial)
        price.setText(pricePartial)
        
     
        dataManager.save("data", object: vector)
        
       
        let server=CLKComplicationServer.sharedInstance()
        
        for comp in (server.activeComplications)! {
            server.reloadTimelineForComplication(comp)
        }
        
        
    }
    
  
    
    func session(session: WCSession,didReceiveMessage message: [String : AnyObject],replyHandler: ([String : AnyObject]) -> Void){
        
        updateInterface(message)
        replyHandler(["hey": "ho"])
        
        
    }
    
    
    
    
    
    
    
    
    
}
