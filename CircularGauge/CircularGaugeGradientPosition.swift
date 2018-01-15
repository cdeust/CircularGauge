//
//  CircularGaugeGradientPosition.swift
//  CircularGauge
//
//  Copyright (c) 2017 Clement DEUST
//

import Foundation
import UIKit

@objc public enum CircularGaugeGradientPosition: Int {
    case top = 1
    case bottom = 2
    case left = 3
    case right = 4
    case topLeft = 5
    case topRight = 6
    case bottomLeft = 7
    case bottomRight = 8 
    
    func pointForPosition(in rect: CGRect) -> CGPoint {
        switch self {
            case .top:
                return CGPoint(x: rect.midX, y: rect.minY)
            case .bottom:
                return CGPoint(x: rect.midX, y: rect.maxY)
            case .left:
                return CGPoint(x: rect.minX, y: rect.midY)
            case .right:
                return CGPoint(x: rect.maxX, y: rect.midY)
            case .topLeft:
                return CGPoint(x: rect.minX, y: rect.minY)
            case .topRight:
                return CGPoint(x: rect.maxX, y: rect.minY)
            case .bottomLeft:
                return CGPoint(x: rect.minX, y: rect.maxY)
            case .bottomRight:
                return CGPoint(x: rect.maxX, y: rect.maxY)
        }
    }
}
