//
//  CircularGaugeLayer.swift
//  CircularGauge
//
//  Copyright (c) 2017 Clement DEUST
//

import UIKit

private extension CGFloat {
    var toRads: CGFloat { return self * CGFloat.pi / 180 }
}

private extension UILabel {
    func update(withValue value: CGFloat, valueIndicator: String, showsDecimal: Bool, decimalPlaces: Int) {
        if showsDecimal {
            self.text = String(format: "%.\(decimalPlaces)f", value) + "\(valueIndicator)"
        } else {
            self.text = "\(Int(value))\(valueIndicator)"
        }
        self.sizeToFit()
    }
}

class CircularGaugeLayer: CAShapeLayer {
    
    // MARK: Properties
    
    @NSManaged var value: CGFloat
    @NSManaged var minValue: CGFloat
    @NSManaged var maxValue: CGFloat
    
    @NSManaged var fullCircle: Bool
    @NSManaged var ringStyle: CircularGaugeStyle
    @NSManaged var patternForDashes: [CGFloat]
    
    @NSManaged var gradientColors: [UIColor]
    @NSManaged var gradientColorLocations: [CGFloat]?
    @NSManaged var gradientStartPosition: CircularGaugeGradientPosition
    @NSManaged var gradientEndPosition: CircularGaugeGradientPosition
    
    @NSManaged var gaugeStartAngle: CGFloat
    @NSManaged var gaugeEndAngle: CGFloat
    @NSManaged var backGaugeWidth: CGFloat
    @NSManaged var backGaugeColor: UIColor
    @NSManaged var backGaugeCapStyle: CGLineCap
    
    @NSManaged var topGaugeWidth: CGFloat
    @NSManaged var topGaugeColor: UIColor
    @NSManaged var topGaugeCapStyle: CGLineCap
    @NSManaged var topGaugeSpacing: CGFloat
    
    @NSManaged var shouldShowValueText: Bool
    @NSManaged var fontColor: UIColor
    @NSManaged var font: UIFont
    @NSManaged var valueIndicator: String
    @NSManaged var showFloatingPoint: Bool
    @NSManaged var decimalPlaces: Int
    @NSManaged var segmentNumber: Int
    @NSManaged var hasButton: Bool
    @NSManaged var clockwise: Bool
    
    var animationDuration: TimeInterval = 1.0
    var animationStyle: String = kCAMediaTimingFunctionEaseInEaseOut
    var animated = false
    @NSManaged weak var valueDelegate: CircularGaugeView?
    
    lazy private var valueLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    // MARK: Draw
    
    override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        drawOuterRing(context: ctx)
        drawInnerRing(context: ctx)
        drawLabelValue()
        if let updatedValue = self.value(forKey: "value") as? CGFloat {
            valueDelegate?.didUpdateValue(newValue: updatedValue)
        }
    }
    
    // MARK: Animation methods
    
    override class func needsDisplay(forKey key: String) -> Bool {
        if key == "value" {
            return true
        }
        
        return super.needsDisplay(forKey: key)
    }
    
    override func action(forKey event: String) -> CAAction? {
        if event == "value" && self.animated {
            let animation = CABasicAnimation(keyPath: "value")
            animation.fromValue = self.presentation()?.value(forKey: "value")
            animation.timingFunction = CAMediaTimingFunction(name: animationStyle)
            animation.duration = animationDuration
            return animation
        }
        
        return super.action(forKey: event)
    }
    
    
    // MARK: Helpers
    
    private func drawOuterRing(context: CGContext) {
        guard backGaugeWidth > 0 else { return }
        
        let width = bounds.width
        let height = bounds.width
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let outerRadius = max(width, height)/2 - backGaugeWidth/2
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        
        let outerPath = UIBezierPath(arcCenter: center,
                                     radius: outerRadius,
                                     startAngle: gaugeStartAngle.toRads,
                                     endAngle: gaugeEndAngle.toRads,
                                     clockwise: clockwise)
        
        outerPath.lineWidth = backGaugeWidth
        outerPath.lineCapStyle = backGaugeCapStyle
        
        // If the style is 3 or 4, make sure to draw either dashes or dotted path
        switch ringStyle {
            case .dashed:
                outerPath.setLineDash(patternForDashes, count: patternForDashes.count, phase: 0.0)
            case .dotted:
                outerPath.setLineDash([0, outerPath.lineWidth * 2], count: 2, phase: 0)
                outerPath.lineCapStyle = .round
            default:
                break
        }
        
        context.addPath(outerPath.cgPath)
        context.setLineCap(backGaugeCapStyle)
        context.setLineWidth(backGaugeWidth)
        context.setStrokeColor(backGaugeColor.cgColor)
        context.setBlendMode(CGBlendMode.normal)
        context.setShouldAntialias(true)
        context.setAllowsAntialiasing(true)
        context.setFlatness(0.1)
        context.strokePath()
        
        UIGraphicsEndImageContext()
    }
    
    private func drawInnerRing(context: CGContext) {
        guard topGaugeWidth > 0 else { return }
        
        let width = bounds.width
        let height = bounds.width
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        
        //Change angle to create segment
        let angleDiff: CGFloat = gaugeEndAngle.toRads - gaugeStartAngle.toRads
        let arcLenPerValue = angleDiff / CGFloat(maxValue)
        let innerEndAngle = arcLenPerValue * CGFloat(value) + gaugeStartAngle.toRads
        
        let radiusIn = max(width, height)/2 - backGaugeWidth/2
        let innerPath = UIBezierPath(arcCenter: center,
                                     radius: radiusIn,
                                     startAngle: gaugeStartAngle.toRads,
                                     endAngle: innerEndAngle,
                                     clockwise: clockwise)
        context.addPath(innerPath.cgPath)
        context.setLineCap(topGaugeCapStyle)
        context.setLineWidth(topGaugeWidth)
        context.setStrokeColor(topGaugeColor.cgColor)
        context.setBlendMode(CGBlendMode.normal)
        context.setShouldAntialias(true)
        context.setAllowsAntialiasing(true)
        context.setFlatness(0.1)
        context.strokePath()
        
        if ringStyle == .gradient && gradientColors.count > 1 {
            // Create gradient and draw it
            var cgColors: [CGColor] = [CGColor]()
            for color: UIColor in gradientColors {
                cgColors.append(color.cgColor)
            }
            
            guard let gradient: CGGradient = CGGradient(colorsSpace: nil, colors: cgColors as CFArray, locations: gradientColorLocations) else {
                    fatalError("\nUnable to create gradient for progress ring.\n" + "Check values of gradientColors and gradientLocations.\n")
            }
            
            context.saveGState()
            context.addPath(innerPath.cgPath)
            context.replacePathWithStrokedPath()
            context.clip()
            
            drawGradient(gradient, start: gradientStartPosition, end: gradientEndPosition, inContext: context)
            
            context.restoreGState()
        }
        
        UIGraphicsEndImageContext()
    }
    
    private func drawGradient(_ gradient: CGGradient, start: CircularGaugeGradientPosition, end: CircularGaugeGradientPosition, inContext ctx: CGContext) {
        ctx.drawLinearGradient(gradient, start: start.pointForPosition(in: bounds), end: end.pointForPosition(in: bounds), options: .drawsBeforeStartLocation)
        ctx.setAllowsAntialiasing(true)
        ctx.setShouldAntialias(true)
    }
    
    private func drawLabelValue() {
        guard shouldShowValueText else { return }
        
        // Draws the text field
        // Some basic label properties are set
        valueLabel.font = self.font
        valueLabel.textAlignment = .center
        valueLabel.textColor = fontColor
        
        valueLabel.update(withValue: value,
                          valueIndicator: valueIndicator,
                          showsDecimal: showFloatingPoint,
                          decimalPlaces: decimalPlaces)
        
        // Deterime what should be the center for the label
        valueLabel.center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        valueLabel.drawText(in: self.bounds)
    }
}

