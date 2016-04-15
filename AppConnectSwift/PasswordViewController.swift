import UIKit

class PasswordViewController: UIViewController {
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfirmField: UITextField!
    @IBOutlet weak var confirmPasswordsMatching: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmPasswordsMatching.hidden =  true
        passwordField.addTarget(self, action: "textFieldDidBeginEditing:", forControlEvents: UIControlEvents.EditingChanged)
        passwordConfirmField.addTarget(self, action: "textFieldDidBeginEditing:", forControlEvents: UIControlEvents.EditingChanged)
    }
    
    @IBAction func doSubmit(sender: AnyObject) {
        if passwordField.text == passwordConfirmField.text {
            do {
                let passwordRegEx = try NSRegularExpression(pattern: "((?=.*\\d)(?=.*[a-z])(?=.*[A-Z])){8,}", options: .CaseInsensitive)
                if passwordField.text != "" && passwordRegEx.firstMatchInString(passwordField.text!, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, passwordField.text!.characters.count)) != nil && passwordField.text?.characters.count >= 8 {
                    self.performSegueWithIdentifier("PasswordSuccess", sender: nil)
                }
                else {
                    confirmPasswordsMatching.hidden = false
                    confirmPasswordsMatching.text = "Password criteria not met"
                    passwordField.layer.borderWidth = 2.0
                    passwordField.layer.cornerRadius = 5.0
                    passwordField.layer.borderColor = UIColor.redColor().CGColor
                }
                
            }
            catch {
                print("Errored")
            }
            
        }
        else {
            confirmPasswordsMatching.hidden = false
            confirmPasswordsMatching.text = "Passwords not matching"
            passwordConfirmField.layer.borderWidth = 2.0
            passwordConfirmField.layer.cornerRadius = 5.0
            passwordConfirmField.layer.borderColor = UIColor.redColor().CGColor
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Pass the userID into the FormList controller
        if segue.identifier == "PasswordSuccess" {
            let securityQuestionViewController = segue.destinationViewController as! SecurityQuestionViewController
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        confirmPasswordsMatching.hidden = true
        textField.layer.borderWidth = 0.0
        textField.layer.cornerRadius = 0.0
    }
}