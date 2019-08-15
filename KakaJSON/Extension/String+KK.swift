//
//  String+KK.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/5.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

extension String: KKCompatible {}

public extension KK where Base: ExpressibleByStringLiteral {
    /// from underline-cased to camel-cased
    ///
    /// e.g. from `my_test_name` to `myTestName`
    func camelCased() -> String {
        guard let str = base as? String else { return "" }
        var newStr = ""
        var upper = false
        for c in str {
            if c == "_" {
                upper = true
                continue
            }
            
            if upper, newStr.count > 0 {
                //todo: vesion:1.0.2
                newStr.append(c.uppercased())
            } else {
                newStr.append(c)
            }
            upper = false
        }
        return newStr
    }
    
    /// from camel-cased to underline-cased
    ///
    /// e.g. from `myTestName` to `my_test_name`
    func underlineCased() -> String {
        guard let str = base as? String else { return "" }
        var newStr = ""
        //todo: vesion:1.0.2
        for c in str {
            if c >= "A",c <= "Z" {
                newStr.append("_")
    			newStr.append(c.lowercased())
            }else {
                newStr.append(c)
            }
        }
        return newStr
    }
    
    // MARK: - JSON -> Model
    func model<M: Convertible>(_ type: M.Type) -> M? {
        return model(anyType: type) as? M
    }
    
    func model(anyType: Any.Type) -> Any? {
        if let json = JSONSerialization.kk_JSON(base as? String, JSONObject.self) {
            return json.kk.model(anyType: anyType)
        }
        Logger.error("Failed to get JSON from JSONString.")
        return nil
    }
    
    func modelArray<M: Convertible>(_ type: M.Type) -> [M]? {
        return modelArray(anyType: type) as? [M]
    }
    
    func modelArray(anyType: Any.Type) -> [Any]? {
        if let json = JSONSerialization.kk_JSON(base as? String, [Any].self) {
            return json.kk.modelArray(anyType: anyType)
        }
        Logger.error("Failed to get JSON from JSONString.")
        return nil
    }
}

extension String {
    func kk_fastModel(_ type: Convertible.Type) -> Convertible? {
        if let json = JSONSerialization.kk_JSON(self, JSONObject.self) {
            return json.kk_fastModel(type)
        }
        Logger.error("Failed to get JSON from JSONString.")
        return nil
    }
}
