//
//  DigitsService.swift
//  Feels
//
//  Created by Daniel Christopher on 10/23/16.
//  Copyright © 2016 IcyPickups LLC. All rights reserved.
//

import Foundation
import DigitsKit

class DigitsService {
    
    func signup() {
        let digits = Digits.sharedInstance()
        digits.authenticate { (session, error) in
            if error != nil {
                print(error)
            }
            else {
                let digits = Digits.sharedInstance()
                let oauthSigning = DGTOAuthSigning(authConfig:digits.authConfig, authSession:digits.session())
                let authHeaders = oauthSigning?.oAuthEchoHeadersToVerifyCredentials()
                
                let auth = authHeaders?["X-Verify-Credentials-Authorization"]
                let provider = authHeaders?["X-Auth-Service-Provider"]
                
                print(authHeaders)
            }
        }
    }
}
