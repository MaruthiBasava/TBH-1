//
//  ContactViewController.swift
//  Feels
//
//  Created by Daniel Christopher on 10/16/16.
//  Copyright © 2016 IcyPickups LLC. All rights reserved.
//

import UIKit
import AddressBookUI

class ContactViewController: UIViewController {    
    @IBOutlet weak var contactsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ContactViewController.done))
        navigationController?.navigationBar.topItem?.rightBarButtonItem = doneButton
    }
    
    func done() {
        dismiss(animated: true)
    }
}
