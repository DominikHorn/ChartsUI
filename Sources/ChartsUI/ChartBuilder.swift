//
//  File.swift
//  
//
//  Created by Dominik Horn on 3/22/20.
//

import SwiftUI

@available(iOS 13.0, tvOS 13.0, macOS 10.15.0, *)
@_functionBuilder
public struct ChartBuilder {
    public static func buildBlock<Content>(_ views: Content...) -> some View where Content : ChartView {
        ZStack {
            ForEach(views) { $0 }
        }
    }
}

public protocol ChartView: View, Identifiable {}

public protocol ChartContainer: View {}

@available(iOS 13.0, tvOS 13.0, macOS 10.15.0, *)
public struct Chart<Content: ChartView>: ChartContainer {
    public var body: Content
    
    public typealias Body = Content
    
    @inlinable public init(@ChartBuilder builder: () -> Content) {
        self.body = builder()
    }
}

/*
 Feature list:
 * Configurable Axis
 * Line, Bar, Pie chart
 */
