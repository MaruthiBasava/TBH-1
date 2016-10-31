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

class MessageModel: Mappable {
    var message: String!
    var senderPhoneNumber: String?
    var senderName: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        message <- map["text"]
    }
}
