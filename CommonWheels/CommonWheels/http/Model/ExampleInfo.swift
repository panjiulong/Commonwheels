//
//  ExampleInfo.swift
//  CommonWheels
//
//  Created by PanJiuLong on 2020/3/30.
//  Copyright © 2020 Utimes-MacbookPro. All rights reserved.
//

import ObjectMapper

struct ExampleInfo:Mappable {
    var money:String = ""
    var hphm:String = ""
    var type:Int = 0
    var payType:Int = 0
    var createdAt:String = ""

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        money <- map["money"]
        hphm <- map["hphm"]
        type <- map["type"]
        payType <- map["payType"]
        createdAt <- map["createdAt"]
    }
}

struct ExampleToken:Mappable {
    var token:String?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        token <- map["securityToken"]

    }
}
