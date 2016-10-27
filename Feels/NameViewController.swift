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
}
