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
import PhoneNumberKit

enum SendMessageError : String, Error {
    case AlreadyExists = "Message already exists"
}

class MessageService {
    private let anonymousEndpoint = "http://tbh-development-dev.us-east-1.elasticbeanstalk.com/messages?filter=received"
    private let mutualEndpoint = "http://tbh-development-dev.us-east-1.elasticbeanstalk.com/messages?filter=mutual"
    private let presetsEndpoint = "http://tbh-development-dev.us-east-1.elasticbeanstalk.com/presets"
    private let sendEndpoint = "http://tbh-development-dev.us-east-1.elasticbeanstalk.com/messages"
    
    private let authService = AuthService()
    private let contactsService = ContactsService()
    
    func sendMessageTo(messageCode: Int!, phoneNumber: String!) -> Observable<Void> {
        return Observable.create({ observer -> Disposable in
            let headers = [
                "Content-Type": "application/json",
                "Authorization": "JWT \(self.authService.getAuthToken()!)"
            ]
            
            print(headers)
            
            var cleaned = phoneNumber
            
            do {
                let phoneNumberKit = PhoneNumberKit()
                let phoneNumber = try phoneNumberKit.parse(phoneNumber)
                cleaned = phoneNumberKit.format(phoneNumber, toType: .e164)
                print(cleaned)
            }
            catch {
                print("Generic parser error")
            }
            
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
    
    func getAnonymousMessagesFromCache() -> Observable<MessageList?> {
        let notificationsService = NotificationsService()
        return Observable.just(notificationsService.getAllNotifications())
            .map({ notifications -> MessageList in
                var messages: [MessageModel] = []
                for n in notifications {
                    let message = MessageModel(message: n.body)
                    messages.append(message)
                }
                
                return MessageList(messages: messages)
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
                            print(message.sender.phoneNumber)
                            let phoneNumber = self.contactsService.normalizePhoneNumber(number: message.sender.phoneNumber)
                            
                            if phoneNumber != nil {
                                let results = self.contactsService.searchForContactUsingPhoneNumber(phoneNumber: phoneNumber!)
                                print(phoneNumber!)
                                
                                if results.count > 0 {
                                    let contact = results[0]
                                    message.sender.name = "\(contact.givenName) \(contact.familyName) - \(message.sender.phoneNumber!)"
                                }
                                else {
                                    // Couldn't find user in contacts, just use their number for their name
                                    message.sender.name = message.sender.phoneNumber
                                }
                            }
                            else {
                                // Couldn't find user in contacts, just use their number for their name
                                message.sender.name = message.sender.phoneNumber
                            }
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
