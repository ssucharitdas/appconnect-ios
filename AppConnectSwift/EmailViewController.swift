import UIKit

class EmailViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailConfirmTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var confirmLabelsMatching: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmLabelsMatching.hidden = true;
        emailTextField.addTarget(self, action: "textFieldDidBeginEditing:", forControlEvents: UIControlEvents.EditingChanged)
        emailConfirmTextField.addTarget(self, action: "textFieldDidBeginEditing:", forControlEvents: UIControlEvents.EditingChanged)
    }
    
    @IBAction func doSubmit(sender: AnyObject) {
        if emailTextField.text == emailConfirmTextField.text  {
            do {
                let emailRegEx = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,64}", options: .CaseInsensitive)
                if emailTextField.text != "" && emailRegEx.firstMatchInString(emailTextField.text!, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, emailTextField.text!.characters.count)) != nil {
                        self.performSegueWithIdentifier("EmailSuccess", sender: nil)
                }
                else{
                    confirmLabelsMatching.hidden = false
                    confirmLabelsMatching.text = "Invalid Email"
                    emailTextField.layer.borderWidth = 2.0
                    emailTextField.layer.cornerRadius = 5.0
                    emailTextField.layer.borderColor = UIColor.redColor().CGColor
                }
            }
            catch {
                print("Errored")
            }
            
            
        }
        else {
            confirmLabelsMatching.hidden = false
            emailConfirmTextField.layer.borderWidth = 2.0
            emailConfirmTextField.layer.cornerRadius = 5.0
            emailConfirmTextField.layer.borderColor = UIColor.redColor().CGColor
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Pass the userID into the FormList controller
        if segue.identifier == "EmailSuccess" {
            let passwordViewController = segue.destinationViewController as! PasswordViewController
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        confirmLabelsMatching.hidden = true
        textField.layer.borderWidth = 0.0
        textField.layer.cornerRadius = 0.0
    }
}