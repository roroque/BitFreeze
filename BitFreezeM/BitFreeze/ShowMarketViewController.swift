
import UIKit

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
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Reachability.isConnectedToNetwork() == true {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ShowMarketViewController.testFunc(_:)), name: changeMarketKey, object: nil)
            
            if let loadedData = PersistencyManager().loadCurrentMarket(){
                data = loadedData
            }
            
            requestData()
        }else{
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
        marketLabel.text = data.market
        lastLabel.text = market.last
        askLabel.text = market.ask
        bidLabel.text = market.bid
    }
    
    
    //MARK: Observer handler
    func testFunc(notification: NSNotification){
        if let newData = notification.userInfo as? Dictionary<String,[String]>{
            data.currency = newData["Data"]![0]
            data.market = newData["Data"]![1]
            dataChanged = true
        }
        
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func requestData(){
        MarketManager.sharedInstance.getMarket(data){
            mkt in
            
            if let marketRequest = mkt{
                self.market = marketRequest
                self.loadLabels()
                
            }else{
                NSLog("Nao conseguiu carregar mercado")
            }
        }
    }
}
