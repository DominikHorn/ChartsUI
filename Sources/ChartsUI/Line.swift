//
//  LineChart.swift
//
//  Created by Dominik Horn on 3/22/20.
//  Copyright © 2020 Dominik Horn. All rights reserved.
//

import SwiftUI

public struct LineData: Identifiable {
    public var id: UUID = UUID()
    
    public let label: String?
    public let x: CGFloat
    public let y: CGFloat
    
    public init(x: CGFloat, y: CGFloat, label: String? = nil) {
        self.x = x
        self.y = y
        self.label = label
    }
}

@available(iOS 13.0, tvOS 13.0, macOS 10.15.0, *)
public struct Line: ChartView {
    public var id: UUID
    
    let data: [LineData]
    
    public init(data: [LineData]) {
        self.data = data
        self.id = UUID()
    }

    private func translate(data: [LineData], forAvailableSpace space: CGSize) -> [LineData] {
        guard let minY = data.min(by: { (a, b) in a.y < b.y })?.y,
            let maxY = data.max(by: { (a, b) in a.y < b.y })?.y else {
            return []
        }
        let height = maxY - minY
        guard height > 0 else {
            return []
        }
        let scaleFactor = CGPoint(
            x: space.width / CGFloat(self.data.count - 1),
            y: space.height / height
        )
        let offset = CGPoint(x: 0, y: -minY * scaleFactor.y)
        return self.data.map { dat in
            LineData(
                x: dat.x * scaleFactor.x + offset.x,
                y: dat.y * scaleFactor.y + offset.y,
                label: dat.label
            )
        }
    }
    
    private func withProxy(_ proxy: GeometryProxy) -> some View {
        let translated = self.translate(data: self.data, forAvailableSpace: proxy.size)
        let points = translated.map { CGPoint(x: $0.x, y: $0.y) }
        let labels = translated.filter { dat in dat.label != nil }
        
        return ZStack {
            Path { path in
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

            ForEach(labels) { dat in
                Text(dat.label!)
                    .position(x: dat.x, y: dat.y)
                    .zIndex(.infinity)
            }
        }
    }
    
    public var body: some View {
        guard self.data.count > 0 else {
            return AnyView(Text("ChartDataError"))
        }
        
        return AnyView(
            GeometryReader { geo in
                self.withProxy(geo)
            }
        )
    }
}
