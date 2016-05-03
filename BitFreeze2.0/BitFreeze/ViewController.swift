//
//  ViewController.swift
//  BitFreeze
//
//  Created by Gabriel Neves Ferreira on 03/05/16.
//  Copyright © 2016 Ipsum. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let dataManager = DataStore()
        
        
        let manager = BitCoinAverageService()
        manager.retrieveMarketsData("BRL") { jsonObject in
            
            dataManager.save("marketJson", object: jsonObject.rawValue as! NSObject)

        }
        
        let x =  dataManager.load("marketJson")
        
        let jason = JSON(x!)
        print(jason["mercado"])
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

