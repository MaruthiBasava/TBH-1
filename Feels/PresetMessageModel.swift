//
//  PresetMessageModel.swift
//  Feels
//
//  Created by Daniel Christopher on 10/29/16.
//  Copyright © 2016 IcyPickups LLC. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import ObjectMapper

class PresetMessages: Mappable {
    var messages: [PresetMessageModel]!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        messages <- map["presets"]
    }
}

class PresetMessageModel: Mappable {
    var code: Int!
    var message: String!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
    }
}
