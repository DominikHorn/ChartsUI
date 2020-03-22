//
//  LineChart.swift
//
//  Created by Dominik Horn on 3/22/20.
//  Copyright © 2020 Dominik Horn. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, tvOS 13.0, macOS 10.15.0, *)
public struct LineChart: View {
    let data: [CGPoint]
    
    public init(data: [CGPoint]) {
        self.data = data
    }

    private func coordinate(forData data: CGPoint, scaleFactor: CGPoint, offset: CGPoint) -> CGPoint {
        return CGPoint(
            x: data.x * scaleFactor.x + offset.x,
            y: data.y * scaleFactor.y + offset.y
        )
    }
    
    public var body: some View {
        guard let minY = data.min(by: { (a, b) in a.y < b.y })?.y,
            let maxY = data.max(by: { (a, b) in a.y < b.y })?.y else {
            return AnyView(Text("ChartDataError"))
        }
        let height = maxY - minY
        guard height > 0 else {
            return AnyView(Text("ChartDataError"))
        }
        
        return AnyView(
            HStack {
                Spacer()
                
                VStack {
                    Spacer()
                    
                    GeometryReader { geo in
                        Path { path in
                            let scaleFactor = CGPoint(
                                x: geo.size.width / CGFloat(self.data.count - 1),
                                y: geo.size.height / height
                            )
                            let offset = CGPoint(x: 0, y: -minY * scaleFactor.y)
                            let points = self.data.map { dat in
                                self.coordinate(
                                    forData: dat,
                                    scaleFactor: scaleFactor,
                                    offset: offset
                                )
                            }
                            
                            path.addLines(points)
                        }
                        .strokedPath(.init(
                            lineWidth: 2,
                            lineCap: .round,
                            lineJoin: .round,
                            miterLimit: 0,
                            dash: [],
                            dashPhase: 0)
                        )
                        .foregroundColor(.accentColor)
                    }
                    
                    Spacer()
                }
                
                Spacer()
            }
        )
    }
}
