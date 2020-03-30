//
//  JLProvider.swift
//  CommonWheels
//
//  Created by PanJiuLong on 2020/3/30.
//  Copyright © 2020 Utimes-MacbookPro. All rights reserved.
//

import Moya
import ObjectMapper
import RxSwift

let shouldShowLog = true  //是否打印日志

let defualtProvider = JLProvider(endpointClosure: myEndpointClosure,
                                 requestClosure: requestClosure,
                                 stubClosure: MoyaProvider.neverStub,
                                 callbackQueue: DispatchQueue.main,
                                 plugins: [networkLoggerPlugin],
                                 trackInflights: false)
let testProvider = JLProvider(endpointClosure: myEndpointClosure,
                              requestClosure: requestClosure,
                              stubClosure: MoyaProvider.immediatelyStub,
                              callbackQueue: DispatchQueue.main,
                              plugins: [networkLoggerPlugin],
                              trackInflights: false)

// MARK: - 设置请求头
private let myEndpointClosure = { (target: MultiTarget) -> Endpoint in
    //处理URL
    let url = target.baseURL.appendingPathComponent(target.path).absoluteString

    let endpoint = Endpoint(url: url,
                            sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                            method: target.method,
                            task: target.task,
                            httpHeaderFields: target.headers
    )

    do {
        //设置通用header
        var urlRequest = try endpoint.urlRequest()
        urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: [:], options: .prettyPrinted)
    } catch let error  {
        print(error)
    }
    return endpoint.adding(newHTTPHeaderFields: [ "Content-Type" : "application/json",])

}

// MARK: - 设置请求超时时间
private let requestClosure = { (endpoint: Endpoint, closure: @escaping MoyaProvider<MultiTarget>.RequestResultClosure) in
    do {
        var urlRequest = try endpoint.urlRequest()
        urlRequest.timeoutInterval = 12
        closure(.success(urlRequest))
    } catch MoyaError.requestMapping(let url) {
        closure(.failure(MoyaError.requestMapping(url)))
    } catch MoyaError.parameterEncoding(let error) {
        closure(.failure(MoyaError.parameterEncoding(error)))
    } catch {
        closure(.failure(MoyaError.underlying(error, nil)))
    }
}

// MARK: - 调试plugin

private let networkLoggerPlugin = NetworkLoggerPlugin(configuration:NetworkLoggerPlugin.Configuration(output:reversedPrint, logOptions:.verbose))


func reversedPrint(target: TargetType, items: [String]) {
    #if DEBUG
    guard shouldShowLog else { return }
    for item in items {
        print(item, separator: ",", terminator: "\n")
    }
    #endif
}


//MARK: - 自定义Provider

class JLProvider: MoyaProvider<MultiTarget> {

    let disposeBag:DisposeBag = DisposeBag()

    var needResendTarget: MultiTarget?

    var token:String?

    override init(endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = MoyaProvider.defaultEndpointMapping, requestClosure: @escaping MoyaProvider<Target>.RequestClosure = MoyaProvider<Target>.defaultRequestMapping, stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider.neverStub, callbackQueue: DispatchQueue? = nil, session: Session = MoyaProvider<Target>.defaultAlamofireSession(), plugins: [PluginType] = [], trackInflights: Bool = false) {
        super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, callbackQueue: callbackQueue, session: session, plugins: plugins, trackInflights: trackInflights)
    }

    let tokenExpiredClosure: (MultiTarget,DisposeBag)->(Single<Response>) = { target,disposeBag in
        let updateToken =  ExampleService().updateToken()
        updateToken.subscribe(onSuccess: { (model) in
            //更新token
            UserDefaults.standard.set(model.resp?.token, forKey: "token")
            UserDefaults.standard.synchronize()
        }, onError: { error in
            print(error)
        }).disposed(by: disposeBag)
        let responses = updateToken.filter{ $0.code == 0 }.asObservable().flatMapLatest({ model -> Single<Response> in
            return testProvider.rx.request(target)
        }).asSingle()
        return responses
    }

}

extension JLProvider{
    func request<T:Mappable,U:TargetType>(target:U)-> Single<T>{
        return self.rx.request(target as! MultiTarget)
            .filterSuccessfulStatusCodes()
            .filterSuccess(target: target as! MultiTarget,disposeBag:disposeBag,tokenExpiredClosure: tokenExpiredClosure)
            .mapObject(T.self)
    }
}
