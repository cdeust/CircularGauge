//
//  CircularGaugeDelegate.swift
//  CircularGauge
//
//  Copyright (c) 2017 ARHS-Spikeseed
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is furnished
//  to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
//  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
//  FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT
//  OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
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
