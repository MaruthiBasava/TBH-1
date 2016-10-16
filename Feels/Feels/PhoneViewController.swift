//
//  PhoneViewController.swift
//  Feels
//
//  Created by Daniel Christopher on 10/16/16.
//  Copyright © 2016 IcyPickups LLC. All rights reserved.
//

import UIKit

class PhoneViewController: UIViewController {

    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.phoneNumberTextField.becomeFirstResponder()
        self.nextButton.makeRounded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
