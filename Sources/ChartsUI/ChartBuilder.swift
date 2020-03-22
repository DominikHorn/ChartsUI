//
//  File.swift
//  
//
//  Created by Dominik Horn on 3/22/20.
//

import Foundation

@_functionBuilder
public struct ChartBuilder {
    public static func buildBlock(_ strings: String...) -> String {
        return strings.reduce("", {(a, c) in a + c })
    }
}


public struct Chart {
    public let content: String
    
    public init(@ChartBuilder builder: () -> String) {
        self.content = builder()
    }
}
