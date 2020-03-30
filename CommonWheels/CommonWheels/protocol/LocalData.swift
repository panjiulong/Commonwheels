//
//  LocalData.swift
//  CommonWheels
//
//  Created by PanJiuLong on 2020/3/30.
//  Copyright © 2020 Utimes-MacbookPro. All rights reserved.
//

import UIKit

protocol LocalDataDealabel{

}
extension LocalDataDealabel{
    func getJsonFile(_ name: String) -> Data?{
        var type: String? = "json"
        if name.contains("json") {
            type = nil
        }
        guard let path = Bundle.main.path(forResource: name, ofType: type) else {
            return nil
        }
        do {
            return try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        } catch {
            return nil
        }

    }
}

