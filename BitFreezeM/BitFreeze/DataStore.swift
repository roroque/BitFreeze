//
//  DataStore.swift
//  BitFreeze
//
//  Created by Gabriel Neves Ferreira on 03/05/16.
//  Copyright © 2016 Ipsum. All rights reserved.
//

import Foundation
import SwiftyJSON




class DataStore {
    
    let userDefaults = NSUserDefaults(suiteName: "group.ipsumcorp.bit.freeze")!

    
    func save(key : String,object : NSObject){

        
        userDefaults.setValue(object, forKey: key)
    
        
        userDefaults.synchronize()
        
    }
    
    func load(key : String) -> NSObject?  {

        let object : AnyObject? = userDefaults.valueForKey(key)
        
        return object as? NSObject
   
        
    }
    
    
    
    
    
    
}