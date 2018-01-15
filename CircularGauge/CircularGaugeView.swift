//
//  CircularGaugeView.swift
//  CircularGauge
//
//  Copyright (c) 2017 Clement DEUST
//

import UIKit

public enum CircularGaugeAddonType {
    case information(tint: UIColor)
    case hamburger(tint: UIColor)
}

@IBDesignable open class CircularGaugeView: UIView {
    
    // MARK: Delegate
    
    open weak var delegate: CircularGaugeDelegate?
    
    // MARK: Value Properties
    
    @IBInspectable open var value: CGFloat = 0 {
        didSet {
            self.gaugeLayer.value = self.value
        }
    }
    
    open var currentValue: CGFloat? {
        get {
            if isAnimating {
                return self.layer.presentation()?.value(forKey: "value") as? CGFloat
            } else {
                return self.value
            }
        }
    }
    
    @IBInspectable open var minValue: CGFloat = 0 {
        didSet {
            self.gaugeLayer.minValue = self.minValue
        }
    }
    
    @IBInspectable open var maxValue: CGFloat = 100 {
        didSet {
            self.gaugeLayer.maxValue = self.maxValue
        }
    }
    
    // MARK: View Style
    
    @IBInspectable open var fullCircle: Bool = true {
        didSet {
            self.gaugeLayer.fullCircle = self.fullCircle
        }
    }
    
    
    @IBInspectable open var ringStyle: CircularGaugeStyle = .inside {
        didSet {
            self.gaugeLayer.ringStyle = self.ringStyle
        }
    }
    
    open var patternForDashes: [CGFloat] = [7.0, 7.0] {
        didSet {
            self.gaugeLayer.patternForDashes = self.patternForDashes
        }
    }
    
    @IBInspectable open var gaugeStartAngle: CGFloat = 270 {
        didSet {
            self.gaugeLayer.gaugeStartAngle = self.gaugeStartAngle
        }
    }
    
    @IBInspectable open var gaugeEndAngle: CGFloat = 630 {
        didSet {
            self.gaugeLayer.gaugeEndAngle = self.gaugeEndAngle
        }
    }
    
    open var gradientColors: [UIColor] = [UIColor]() {
        didSet {
            self.gaugeLayer.gradientColors = self.gradientColors
        }
    }
    
    open var gradientColorLocations: [CGFloat]? = nil {
        didSet {
            self.gaugeLayer.gradientColorLocations = self.gradientColorLocations
        }
    }
    
    @IBInspectable open var gradientStartPosition: CircularGaugeGradientPosition = .topRight {
        didSet {
            self.gaugeLayer.gradientStartPosition = self.gradientStartPosition
        }
    }

    @IBInspectable open var gradientEndPosition: CircularGaugeGradientPosition = .bottomLeft {
        didSet {
            self.gaugeLayer.gradientEndPosition = self.gradientEndPosition
        }
    }
    
    // MARK: Outer Ring properties
    
    @IBInspectable open var backGaugeWidth: CGFloat = 10.0 {
        didSet {
            self.gaugeLayer.backGaugeWidth = self.backGaugeWidth
        }
    }
    
    @IBInspectable open var backGaugeColor: UIColor = UIColor.gray {
        didSet {
            self.gaugeLayer.backGaugeColor = self.backGaugeColor
        }
    }
    
    @IBInspectable open var backGaugeCapStyle: Int = 1 {
        didSet {
            switch self.backGaugeCapStyle{
            case 1:
                self.backStyle = .butt
                self.gaugeLayer.backGaugeCapStyle = .butt
            case 2:
                self.backStyle = .round
                self.gaugeLayer.backGaugeCapStyle = .round
            case 3:
                self.backStyle = .square
                self.gaugeLayer.backGaugeCapStyle = .square
            default:
                self.backStyle = .butt
                self.gaugeLayer.backGaugeCapStyle = .butt
            }
        }
    }
    
    internal var backStyle: CGLineCap = .butt
    
    // MARK: Inner Ring properties
    
    @IBInspectable open var topGaugeWidth: CGFloat = 5.0 {
        didSet {
            self.gaugeLayer.topGaugeWidth = self.topGaugeWidth
        }
    }
    
    @IBInspectable open var topGaugeColor: UIColor = UIColor.blue {
        didSet {
            self.gaugeLayer.topGaugeColor = self.topGaugeColor
        }
    }
    
    @IBInspectable open var topGaugeSpacing: CGFloat = 1 {
        didSet {
            self.gaugeLayer.topGaugeSpacing = self.topGaugeSpacing
        }
    }
    
    @IBInspectable open var topGaugeCapStyle: Int = 2 {
        didSet {
            switch self.topGaugeCapStyle {
            case 1:
                self.topStyle = .butt
                self.gaugeLayer.topGaugeCapStyle = .butt
            case 2:
                self.topStyle = .round
                self.gaugeLayer.topGaugeCapStyle = .round
            case 3:
                self.topStyle = .square
                self.gaugeLayer.topGaugeCapStyle = .square
            default:
                self.topStyle = .butt
                self.gaugeLayer.topGaugeCapStyle = .butt
            }
        }
    }
    
    internal var topStyle: CGLineCap = .round
    
    // MARK: Label
    
    @IBInspectable open var shouldShowValueText: Bool = true {
        didSet {
            self.gaugeLayer.shouldShowValueText = self.shouldShowValueText
        }
    }
    
    @IBInspectable open var fontColor: UIColor = UIColor.black {
        didSet {
            self.gaugeLayer.fontColor = self.fontColor
        }
    }
    
    @IBInspectable open var font: UIFont = UIFont.systemFont(ofSize: 18) {
        didSet {
            self.gaugeLayer.font = self.font
        }
    }
    
    @IBInspectable open var valueIndicator: String = "%" {
        didSet {
            self.gaugeLayer.valueIndicator = self.valueIndicator
        }
    }
    
    @IBInspectable open var showFloatingPoint: Bool = false {
        didSet {
            self.gaugeLayer.showFloatingPoint = self.showFloatingPoint
        }
    }
    
    @IBInspectable open var decimalPlaces: Int = 2 {
        didSet {
            self.gaugeLayer.decimalPlaces = self.decimalPlaces
        }
    }
    
    @IBInspectable open var segmentNumber: Int = 2 {
        didSet {
            self.gaugeLayer.segmentNumber = self.segmentNumber
        }
    }
    
    @IBInspectable open var hasButton: Bool = true {
        didSet {
            self.gaugeLayer.hasButton = self.hasButton
        }
    }
    
    @IBInspectable open var clockwise: Bool = true {
        didSet {
            self.gaugeLayer.clockwise = self.clockwise
        }
    }
    
    // MARK: Animation properties
    
    open var animationStyle: String = kCAMediaTimingFunctionEaseIn {
        didSet {
            self.gaugeLayer.animationStyle = self.animationStyle
        }
    }
    
    open var isAnimating: Bool {
        get { return (self.layer.animation(forKey: "value") != nil) ? true : false }
    }
    
    // MARK: Layer
    
    internal var gaugeLayer: CircularGaugeLayer {
        return self.layer as! CircularGaugeLayer
    }
    
    override open class var layerClass: AnyClass {
        get {
            return CircularGaugeLayer.self
        }
    }
    
    fileprivate var imageColor: UIColor = UIColor.white
    fileprivate var isShowingImage: Bool = false
    fileprivate var imageAnimationDuration: Double = 0.3
    fileprivate var imageProgress: Double = 0.5
    fileprivate var tipImage: UIImage = UIImage()
    fileprivate let trackLayer: CAShapeLayer = CAShapeLayer()
    fileprivate let circleLayer: CAShapeLayer = CAShapeLayer()
    fileprivate let tipLayer: CAShapeLayer = CAShapeLayer()
    fileprivate var imageLayer: CALayer = CALayer()
    fileprivate var imageStartAngle: CGFloat = CGFloat(Double.pi * -0.5)
    fileprivate var imageFinalAngle: CGFloat {
        get { return CGFloat(2 * Double.pi * imageProgress) + CGFloat(Double.pi * -0.5) }
    }
    
    open var informationImageWidth: CGFloat = 10.0
    
    // MARK: Methods
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        // Call the internal initializer
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Call the internal initializer
        initialize()
    }
    
    internal func initialize() {
        
        //self.gaugeLayer.valueDelegate = self
        
        self.layer.contentsScale = UIScreen.main.scale
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale * 2
        self.gaugeLayer.value = value
        self.gaugeLayer.maxValue = maxValue
        self.gaugeLayer.ringStyle = ringStyle
        self.gaugeLayer.patternForDashes = patternForDashes
        self.gaugeLayer.gradientColors = gradientColors
        self.gaugeLayer.gradientColorLocations = gradientColorLocations
        self.gaugeLayer.gradientStartPosition = gradientStartPosition
        self.gaugeLayer.gradientEndPosition = gradientEndPosition
        self.gaugeLayer.gaugeStartAngle = gaugeStartAngle
        self.gaugeLayer.gaugeEndAngle = gaugeEndAngle
        self.gaugeLayer.backGaugeWidth = backGaugeWidth
        self.gaugeLayer.backGaugeColor = backGaugeColor
        self.gaugeLayer.backGaugeCapStyle = backStyle
        self.gaugeLayer.topGaugeWidth = topGaugeWidth
        self.gaugeLayer.topGaugeColor = topGaugeColor
        self.gaugeLayer.topGaugeCapStyle = topStyle
        self.gaugeLayer.topGaugeSpacing = topGaugeSpacing
        self.gaugeLayer.shouldShowValueText = shouldShowValueText
        self.gaugeLayer.valueIndicator = valueIndicator
        self.gaugeLayer.fontColor = fontColor
        self.gaugeLayer.font = font
        self.gaugeLayer.showFloatingPoint = showFloatingPoint
        self.gaugeLayer.decimalPlaces = decimalPlaces
        self.gaugeLayer.segmentNumber = segmentNumber
        self.gaugeLayer.hasButton = hasButton
        
        self.backgroundColor = UIColor.clear
        self.gaugeLayer.backgroundColor = UIColor.clear.cgColor
        self.gaugeLayer.shouldRasterize = true
        self.gaugeLayer.rasterizationScale = UIScreen.main.scale
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    internal func didUpdateValue(newValue: CGFloat) {
        delegate?.didUpdateProgressValue(to: newValue)
    }
    
    public typealias ProgressCompletion = (() -> Void)
    
    open func setProgress(value: CGFloat, animationDuration: TimeInterval, completion: ProgressCompletion? = nil) {
        if isAnimating { self.layer.removeAnimation(forKey: "value") }
    
        self.gaugeLayer.animated = animationDuration > 0
        self.gaugeLayer.animationDuration = animationDuration
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.delegate?.finishedUpdatingProgress(forRing: self)
            completion?()
        }
        self.value = value
        self.gaugeLayer.value = value
        CATransaction.commit()
    }
    
    open func show(addons: CircularGaugeAddonType...) {
        for anAddon in addons {
            switch anAddon {
            case .information(let tint):
                imageColor = tint
                draw(tip: true, type: .information(tint: tint), imageWidth: informationImageWidth)
                isShowingImage = true
            case .hamburger(let tint):
                imageColor = tint
                draw(tip: true, type: .hamburger(tint: tint), imageWidth: informationImageWidth)
                isShowingImage = true
            }
        }
    }
    
    open func configure(duration: TimeInterval, progress: Double) {
        self.imageAnimationDuration = duration
        self.imageProgress = progress
        
        self.imageLayer.contents = nil
        self.buildCirclePath()
    }
    
    open func buildCirclePath() {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.setShouldAntialias(true)
        ctx.setAllowsAntialiasing(true)
        
        let progressCenter = CGPoint(x: self.gaugeLayer.frame.size.width * 0.5, y: self.gaugeLayer.frame.size.height * 0.5)
        let radius = (self.gaugeLayer.frame.size.width - (informationImageWidth * 0.5)) * 0.5
        
        var circlePath = UIBezierPath()
        if self.clockwise == true {
            circlePath = UIBezierPath(arcCenter: progressCenter,
                                          radius: radius,
                                          startAngle: imageStartAngle,
                                          endAngle: imageFinalAngle,
                                          clockwise: clockwise)
        } else {
            circlePath = UIBezierPath(arcCenter: progressCenter,
                                          radius: radius,
                                          startAngle: CGFloat(2 * Double.pi * 100) + CGFloat(Double.pi * -0.5),
                                          endAngle: CGFloat(2 * Double.pi * 100) + CGFloat(Double.pi * -0.5) - imageFinalAngle + CGFloat(Double.pi * -0.5),
                                          clockwise: clockwise)
        }
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineWidth = informationImageWidth - 2
        circleLayer.strokeEnd = 0.0
        circleLayer.strokeColor = UIColor.clear.cgColor
        circleLayer.lineCap = kCALineCapRound
        circleLayer.shouldRasterize = true
        circleLayer.rasterizationScale = UIScreen.main.scale * 2
        
        self.gaugeLayer.addSublayer(circleLayer)
        
        UIGraphicsEndImageContext()
    }
    
    open func draw(tip: Bool, type: CircularGaugeAddonType, imageWidth: CGFloat) {
        if tip {
            self.imageLayer.bounds = CGRect(x: self.gaugeLayer.frame.origin.x, y: self.gaugeLayer.frame.origin.y, width: imageWidth, height: imageWidth)
            self.imageLayer.contents = imageType(type).cgImage
            self.imageLayer.contentsGravity = kCAGravityResize
            self.imageLayer.backgroundColor = UIColor.clear.cgColor
            self.imageLayer.name = "imageLayer"
            self.imageLayer.shouldRasterize = true
            self.imageLayer.rasterizationScale = UIScreen.main.scale * 2
            self.layer.addSublayer(self.imageLayer)
        } else {
            if self.imageLayer.superlayer != nil { self.imageLayer.removeFromSuperlayer() }
        }
    }
    
    private func imageType(_ type: CircularGaugeAddonType) -> UIImage {
        switch type {
            case .information:
                self.tipImage = UIImage(named: "information", in: Bundle.main, compatibleWith: nil)!
            case .hamburger:
                self.tipImage = UIImage(named: "hamburger", in: Bundle.main, compatibleWith: nil)!
        }
        UIGraphicsBeginImageContextWithOptions(self.tipImage.size, false, UIScreen.main.scale)
        
        let context = UIGraphicsGetCurrentContext()!
        imageColor.setFill()
        
        context.translateBy(x: 0, y: self.tipImage.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        context.setBlendMode(CGBlendMode.colorBurn)
        
        let rect = CGRect(x: 0, y: 0, width: self.tipImage.size.width, height: self.tipImage.size.height)
        context.draw(self.tipImage.cgImage!, in: rect)
        
        context.setBlendMode(CGBlendMode.sourceIn)
        context.addRect(rect)
        context.drawPath(using: CGPathDrawingMode.fill)
        context.setShouldAntialias(true)
        context.setAllowsAntialiasing(true)
        
        let tintedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return tintedImage
    }
    
    open func animate() {
        CATransaction.begin()
        CATransaction.setAnimationDuration(self.imageAnimationDuration)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(controlPoints: 0.2, 0.0, 0.1, 1.0))
        
        let circleAnimation = CABasicAnimation(keyPath: "strokeEnd")
        if self.clockwise == true {
            circleAnimation.fromValue = 0
            circleAnimation.toValue = 100
        } else {
            circleAnimation.fromValue = 100
            circleAnimation.toValue = 0
        }
        circleAnimation.isRemovedOnCompletion = false
        circleAnimation.isAdditive = true
        circleAnimation.fillMode = kCAFillModeBoth
        self.circleLayer.add(circleAnimation, forKey: "animate circle completion")
        
        if self.isShowingImage {
            let imagePositionAnimation = CAKeyframeAnimation(keyPath: "position")
            imagePositionAnimation.path = self.circleLayer.path
            imagePositionAnimation.calculationMode = kCAAnimationPaced
            imagePositionAnimation.isRemovedOnCompletion = false
            imagePositionAnimation.fillMode = kCAFillModeBoth
            self.imageLayer.add(imagePositionAnimation, forKey: "animate tip position")
            
            let imageRotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            if self.clockwise == true {
                imageRotationAnimation.fromValue = 0
            } else {
                imageRotationAnimation.fromValue = 100
            }
            imageRotationAnimation.isRemovedOnCompletion = false
            imageRotationAnimation.fillMode = kCAFillModeBoth
            self.imageLayer.add(imageRotationAnimation, forKey: "animate tip rotation")
            
            let imageOpacityAnimation = CAKeyframeAnimation(keyPath: "hidden")
            imageOpacityAnimation.values = [ true, false ]
            if self.clockwise == true  {
                imageOpacityAnimation.keyTimes = [ 0.0, self.imageAnimationDuration as NSNumber ]
            } else {
                imageOpacityAnimation.keyTimes = [ 100.0, self.imageAnimationDuration as NSNumber ]
            }
            imageOpacityAnimation.calculationMode = kCAAnimationDiscrete
            imageOpacityAnimation.duration = self.imageAnimationDuration
            self.imageLayer.add(imageOpacityAnimation, forKey: "animate tip opacity")
        }
        CATransaction.commit()
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var found = false
        for touch in touches {
            let point = touch.location(in: self)
            if let sublayers = self.gaugeLayer.sublayers {
                for layer in sublayers {
                    if let name = layer.name {
                        if name == "imageLayer" {
                            if (point.x >= (self.circleLayer.path?.currentPoint.x)! - (informationImageWidth/2)) && (point.x <= (self.circleLayer.path?.currentPoint.x)! + informationImageWidth) {
                                if (point.y >= (self.circleLayer.path?.currentPoint.y)! - (informationImageWidth/2)) && (point.y <= (self.circleLayer.path?.currentPoint.y)! + informationImageWidth) {
                                    self.delegate?.clickedOnImageLayer(forRing: self)
                                    found = true
                                }
                            }
                        }
                    }
                }
            } else {
                if let name = layer.name {
                    if name == "imageLayer" {
                        if (point.x >= (self.circleLayer.path?.currentPoint.x)! - (informationImageWidth/2)) && (point.x <= (self.circleLayer.path?.currentPoint.x)! + informationImageWidth) {
                            if (point.y >= (self.circleLayer.path?.currentPoint.y)! - (informationImageWidth/2)) && (point.y <= (self.circleLayer.path?.currentPoint.y)! + informationImageWidth) {
                                self.delegate?.clickedOnImageLayer(forRing: self)
                                found = true
                            }
                        }
                    }
                }
            }
        }
        if found == false {
            self.delegate?.clickedOnValueLabel(forRing: self)
        }
    }
}

