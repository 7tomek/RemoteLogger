import UIKit

class UIMessageTableViewCell: UITableViewCell {
    
    @IBOutlet var messagetextLabel: UILabel?

}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ServerDelegate {
    
    @IBOutlet var tableView: UITableView?
    var tableContentArray: NSMutableArray?
    var currentIPString: String?
    var refreshControl: UIRefreshControl!
    var autoRefresh: Bool? = true
    
    var server: Server?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Remote Logger"
        tableView?.estimatedRowHeight = 44.0
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableContentArray = NSMutableArray()
        initRefreshControl()
    }

    func initServer() {
        println("Address IP: \(Utils.getIFAddresses())")
        currentIPString = Utils.getIFAddresses().first
        
        server = Server(portServer: 8080);
        server?.startListener(self)
    }
    
    func initRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.blueColor()
        refreshControl.tintColor = UIColor.whiteColor()
        refreshControl.addTarget(self, action: Selector("getRefresh:"), forControlEvents: UIControlEvents.ValueChanged)
        tableView?.addSubview(refreshControl)
    }
    
    func getRefresh(sender: AnyObject) {
        autoRefresh = true
        tableView?.reloadData()
        refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(animated: Bool) {
        initServer()
        tableView?.reloadData()
        super.viewWillAppear(animated)
    }
    
    func serverDidComeMessage(message: String) {
        tableContentArray?.addObject(message)
        if autoRefresh == true {
            NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
                self.tableView?.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableContentArray != nil {
            return tableContentArray!.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("msgCell") as? UIMessageTableViewCell
        
        if cell != nil {
            
            cell!.messagetextLabel?.text = tableContentArray?.objectAtIndex(tableContentArray!.count - 1 - indexPath.row) as? String
        }
        
        return cell!;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DetailViewController" {
            let detailVC = segue.destinationViewController as? DetailViewController
            let data = ["ServerIP" : currentIPString!, "ServerPort": String(server!.port)]
            detailVC?.dataToDisplay = data
        }
        super.prepareForSegue(segue, sender: sender)
    }
    
    @IBAction func touchUpClear(sender: AnyObject) {
        tableContentArray = NSMutableArray();
        tableView?.reloadData()
    }
    
    @IBAction func touchUpStopAutoRefresh(sender: AnyObject) {
        autoRefresh = false
    }
}

