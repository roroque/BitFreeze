
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
        marketLabel.text = data.market
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
    
    func reloadDataFromBackground(){
        
    }
}
