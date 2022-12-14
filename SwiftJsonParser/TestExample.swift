//
//  TestExample.swift
//  SwiftJsonParser
//
//  Created by 刘畅 on 2022/10/22.
//

import Foundation

class BaseResponse: JsonParsable{
  var status: ResponseStatus?
  var data: TeamInfo?
}

class ResponseStatus: JsonParsable {
  var code: NSNumber?
  var message: String?
}

class TeamInfo: JsonParsable {
    var school: String?
    var students: [Student]?
}

class Student: JsonParsable {
  var id: NSNumber?
  var name: String?
  var email: String?
}

class TestExample {
    
    public static var jsonString =
    """
    {
        "status":{
            "code":200,
            "message":"Successful"
        },
        "data":{
            "school":"Tongji University",
            "students":[
                {
                    "id":2054164,
                    "name":"Liu Chang",
                    "email":"2466445001@qq.com"
                },
                {
                    "id":2051971,
                    "name":"Xiao Xiaoyou",
                    "email":"2051971@tongji.edu.cn"
                },
                {
                    "id":2053769,
                    "name":"Cai Minghong",
                    "email":"null"
                }
            ]
        }
    }
    """
    
    public static var jsonDict: [String: Any] =
    [
        "status":[
            "code":200,
            "message":"Successful"
        ],
        "data":[
            "school":"Tongji University",
            "students":[
                [
                    "id":2054164,
                    "name":"Liu Chang",
                    "email":"2466445001@qq.com"
                ],
                [
                    "id":2051971,
                    "name":"Xiao Xiaoyou",
                    "email":"2051971@tongji.edu.cn"
                ],
                [
                    "id":2053769,
                    "name":"Cai Minghong",
                    "email":"null"
                ]
            ]
        ]
    ]
    
    public static func start() throws -> Void {
        let fromDictionary: BaseResponse = BaseResponse(dictionary: jsonDict)
        
        let fromJsonString: BaseResponse = try SwiftJsonParser.parse(string: jsonString)
        
        print("=====fromDictionary=====")
        print(fromDictionary.status!.code!)
        print(fromDictionary.status!.message!)
        print(fromDictionary.data!.school!)
        for student in fromDictionary.data!.students! {
            print("\(student.id!), \(student.name!), \(student.email!)")
        }
        print("=====fromDictionary=====\n")


        print("=====fromJsonString=====")
        print(fromJsonString.status!.code!)
        print(fromJsonString.status!.message!)
        print(fromJsonString.data!.school!)
        for student in fromJsonString.data!.students! {
            print("\(student.id!), \(student.name!), \(student.email!)")
        }
        print("=====fromJsonString=====\n")
        
        print("=====toJsonString=====")
        let generatedJsonString = try SwiftJsonParser.getJson(object: fromDictionary)
        print(generatedJsonString)
        print("=====toJsonString=====\n")
        
        print("=====toDictionary=====")
        let generatedDictionary = try SwiftJsonParser.getDictionary(object: fromDictionary)
        print(generatedDictionary)
        print("=====toDictionary=====\n")
    }
}
