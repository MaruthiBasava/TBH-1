//
//  SelectContactViewController.swift
//  Feels
//
//  Created by Daniel Christopher on 10/18/16.
//  Copyright © 2016 IcyPickups LLC. All rights reserved.
//

import UIKit
import AddressBookUI

class SelectContactViewController: UIViewController {
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        selectButton.makeRounded()
    }

    override func viewDidAppear(_ animated: Bool) {
        nextButton.layer.cornerRadius = nextButton.frame.size.width / 2
        nextButton.clipsToBounds = true
    }
    
    @IBAction func next(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sendViewController = storyboard.instantiateViewController(withIdentifier: "select_message_vc")
        
        present(sendViewController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func selectContact(_ sender: UIButton) {
        let picker = ABPeoplePickerNavigationController()
        picker.peoplePickerDelegate = self
        present(picker, animated: true)
    }
}

extension SelectContactViewController: ABPeoplePickerNavigationControllerDelegate {
    
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
