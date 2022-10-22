//
//  main.swift
//  SwiftJsonParser
//
//  Created by 刘畅 on 2022/10/21.
//

import Foundation

var jsonString =
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
                "id":1002,
                "name":"Demo Employee",
                "email":"abc@def.com"
            }
        ]
    }
}
"""

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

var jsonDict: [String: Any] =
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
                "id":1002,
                "name":"Demo Employee",
                "email":"abc@def.com"
            ]
        ]
    ]
]

let testResponse: BaseResponse = BaseResponse(dictionary: jsonDict)
print(testResponse.status!.code!)
print(testResponse.status!.message!)
print(testResponse.data!.school!)
for student in testResponse.data!.students! {
    print("\(student.id!), \(student.name!), \(student.email!)")
}



//do {
//  let baseResponse: BaseResponse = try JSONParserSwift.parse(string: jsonString)
//  // Use base response object here
//    let outputJson = try JSONParserSwift.getJSON(object: baseResponse)
//    print(outputJson)
//} catch {
//  print(error)
//}
