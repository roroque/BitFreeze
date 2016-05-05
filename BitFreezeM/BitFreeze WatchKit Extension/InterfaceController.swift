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



class InterfaceController: WKInterfaceController,WCSessionDelegate {
    
    


    @IBOutlet var ask: WKInterfaceLabel!

    @IBOutlet var bid: WKInterfaceLabel!

    @IBOutlet var price: WKInterfaceLabel!
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        //Swift
        if (WCSession.isSupported()) {
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
            
        }
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func session(session: WCSession,didReceiveApplicationContext applicationContext: [String : AnyObject]){

       
        updateInterface(applicationContext)
        
        
    }
    
    
    func updateInterface( dataDict :[String : AnyObject]){
        
        let askPartial = dataDict["ask"] as! String
        let bidPartial = dataDict["bid"] as! String
        let pricePartial = dataDict["price"] as! String
        let marketPartial = dataDict["market"] as! String
        let currencyPartial = dataDict["currency"] as! String
        
        
        ask.setText(askPartial)
        bid.setText(bidPartial)
        price.setText(pricePartial)

        
        
    }
    
    
    
}
