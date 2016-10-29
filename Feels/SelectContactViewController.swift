//
//  SelectContactViewController.swift
//  Feels
//
//  Created by Daniel Christopher on 10/18/16.
//  Copyright © 2016 IcyPickups LLC. All rights reserved.
//

import UIKit
import ContactsUI

class SelectContactViewController: UIViewController {
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!

    var phoneNumber: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectButton.makeRounded()
    }

    override func viewDidAppear(_ animated: Bool) {
        nextButton.layer.cornerRadius = nextButton.frame.size.width / 2
        nextButton.clipsToBounds = true
    }
    
    @IBAction func next(_ sender: UIButton) {
        if phoneNumber != nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let sendViewController = storyboard.instantiateViewController(withIdentifier: "select_message_vc") as! SendViewController
            
            sendViewController.recipientPhoneNumber = phoneNumber
        
            present(sendViewController, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func selectContact(_ sender: UIButton) {
        let controller = CNContactPickerViewController()
        controller.delegate = self
        present(controller, animated: true)
    }
}

extension SelectContactViewController: CNContactPickerDelegate {
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        phoneNumber = contact.phoneNumbers[0].value.stringValue
        let name = "\(contact.givenName) \(contact.middleName) \(contact.familyName)"
        
        self.selectButton.setTitle(name, for: .normal)
    }
}
