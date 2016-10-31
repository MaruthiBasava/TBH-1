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
import Contacts

enum SendMessageError : String, Error {
    case AlreadyExists = "Message already exists"
}

class MessageService {
    private let anonymousEndpoint = "http://192.168.1.248:8080/messages?filter=received"
    private let mutualEndpoint = "http://192.168.1.248:8080/messages?filter=mutual"
    private let presetsEndpoint = "http://192.168.1.248:8080/presets"
    private let sendEndpoint = "http://192.168.1.248:8080/messages"
    
    private let authService = AuthService()
    private let contactsService = ContactsService()
    
    func sendMessageTo(messageCode: Int!, phoneNumber: String!) -> Observable<Void> {
        return Observable.create({ observer -> Disposable in
            let headers = [
                "Content-Type": "application/json",
                "Authorization": "JWT \(self.authService.getAuthToken()!)"
            ]
            
            print(headers)
            
            let parameters: [String: Any] = [
                "receiver_phone_number": phoneNumber,
                "message_id": messageCode
            ]
            
            Alamofire.request(self.sendEndpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 201..<300)
                .response { response in
                    if response.error != nil {
                        observer.onNext()
                        observer.onCompleted()
                    }
                    else {
                        if response.response?.statusCode == 409 {
                            observer.onError(SendMessageError.AlreadyExists)
                            observer.onCompleted()
                        }
                        else {
                            observer.onError(response.error!)
                            observer.onCompleted()
                        }
                    }
                }
            
            return Disposables.create()
        })
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

    func getReceivedAnonymousMessages() -> Observable<MessageList?> {
        return Observable.create({ observer -> Disposable in
            let headers = [
                "Content-Type": "application/json",
                "Authorization": "JWT \(self.authService.getAuthToken()!)"
            ]
            
            Alamofire.request(self.anonymousEndpoint, method: .get, headers: headers)
                .validate(statusCode: 200..<300)
                .responseObject { (response: DataResponse<MessageList>) in
                    print(response.response?.allHeaderFields)
                    print("\n")
                    switch response.result {
                    case .success:
                        let d = String(data: response.data!, encoding: String.Encoding.utf8)
                        print(d)
                        let data = response.result.value!
                        
                        observer.onNext(data)
                        observer.onCompleted()
                        break
                    case .failure(let error):
                        
                        let d = String(data: response.data!, encoding: String.Encoding.utf8)
                        print(d)
                        
                        print(error)
                        observer.onError(error)
                        observer.onCompleted()
                        break
                    }
            }
            
            return Disposables.create()
        })
    }
    
    func getMutualMessages() -> Observable<MessageList?> {
        return Observable.create({ observer -> Disposable in
            let headers = [
                "Content-Type": "application/json",
                "Authorization": "JWT \(self.authService.getAuthToken()!)"
            ]
            
            Alamofire.request(self.mutualEndpoint, method: .get, headers: headers)
                .validate(statusCode: 200..<300)
                .responseObject { (response: DataResponse<MessageList>) in
                    print(response.result.value?.messages)
                    switch response.result {
                    case .success:
                        let data = response.result.value!
                        
                        for message in data.messages {
                            let contact = self.contactsService.searchForContactUsingPhoneNumber(phoneNumber: message.senderPhoneNumber!)[0]
                            message.senderName = "\(contact.givenName) \(contact.middleName) \(contact.familyName)"
                        }
                        
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
}
