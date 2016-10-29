//
//  MessageService.swift
//  Feels
//
//  Created by Daniel Christopher on 10/27/16.
//  Copyright © 2016 IcyPickups LLC. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

class MessageService {
    let presetsEndpoint = "http://192.168.1.248:8000/presets"
    private let authService = AuthService()
    
    func sendMessageTo(messageCode: Int!, phoneNumber: String!) {
        
    }
    
    func getPossibleMessages() -> Observable<[PresetMessageModel]?> {
        return Observable.create({ observer -> Disposable in
            let headers = [
                "Content-Type": "application/json",
                "Authorization": "JWT \(self.authService.getAuthToken()!)"
            ]
            
            Alamofire.request(self.presetsEndpoint, method: .get, headers: headers)
                .validate(statusCode: 200..<300)
                .responseObject { (response: DataResponse<PresetMessages>) in
                    switch response.result {
                    case .success:
                        let data = response.result.value!.messages
                        
                        observer.onNext(data)
                        observer.onCompleted()
                        break
                    case .failure(let error):
                        print(error)
                        observer.onError(error)
                        observer.onCompleted()
                        break
                    }
            }
            
            return Disposables.create()
        })
    }

    func getSentMessages() {
        
    }

    func getReceivedAnonymousMessages() {
        
    }
    
    func getMutualMessages() {
        
    }
}
