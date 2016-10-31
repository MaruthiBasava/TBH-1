//
//  ViewController.swift
//  Feels
//
//  Created by Daniel Christopher on 10/30/16.
//  Copyright © 2016 IcyPickups LLC. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showGenericError() {
        self.showAlertDialog(title: "Error", message: "Something went wrong 😭")
    }
    
    func showAlertDialog(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            print("OK")
        }
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
