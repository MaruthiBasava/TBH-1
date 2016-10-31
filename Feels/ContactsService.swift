//
//  ContactsService.swift
//  Feels
//
//  Created by Daniel Christopher on 10/30/16.
//  Copyright © 2016 IcyPickups LLC. All rights reserved.
//

import Foundation
import Contacts
import PhoneNumberKit

class ContactsService {
    
    func normalizePhoneNumber(number: String!) -> String? {
        do {
            let phoneNumberKit = PhoneNumberKit()
            let phoneNumber = try phoneNumberKit.parse(number)
           
            return phoneNumber.adjustedNationalNumber()
        } catch {
            print("error normalizePhoneNumber")
        }
        
        return nil
    }
    
    func getContacts() -> [CNContact] {
        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactEmailAddressesKey,
            CNContactPhoneNumbersKey,
            CNContactImageDataAvailableKey,
            CNContactThumbnailImageDataKey] as [Any]
        
        // Get all the containers
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }
        
        var results: [CNContact] = []
        
        // Iterate all containers and append their contacts to our results array
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            
            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)
            } catch {
                print("Error fetching results for container")
            }
        }
        
        return results
    }
    
    func searchForContactUsingPhoneNumber(phoneNumber: String) -> [CNContact] {
        
        var result: [CNContact] = []
        
        for contact in self.getContacts() {
            if (!contact.phoneNumbers.isEmpty) {
                var phoneNumberToCompareAgainst = phoneNumber.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
                for phoneNumber in contact.phoneNumbers {
                    if let phoneNumberStruct = phoneNumber.value as? CNPhoneNumber {
                        var phoneNumberString = phoneNumberStruct.stringValue
                        
                        phoneNumberString = phoneNumberString.replacingOccurrences(of: "+1", with: "")
                        
                        let phoneNumberToCompare = phoneNumberString.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
                        
                         phoneNumberToCompareAgainst = phoneNumberToCompareAgainst.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
                        
                        print(phoneNumberToCompare)
                        print(phoneNumberToCompareAgainst)
                        
                        if phoneNumberToCompare == phoneNumberToCompareAgainst {
                            result.append(contact)
                        }
                    }
                }
            }
        }
        
        return result
    }
}
