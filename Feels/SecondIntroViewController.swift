//
//  SecondIntroViewController.swift
//  Feels
//
//  Created by Daniel Christopher on 10/17/16.
//  Copyright © 2016 IcyPickups LLC. All rights reserved.
//

import UIKit

class SecondIntroViewController: UIViewController {
    @IBOutlet weak var nextButton: UIButton!
    
    let digitsService = DigitsService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.makeRounded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        digitsService.signup()
    }
}
