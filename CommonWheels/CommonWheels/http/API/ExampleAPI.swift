//
//  ExampleAPI.swift
//  CommonWheels
//
//  Created by PanJiuLong on 2020/3/30.
//  Copyright © 2020 Utimes-MacbookPro. All rights reserved.
//

import Moya

public enum ExampleAPI:LocalDataDealabel{
    case getExampleInfo(id:Int)
    case updateToken
}
extension ExampleAPI:TargetType{
    public var baseURL: URL {
        return URL(string: "www.baidu.com")!
    }

    public var path: String {
        switch self {
        case .getExampleInfo:
            return ""
        case .updateToken:
            return ""
        }
    }

    public var method: Method {
        switch self {
        case .getExampleInfo,.updateToken:
            return .get
        }
    }

    public var sampleData: Data {
        switch self {
        case .getExampleInfo:
            return  getJsonFile("data") ?? Data()
        case .updateToken:
            return getJsonFile("token") ?? Data()
        }
    }

    public var task: Task {
        switch self {
        case let .getExampleInfo(id: id):
            return .requestParameters(parameters: ["id": id], encoding: URLEncoding.default)
        case .updateToken:
            return .requestPlain
        }
    }

    public var headers: [String : String]? {
        switch self {
        case .getExampleInfo:
            return [:]
        case .updateToken:
            return [:]
        }
    }


}
