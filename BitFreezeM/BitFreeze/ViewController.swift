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

        let manager = BitCoinAverageService()
        manager.retrieveMarketsData("BRL") { jsonObject in
            
            self.dataManager.save("marketJson", object: jsonObject.rawString() as! NSObject)

        }
        
     
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    @IBAction func buttonPressed(sender: AnyObject) {
        
        let y =  dataManager.load("marketJson")

        
        do {
            let applicationDict = [ "test" : y as! String] // Create a dict of application data
            try WCSession.defaultSession().updateApplicationContext(applicationDict)
        } catch {
            // Handle errors here
        }
        
        
        
    }
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }




}

