//
//  MutualMessageModel.swift
//  Feels
//
//  Created by Daniel Christopher on 10/29/16.
//  Copyright © 2016 IcyPickups LLC. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper
import Contacts

class MessageList: Mappable {
    var messages: [MessageModel] = []
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        messages <- map["messages"]
    }
}

class User: Mappable {
    var name: String?
    var phoneNumber: String!
    var genderCode: Int!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        phoneNumber <- map["phone_number"]
        genderCode <- map["gender"]
    }
}

class MessageModel: Mappable {
    var message: String!
    var sender: User!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        message <- map["text"]
        sender <- map["sender"]
    }
}
