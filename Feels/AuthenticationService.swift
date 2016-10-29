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
import AlamofireObjectMapper
import ObjectMapper

protocol AuthenticationService {
    func isAuthenticated() -> Bool
    func authenticate() -> Observable<Void>
}

class AuthResponse: Mappable {
    var token: String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        token <- map["token"]
    }
}

class AuthService: AuthenticationService {
    private let jwtTokenKey = "jwtTokenKey"
    private let locksmithAccount = "tbhaccount"
    private let loginEndpoint = "http://192.168.1.248:8000/auth"
    
    func getAuthToken() -> String? {
        let data = Locksmith.loadDataForUserAccount(userAccount: locksmithAccount)
        
        if let dict = data {
            return dict[jwtTokenKey] as! String?
        }
        
        return nil
    }
    
    func isAuthenticated() -> Bool {
        return getAuthToken() != nil
    }
    
    func authenticate() -> Observable<Void> {
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
                    
                    var headers: [String:String] = [:]
                    headers["Content-Type"] = "application/json"
                    headers["X-Verify-Credentials-Authorization"] = auth as? String ?? ""
                    headers["X-Auth-Service-Provider"] = provider as? String ?? ""
                    
                    Alamofire.request(self.loginEndpoint, method: .post, headers: headers)
                        .validate(statusCode: 200..<300)
                        .responseObject { (response: DataResponse<AuthResponse>) in
                            switch response.result {
                            case .success:
                                let token = response.result.value?.token
                                
                                let d: [String: String] = [self.jwtTokenKey: token!]
                                
                                try? Locksmith.saveData(data: d, forUserAccount: self.locksmithAccount)
                                
                                observer.onNext()
                                observer.onCompleted()
                                break
                            case .failure(let error):
                                print(error)
                                observer.onError(error)
                                observer.onCompleted()
                                break
                            }
                        }
                }
            }
            
            return Disposables.create()
        })
    }
}
