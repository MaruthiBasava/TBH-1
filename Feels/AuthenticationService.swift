//
//  AuthenticationService.swift
//  Feels
//
//  Created by Daniel Christopher on 10/26/16.
//  Copyright © 2016 IcyPickups LLC. All rights reserved.
//

import Foundation
import DigitsKit
import Locksmith
import Alamofire
import RxSwift

protocol AuthenticationService {
    func isAuthenticated() -> Bool
    func authenticate() -> Observable<Bool>
}

class AuthService: AuthenticationService {
    let jwtTokenKey = "jwtTokenKey"
    let locksmithAccount = "tbh"
    let loginEndpoint = ""
    
    func isAuthenticated() -> Bool {
        return Locksmith.loadDataForUserAccount(userAccount: locksmithAccount) != nil
    }
    
    func authenticate() -> Observable<Bool> {
        return Observable.create({ observer -> Disposable in
            let digits = Digits.sharedInstance()
            digits.authenticate { (session, error) in
                if error != nil {
                    print(error)
                    observer.onError(error!)
                }
                else {
                    let digits = Digits.sharedInstance()
                    let oauthSigning = DGTOAuthSigning(authConfig:digits.authConfig, authSession:digits.session())
                    let authHeaders = oauthSigning?.oAuthEchoHeadersToVerifyCredentials()
                    
                    let auth = authHeaders?["X-Verify-Credentials-Authorization"]
                    let provider = authHeaders?["X-Auth-Service-Provider"]
                    
                    print(auth)
                    print("\n")
                    print(provider)
                    
                    let params = ["":""]
                    Alamofire.request(self.loginEndpoint, method: .post, parameters: params)
                        .responseJSON(completionHandler: { response in
                            print(response.data)
                        })
                    
                    observer.onNext(true)
                    observer.onCompleted()
                }
            }
            
            return Disposables.create()
        })
    }
}
