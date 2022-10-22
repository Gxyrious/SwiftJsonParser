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
