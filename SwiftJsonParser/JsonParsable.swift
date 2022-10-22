//
//  JsonParsable.swift
//  SwiftJsonParser
//
//  Created by 刘畅 on 2022/10/21.
//

import Foundation

@objcMembers
open class JsonParsable: NSObject, Dictable {
    public required init(dictionary: [String : Any]) {
        super.init()
        // 使用swift中的反射机制
        var mirror: Mirror? = Mirror(reflecting: self)
        repeat {
            for property in mirror!.children {
                // typealias Mirror.Children = (label: String?, value: Any)
                // 遍历类的属性，依次初始化
                initialize(for: property, dictionary: dictionary)
            }
            mirror = mirror?.superclassMirror // 继续初始化父类
        } while mirror != nil
    }
    
    private func initialize(for property: Mirror.Child, dictionary: [String: Any]) {
        if let propertyName = property.label {
            if let value = dictionary[propertyName] {
                // 在初始化字典中寻找对应的属性
                if let dictionaryValue = value as? [String: Any] {
                    // 如果某个属性的值仍然是个字典，说明是子对象，递归初始化
                    if let dynamicClass = getDynamicClassType(value: property.value) {
                        // getDynamicClassType返回一个动态类型，用该类型的required构造函数构造对象，再设置属性
                        let dynamicObject = dynamicClass.init(dictionary: dictionaryValue) // 迭代
                        self.setValue(dynamicObject, forKey: propertyName)
                    }
                } else if let arrayValue = value as? [Any] {
                    // 如果某个属性的值是个列表，则需要解析列表
//                    let parsedArray = parse(property: property, array: arrayValue)
                    var parsedArray = [Any]()
                    for element in arrayValue {
                        if let dictionaryValue = element as? [String: Any] {
                            if let dynamicClass = getDynamicClassType(value: property.value) {
                                let dynamicObject = dynamicClass.init(dictionary: dictionaryValue)
                                parsedArray.append(dynamicObject)
                            }
                        } else {
                            parsedArray.append(element)
                        }
                    }
                    self.setValue(parsedArray, forKey: propertyName)
                } else {
                    // 如果某个属性是简单值，则直接赋值
                    self.setValue(value, forKey: propertyName)
                }
            }
        }
    }
    
    private func getDynamicClassType(value: Any) -> Dictable.Type? {
        // 获取一个对象的类型，如果是Dictable则返回Dictable的extends类型，否则返回nil
        let dynamicType = getClassType(value: value)
        // NSClassFromString反射方法
        let dynamicClass = NSClassFromString(dynamicType) as? Dictable.Type // 尝试转换为Dictable，若失败的返回nil
        return dynamicClass
    }
    
    private func getClassType(value: Any) -> String {
        // 获取一个对象的类型字符串
        var dynamicType = String(reflecting: type(of: value)) // 用内置防阿福返回类型字符串
        // dynamicType = Swift.Optional<TestCMDSwiftJson.ResponseStatus> ==> TestCMDSwiftJson.ResponseStatus
        dynamicType = dynamicType.replacingOccurrences(of: "Swift.Optional<", with: "")
        dynamicType = dynamicType.replacingOccurrences(of: "Swift.Array<", with: "")
        dynamicType = dynamicType.replacingOccurrences(of: "Swift.ImplicitlyUnwrappedOptional<", with: "")
        dynamicType = dynamicType.replacingOccurrences(of: ">", with: "")
        return dynamicType
    }
    
}

public protocol Dictable: NSObjectProtocol {
    init(dictionary: [String: Any])
}
