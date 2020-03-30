//
//  ResponseNormalModel.swift
//  CommonWheels
//
//  Created by PanJiuLong on 2020/3/30.
//  Copyright © 2020 Utimes-MacbookPro. All rights reserved.
//

import ObjectMapper

struct ResponseNormalModel<T:Mappable>:Mappable,Error{

    var code : Int = 0    //状态码
    var message: String = ""       //消息
    var resp:T?                     //数据

    init?(map: Map) {}

    init(code:Int = 0,message:String,resp:T?) {
        self.code = code
        self.message = message
        self.resp = resp
    }

    mutating func mapping(map: Map) {
        code <- map["code"]
        message <- map["msg"]
        resp <- map["resp"]
    }
}
