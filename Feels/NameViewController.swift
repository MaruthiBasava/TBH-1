//
//  NameViewController.swift
//  Feels
//
//  Created by Daniel Christopher on 10/17/16.
//  Copyright © 2016 IcyPickups LLC. All rights reserved.
//

import UIKit
import DigitsKit

class NameViewController: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.becomeFirstResponder()
        nextButton.makeRounded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func next(_ sender: UIButton) {
        let digits = Digits.sharedInstance()
        digits.authenticate { (session, error) in
            if(error == nil) {
                let genderViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "gender_vc")
                self.navigationController?.pushViewController(genderViewController, animated: true)
            }
            else {
                
            }
        }
    }
}
