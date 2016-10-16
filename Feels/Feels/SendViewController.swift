//
//  SendViewController.swift
//  Feels
//
//  Created by Daniel Christopher on 10/16/16.
//  Copyright © 2016 IcyPickups LLC. All rights reserved.
//

import UIKit
import PickerView

class SendViewController: UIViewController {
    
    @IBOutlet weak var sendButton: UIButton!
    
    private let items: [String] = [
        "We should go to the movies",
        "We should start talking again",
        "Your cute",
        "Your hilarious"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendButton.makeRounded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func send(sender: UIButton) {
    }
}
