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
}
