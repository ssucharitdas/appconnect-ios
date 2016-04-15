import UIKit

class PasswordViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func doSubmit(sender: AnyObject) {
        self.performSegueWithIdentifier("PasswordSuccess", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Pass the userID into the FormList controller
        if segue.identifier == "PasswordSuccess" {
            let securityQuestionViewController = segue.destinationViewController as! SecurityQuestionViewController
        }
    }
}
