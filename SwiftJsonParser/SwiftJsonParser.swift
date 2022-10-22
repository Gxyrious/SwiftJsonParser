//
//  SwiftJsonParser.swift
//  SwiftJsonParser
//
//  Created by 刘畅 on 2022/10/21.
//

import Foundation

public protocol JsonKeyCoder {
    func key(for key: String) -> String?
}

public class SwiftJsonParser {
    
    // 使用Json字符串解析Json实体
    public static func parse<Type: Dictable>(string: String) throws -> Type {
        return try self.parse(data: string.data(using: .utf8)!)
    }
    
    // 使用Data类型解析Json实体
    public static func parse<Type: Dictable>(data: Data) throws -> Type {
        return Type(dictionary: try JSONSerialization.jsonObject(with: data) as! [String: Any])
    }
    
    public static func getJson(object: Any) throws -> String {
        
        var objectToParse = object
                
        if let arrayObject = object as? Array<Any> {
            objectToParse = getDictionaryFromArray(array: arrayObject)
        } else {
            objectToParse = getDictionaryFromObject(object: object)
        }
        
        let jsonData = try JSONSerialization.data(withJSONObject: objectToParse)
        return String(data: jsonData, encoding: .utf8)!

    }
    
    public static func getDictionary(object: Any) throws -> [String: Any] {
        return getDictionaryFromObject(object: object)
    }
    
    static func getDictionaryFromObject(object: Any) -> [String: Any] {
        var dictionary: [String: Any] = [:]
        
        var mirror: Mirror? = Mirror(reflecting: object)
        repeat {
            for property in mirror!.children { // 遍历对象的属性
                let propertyName = property.label! // 获取属性名
                if let value = object as? JSONKeyCoder { // 获取属性值
                    if let userDefinedKeyName = value.key(for: propertyName) {
                        dictionary[userDefinedKeyName] = getValue(value: property.value)
                    } else {
                        dictionary[propertyName] = getValue(value: property.value)
                    }
                } else {
                    dictionary[propertyName] = getValue(value: property.value)
                }
                
            }
            mirror = mirror?.superclassMirror
        } while mirror != nil
        
        return dictionary
    }
    
    static func getDictionaryFromArray(array: [Any]) -> [Any] {
        var resultingArray: [Any] = []
        
        for element in array {
            let elementValue = getValue(value: element)
            resultingArray.append(elementValue)
        }
        
        return resultingArray
    }
    
    private static func getValue(value: Any) -> Any {
        if let numericValue = value as? NSNumber {
            return numericValue
        } else if let boolValue = value as? Bool {
            return boolValue
        } else if let stringValue = value as? String {
            return stringValue
        } else if let arrayValue = value as? Array<Any> {
            return getDictionaryFromArray(array: arrayValue)
        } else {
            let dictionary = getDictionaryFromObject(object: value)
            if dictionary.count == 0 {
                return NSNull()
            } else {
                return dictionary
            }
        }
    }
}

public protocol JSONKeyCoder {
    
    func key(for key: String) -> String?
    
}
