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



class InterfaceController: WKInterfaceController {
    
    

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        let dataManager = DataStore()
        
        let x =  dataManager.load("marketJson")
        
        let jason = JSON.parse(x as! String)
        print(jason["mercado"])
        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
