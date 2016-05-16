//
//  MarketTableViewController.swift
//  BitFreeze
//
//  Created by Lucas Bonin on 5/9/16.
//  Copyright © 2016 Ipsum. All rights reserved.
//

import UIKit

//variavel global para observer
let changeMarketKey = "com.bitfreeze.changeMarketKey"

class MarketTableViewController: UITableViewController {
    
    
    //MARK: Properties
    let cellIdentifier = "MarketTableViewCell"

    var currencyObject: CurrencyData?
    
    var loadedData: (currency: String, market: String) = ("","")
    
    //controle para selecionar somente uma linha da tabela
    var selectedIndexPath: NSIndexPath?
    
    
    //MARK: Lifecycle & Delegations
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = currencyObject?.currency ?? ""
        
        if let data = PersistencyManager().loadCurrentMarket(){
            NSLog("Achou algo guardado\n \(data)")
            loadedData = data
            
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
        
        //verifica se mercado existe na tabela
        if loadedData.currency == currencyObject?.currency{
            if loadedData.market == currencyObject?.exchanges[indexPath.row].marketName{
                selectedIndexPath = indexPath
            }
        }
        
        cell.textLabel?.text = currencyObject?.exchanges[indexPath.row].display_Name ?? "Fail"
        
        if indexPath == selectedIndexPath {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        
        // Não destaca celula quando selecionada
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.textLabel?.textColor = UIColor.whiteColor()
        
        
        
        return cell
        
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath == selectedIndexPath {
            return
        }
        
        // Chama Alerta
        
        if let obj = currencyObject{
            
            showAlert(obj.exchanges[indexPath.row].marketName, index: indexPath){
                response in
                print(response)
                
                if response{
                    print("Entrou")
                    let newCell = tableView.cellForRowAtIndexPath(indexPath)
                    if newCell?.accessoryType == UITableViewCellAccessoryType.None {
                        newCell?.accessoryType = UITableViewCellAccessoryType.Checkmark
                    }
                    
                    
                    if let index = self.selectedIndexPath{
                        let oldCell = tableView.cellForRowAtIndexPath(index)
                        if oldCell?.accessoryType == UITableViewCellAccessoryType.Checkmark {
                            oldCell?.accessoryType = UITableViewCellAccessoryType.None
                        }
                    }
                    
                    self.loadedData.market = obj.exchanges[indexPath.row].marketName
                    self.loadedData.currency = obj.currency
                    
                    PersistencyManager().saveCurrentMarket(self.loadedData.currency, self.loadedData.market)

                    
                    self.selectedIndexPath = indexPath

                    self.notifyMarketChanged([obj.currency, obj.exchanges[indexPath.row].marketName])
                    
                    // Voltar para o menu principal
                    self.navigationController?.popToRootViewControllerAnimated(true)
                    
                }
            }

        }else{
            NSLog("Impossivel armazenar novo mercado")
        }
    }
    
    //MARK: Notification & Alert
    func showAlert(market: String, index: NSIndexPath, completionAlert: (response: Bool)->()){
        
        
        let alert = UIAlertController(title: "Exchange", message: "Change for \(market) ?", preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel){ action in
            completionAlert(response: false)
        }

        let okAction = UIAlertAction(title: "OK", style: .Default){ action in
            completionAlert(response: true)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func notifyMarketChanged(newMarket: [String]){
        NSNotificationCenter.defaultCenter().postNotificationName(changeMarketKey, object: self, userInfo: ["Data":newMarket])
        
        
        //updates market on watch realTime
        
        NSNotificationCenter.defaultCenter().postNotificationName(newMarketCurrency, object: self, userInfo: nil)
    }

    
}
