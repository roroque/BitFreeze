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
    
    let userDefaults = NSUserDefaults.standardUserDefaults()


    
    func save(key : String,object : NSObject){

        
        userDefaults.setValue(object, forKey: key)
    
        
        userDefaults.synchronize()
        
    }
    
    func load(key : String) -> NSObject?  {

        let object : AnyObject? = userDefaults.valueForKey(key)
        
        return object as? NSObject
   
        
    }
    
    
    func loadData ()-> [[String : NSObject]]? {
        
        let vector = load("data") as? [[String : NSObject]]
        
        return vector
        
        
    }
    
    func saveDifferentData(newData :[String : NSObject]){
        print("save")
    
        var vector : [[String : NSObject]]
     
        if let auxiliar = load("data") {
            vector = auxiliar as! [[String : NSObject]]
            
        }else{
            vector = []
            
        }
        
        
        
        //check if there is data
        if let lastSaved = vector.last{
            //checks if this json is correspondent to last one that was saved, to avoid duplicates
            //checks if data is different else just ignore this json
           // print(vector)
            //print(newData)
           
            
            if lastSaved["ask"] != newData["ask"] || lastSaved["bid"] != newData["bid"] || lastSaved["price"] != newData["price"] || lastSaved["market"] != newData["market"] || lastSaved["currency"] != newData["currency"]{
                
                //different data, appends to vector and checks if there are already 100 data saved
                vector.append(newData)
                print("new data")
                
                if vector.count > 99 {
                    print("removing one data")
                    
                    vector.removeFirst()
                }
                
                save("data", object: vector)
                
            
            }else{
                print("repeated data")
                
            }
            
            
        }else{
            //if there is no data, save json
            print("no json")
            vector.append(newData)
            save("data", object: vector)
            
            
        }
        
    }
    
    
    
    
    
    
}