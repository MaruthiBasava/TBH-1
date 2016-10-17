//
//  SendViewController.swift
//  Feels
//
//  Created by Daniel Christopher on 10/16/16.
//  Copyright © 2016 IcyPickups LLC. All rights reserved.
//

import UIKit
import AddressBookUI

class MessageTableViewCell: UITableViewCell {
    @IBOutlet weak var messageLabel: UILabel!
}

class SendViewController: UIViewController {
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var selectButton: UIButton!
    
    fileprivate let items: [String] = [
        "We should hang out 👌",
        "We should start talking again 😎",
        "Your cute 😍",
        "Your hilarious 😂",
        "Your nice 🙂"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesTableView.makeRounded()
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        
        selectButton.makeRounded()
        sendButton.makeRounded()
    }
    
    @IBAction func selectContact(_ sender: UIButton) {
        let picker = ABPeoplePickerNavigationController()
        picker.peoplePickerDelegate = self
        present(picker, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func send(_ sender: UIButton) {
    }
}

extension SendViewController: ABPeoplePickerNavigationControllerDelegate {
    
    func peoplePickerNavigationController(_ peoplePicker: ABPeoplePickerNavigationController, didSelectPerson person: ABRecord) {
        let firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty)
        let lastName = ABRecordCopyValue(person, kABPersonLastNameProperty)
        
        var first = ""
        var last = ""
        
        if firstName != nil {
            first = firstName?.takeRetainedValue() as? String ?? ""
        }
        
        if lastName != nil {
            last = lastName?.takeRetainedValue() as? String ?? ""
        }
        
        
        let personName = "\(first) \(last)"
        
        selectButton.setTitle(personName, for: .normal)
    }
    
    func peoplePickerNavigationController(_ peoplePicker: ABPeoplePickerNavigationController, shouldContinueAfterSelectingPerson person: ABRecord) -> Bool {
        peoplePickerNavigationController(peoplePicker, didSelectPerson: person)
        
        peoplePicker.dismiss(animated: true, completion: nil)
        
        return false
    }
    
    func peoplePickerNavigationControllerDidCancel(_ peoplePicker: ABPeoplePickerNavigationController) {
        dismiss(animated: true)
    }
}

extension SendViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "message_cell") as! MessageTableViewCell
        
        cell.messageLabel.text = items[(indexPath as NSIndexPath).row]
        
        return cell
    }
}

extension SendViewController: UITableViewDelegate {
    
}
