
import UIKit
import SwiftyJSON

class ShowMarketViewController: UIViewController {
    
    @IBOutlet weak var bidLabel: UILabel!
    @IBOutlet weak var askLabel: UILabel!
    @IBOutlet weak var lastLabel: UILabel!
    @IBOutlet weak var marketLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    
    // Valores default
    private var data:(currency: String, market: String) = ("USD", "bitex")
    private var market = MarketData()
    private var dataChanged = false
    
    //Verifica se usuario se conectou a internet
    private var waitingConnection = false

    override func viewDidAppear(animated: Bool) {
        if Reachability.isConnectedToNetwork(){
            if waitingConnection{
                waitingConnection = false
                requestData()
            }
        }else{
            waitingConnection = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ShowMarketViewController.observerHandler(_:)), name: changeMarketKey, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ShowMarketViewController.observerHandlerBackground(_:)), name: newDataFromBackgroundKey, object: nil)
        
        if let loadedData = PersistencyManager().loadCurrentMarket(){
            data = loadedData
        }
        
        
        if Reachability.isConnectedToNetwork() == true {
            requestData()
        }else{
            
            waitingConnection = true
            
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(okAction)
            
            self.presentViewController(alert, animated: true, completion: nil)

        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if dataChanged{
            requestData()
            dataChanged = false
        }
        
    }
    
    private func loadLabels(){
        currencyLabel.text = data.currency
        marketLabel.text = market.display_Name
        lastLabel.text = market.last
        askLabel.text = market.ask
        bidLabel.text = market.bid
        
    }
    
    
    //MARK: Observer handler
    func observerHandler(notification: NSNotification){
        if let newData = notification.userInfo as? Dictionary<String,[String]>{
            data.currency = newData["Data"]![0]
            data.market = newData["Data"]![1]
            dataChanged = true
        }
        
    }
    
    
    // Mudar lugar onde pega o nome do mercado
    func observerHandlerBackground(notification: NSNotification){
        if let newData = notification.userInfo as? Dictionary<String, AnyObject>{
            if let mJSON = newData["newBackgroundData"]{
                
                if let marketFromBackground = MarketData(data.market, JSON(mJSON)){
                    self.market = marketFromBackground
                    loadLabels()
                    
                }else{
                    print("Nao conseguiu tranformar json em market Data")
                }
                
                
            }else{
                print("Chave nao encontrada")
            }
        }else{
            print("erro no parse do json")
        }
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func requestData(){
        
        CustomActivityIndicator().showLoading()

        
        MarketManager.sharedInstance.getMarket(data){
            mkt in
            
            if let marketRequest = mkt{
                self.market = marketRequest
                self.loadLabels()
                
                CustomActivityIndicator().hideLoading()

                
            }else{
                NSLog("Nao conseguiu carregar mercado")
            }
        }
    }
    

}
