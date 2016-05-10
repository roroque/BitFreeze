//
//  CurrencyTableViewController.swift
//  AppBitcoin
//
//  Created by Lucas Bonin on 5/6/16.
//  Copyright © 2016 Lucas Bonin. All rights reserved.
//

import UIKit

class CurrencyTableViewController: UITableViewController {
    
    let segueIdentifier = "MarketTableViewControllerSegue"
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
        
        
        // Não destaca celula quando selecionada
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
        
    }
    
    //MARK: Navigation
    
    
    // Quando clicar em uma moeda na table, mandará para a proxima view um objeto do tipo CurrencyData
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueIdentifier
        {
            if let destinationVC = segue.destinationViewController as? MarketTableViewController, tableIndex = tableView.indexPathForSelectedRow?.row{
                
                destinationVC.currencyObject = self.currencies[tableIndex]
                
            }
        }else{
            print("Falha ao reconhecer segue: \(segueIdentifier)")
        }
    }
    
}
