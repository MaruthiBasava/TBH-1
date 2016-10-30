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

class MutualMessageList: Mappable {
    var messages: [MutualMessageModel] = []
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        messages <- map["messages"]
    }
}

class MutualMessageModel: Mappable {
    var code: Int!
    var message: String!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
    }
}
