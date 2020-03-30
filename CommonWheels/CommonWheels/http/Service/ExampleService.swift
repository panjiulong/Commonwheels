//
//  ExampleService.swift
//  CommonWheels
//
//  Created by PanJiuLong on 2020/3/30.
//  Copyright © 2020 Utimes-MacbookPro. All rights reserved.
//

import RxSwift
import Moya
import Moya_ObjectMapper

struct ExampleService {
    
    let disposeBag:DisposeBag = DisposeBag()

    func getExampleInfo(id:Int) -> Single<ResponseNormalModel<ExampleInfo>> {
        let target = MultiTarget(ExampleAPI.getExampleInfo(id: id))
        return testProvider.request(target: target)
    }

    func updateToken() -> Single<ResponseNormalModel<ExampleToken>> {
        let target = MultiTarget(ExampleAPI.updateToken)
        return testProvider.request(target: target)
    }

}
