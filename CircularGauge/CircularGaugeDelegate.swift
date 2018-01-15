//
//  CircularGaugeDelegate.swift
//  CircularGauge
//
//  Copyright (c) 2017 ARHS-Spikeseed
//

import UIKit

public protocol CircularGaugeDelegate: class {
    func finishedUpdatingProgress(forRing ring: CircularGaugeView)
    func didUpdateProgressValue(to newValue: CGFloat)
    func clickedOnImageLayer(forRing ring: CircularGaugeView)
    func clickedOnValueLabel(forRing ring: CircularGaugeView)
}

public extension CircularGaugeDelegate {
    // Adds default conformance with an empty method stub
    func didUpdateProgressValue(to newValue: CGFloat) { }
}
