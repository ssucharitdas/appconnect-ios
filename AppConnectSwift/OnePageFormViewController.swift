//
//  DataViewController.swift
//  AppConnectSample
//
//  Created by Steve Roy on 2015-12-16.
//  Copyright © 2015 Medidata Solutions. All rights reserved.
//

import UIKit

class OnePageFormViewController: UIViewController {
    var dataObject: String = ""
    
    var datastore = MDDatastoreFactory.create()
    
    var form : MDForm!
    var formID : Int64! {
        didSet { form = self.datastore.formWithID(formID) }
    }
    
    @IBOutlet var formTitle : UILabel!
    
    @IBOutlet var field1Label : UILabel!
    @IBOutlet var field2Label : UILabel!
    @IBOutlet var field3Label : UILabel!
    
    @IBOutlet var field1Response : UITextField!
    @IBOutlet var field2Response : UITextField!
    @IBOutlet var field3Response : UITextField!
    
    @IBOutlet var submit : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        formTitle.text = form.name
        
        for field in form.fields {
            print("fieldOID: \(field.fieldOID)")
            print("fieldName: \(field.name)")
            print("fieldHeader: \(field.header)")
            print("fieldLabel: \(field.label)")
            switch field.fieldOID {
            case "TEXTFIELD1":
                let tf = field as! MDTextField
                field1Label.text = tf.label
                field1Response.placeholder = "Max Length: \(tf.maximumResponseLength)"
            case "NUMBERS":
                let nf = field as! MDNumericField
                field2Label.text = nf.label
                field2Response.placeholder = numericFieldFormat(nf);
            case "NUMERICVALUE":
                let nf = field as! MDNumericField
                field3Label.text = nf.label
                field3Response.placeholder = numericFieldFormat(nf);
            default:
                break
            }
        }
    }
    
    func numericFieldFormat(field : MDNumericField) -> String {
        let components = [
            String(field.maximumResponseIntegerCount),
            field.responseIntegerCountRequired ? "+" : "",
            ".",
            String(field.maximumResponseDecimalCount),
            field.responseDecimalCountRequired ? "+" : ""
        ]
        
        return components.joinWithSeparator("")
    }

    @IBAction func doSubmit(sender: AnyObject) {
        if validateResponses() {
            let clientFactory = MDClientFactory.sharedInstance()
            let client = clientFactory.clientOfType(MDClientType.Network);
            
            client.sendResponsesForForm(self.form, inDatastore: self.datastore, deviceID: "fake-device-id", completion: { (error: NSError!) -> Void in
                if error != nil {
                    self.showDialog("Error", message: "There was an error submitting the form", completion: nil)
                } else {
                    NSOperationQueue.mainQueue().addOperationWithBlock {
                        self.showDialog("Success", message: "Your form has been submitted.") {
                            self.navigationController?.popViewControllerAnimated(true)
                        }
                    }
                }
            })
            
        }
    }
    
    func validateResponses() -> Bool {
        let decimalChar = ".".utf16
        let decimal = decimalChar[decimalChar.startIndex]

        let sequencer = MDStepSequencer(form: self.form)
        sequencer.start()
        
        let field1 = sequencer.currentField as! MDTextField
        field1.subjectResponse = field1Response.text
        if field1.responseProblem != MDFieldProblem.None {
            showDialog("Wrong Format", message: "Field 1 is not the correct format.", completion:nil)
            return false
        }
        
        sequencer.moveToNext()
        
        
        let field2 = sequencer.currentField as! MDNumericField
        field2.subjectResponse = field2.responseFromString(field2Response.text, decimalSeparator: decimal)
        if field2.responseProblem != MDFieldProblem.None {
            showDialog("Wrong Format", message: "Field 2 is not the correct format.", completion:nil)
            return false
        }
        
        sequencer.moveToNext()
        
        let field3 = sequencer.currentField as! MDNumericField
        field3.subjectResponse = field3.responseFromString(field3Response.text, decimalSeparator: decimal)
        if field3.responseProblem != MDFieldProblem.None {
            showDialog("Wrong Format", message: "Field 3 is not the correct format.", completion:nil)
            return false
        }
        
        // The sequencer must be in the reviewing state to be able to finish the form
        sequencer.moveToNext()
        if sequencer.state != MDStepSequencerState.Reviewing{
            showDialog("Wrong Format", message: "There are more fields to be filled out in this form", completion:nil)
            return false
        }
        
        // Once the form is completely filled out, you must call finish() to
        // stamp the form with the completion date and time. Attempting to
        // submit will fail if finish() hasn't been called. If the form requires
        // a signature, form.sign() should also be called before calling finish().
        if !sequencer.finish() {
            showDialog("No Signature", message:"The form requests a signature, which is not supported by the sample app", completion:nil)
            return false
        }
        
        
        return true
    }
    
    func showDialog(title: String, message: String, completion: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(
            UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (alert: UIAlertAction) -> Void in
                completion?()
            })
        )
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    internal func setFormID(formID: Int64) {
        self.formID = formID
    }
}

