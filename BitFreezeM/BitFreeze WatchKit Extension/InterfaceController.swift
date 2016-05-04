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
    
        let x = applicationContext["test"] as? String
        
        let jason = JSON.parse(x!)
        
        
        
        
        
       
        updateInterface(jason)
        
        
    }
    
    
    func updateInterface(exchangeData : JSON){
        
        //variavel a ser carregada das preferencias sobre qual mercado esta sendo olhado ex:foxbit
        let nomeMercado = "mercado"
        let askPartial = exchangeData[nomeMercado]["rates"]["ask"].stringValue
        let bidPartial = exchangeData[nomeMercado]["rates"]["bid"].stringValue
        let pricePartial = exchangeData[nomeMercado]["rates"]["last"].stringValue
        
        
        ask.setText(askPartial)
        bid.setText(bidPartial)
        price.setText(pricePartial)

        
        
    }
    
    
    
}
