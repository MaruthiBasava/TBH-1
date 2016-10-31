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
    func authenticate(genderCode: Int!) -> Observable<Void>
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
    private let phoneNumberKey = "phoneNumberKey"
    private let jwtTokenKey = "jwtTokenKey"
    private let locksmithAccount = "locksmithacc1"
    private let loginEndpoint = "http://192.168.1.248:8080/auth"
    
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
    
    func authenticate(genderCode: Int!) -> Observable<Void> {
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
                    
                    let headers = [
                        "Content-Type": "application/json",
                        "X-Verify-Credentials-Authorization": auth as? String ?? "",
                        "X-Auth-Service-Provider": provider as? String ?? ""
                    ]
                    
                    let params: [String: Any] = [
                        "gender": genderCode
                    ]
                    
                    print(params)
                    print(headers)
                    
                    Alamofire.request(self.loginEndpoint, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
                        .validate(statusCode: 200..<300)
                        .responseObject { (response: DataResponse<AuthResponse>) in
                            print(response.request)
                            print("\n")
                            print(response.response)
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
