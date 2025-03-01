//
//  MTJ_04_KeyMapping.swift
//  KakaJSONTests
//
//  Created by MJ Lee on 2019/8/13.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

class MTJ_04_KeyMapping: XCTestCase {
    struct Dog: Convertible {
        var nickName: String = "Wang"
        var price: Double = 100.6
        
        func kk_JSONKey(from property: Property) -> JSONKey {
            switch property.name {
            case "nickName": return "_nick_name_"
            default: return property.name
            }
        }
    }
    
    func test() {
        let dog = Dog()
        XCTAssert(dog.kk.JSON()?["_nick_name_"] != nil)
        XCTAssert(dog.kk.JSONString()?.contains("_nick_name_") == true)
    }
}
