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
    
    //controle para selecionar somente uma linha da tabela
    var selectedIndexPath: NSIndexPath? = NSIndexPath(forRow: 0, inSection: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = PersistencyManager().loadCurrentMarket(){
            
            NSLog("Achou algo guardado\n \(data)")
            
        }else{
            
            NSLog("Nao ha nada guardado, guardar mercado default")
        }
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //retorna numero de exchanges se existir, caso contrario retorna 0
        return currencyObject?.exchanges.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        cell.textLabel?.text = currencyObject?.exchanges[indexPath.row].display_Name ?? "Fail"
        
        if indexPath == selectedIndexPath {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        
        // Não destaca celula quando selecionada
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
        
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath == selectedIndexPath {
            return
        }
        
        let newCell = tableView.cellForRowAtIndexPath(indexPath)
        if newCell?.accessoryType == UITableViewCellAccessoryType.None {
            newCell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        
        let oldCell = tableView.cellForRowAtIndexPath(selectedIndexPath!)
        if oldCell?.accessoryType == UITableViewCellAccessoryType.Checkmark {
            oldCell?.accessoryType = UITableViewCellAccessoryType.None
        }
        
        selectedIndexPath = indexPath
        
        // Salva nova configuração
        
        if let obj = currencyObject{
            PersistencyManager().saveCurrentMarket(obj.currency, obj.exchanges[indexPath.row].marketName)
        }else{
            NSLog("Impossivel armazenar novo mercado")
        }
        
        
    }

    
}
