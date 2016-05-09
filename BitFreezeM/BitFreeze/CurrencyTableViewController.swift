//
//  CurrencyTableViewController.swift
//  AppBitcoin
//
//  Created by Lucas Bonin on 5/6/16.
//  Copyright © 2016 Lucas Bonin. All rights reserved.
//

import UIKit

class CurrencyTableViewController: UITableViewController {
    
    let cellIdentifier = "CurrencyTableViewCell"
    private var currencies: [CurrencyData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MarketManager.sharedInstance.getAllData(){
            response in
            
            if let resp = response as [CurrencyData]!{
                self.currencies = resp
                self.tableView.reloadData()
            }
            
        }
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        cell.textLabel?.text = currencies[indexPath.row].currency
        
        return cell
        
    }
    
}
