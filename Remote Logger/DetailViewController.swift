import UIKit

class DetailViewController: UIViewController {
    
    var dataToDisplay: [String: String]!
    
    @IBOutlet var labeltextIPLabel: UILabel!
    @IBOutlet var labeltextPortLabel: UILabel!
    
    override func viewDidLoad() {
        navigationItem.leftBarButtonItem?.title = "Back"
        
        if let addressIPString = dataToDisplay["ServerIP"] {
            labeltextIPLabel.text = addressIPString
        }
        
        if let portIPString = dataToDisplay["ServerPort"] {
            labeltextPortLabel.text = portIPString
        }
        
        super.viewDidLoad()
    }
    
}