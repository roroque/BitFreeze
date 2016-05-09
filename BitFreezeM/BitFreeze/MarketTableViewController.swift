//
//  MarketTableViewController.swift
//  BitFreeze
//
//  Created by Lucas Bonin on 5/9/16.
//  Copyright © 2016 Ipsum. All rights reserved.
//

import UIKit

class MarketTableViewController: UITableViewController {
    
    let cellIdentifier = "MarketTableViewCell"

    var currencyObject: CurrencyData?
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //retorna numero de exchanges se existir, caso contrario retorna 0
        return currencyObject?.exchanges.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        cell.textLabel?.text = currencyObject?.exchanges[indexPath.row].display_Name ?? "Fail"
        
        return cell
        
    }
    
}
