//
//  CASliceLayer.swift
//  PieChart
//
//  Created by Victor Obretin on 2017-03-13.
//  Copyright © 2017 Victor Obretin. All rights reserved.
//

import UIKit

class CASliceLayer: CAShapeLayer {
    
    private var _percentageValue: CGFloat = 0.0
    private var _startingValue: CGFloat = 0.0
    private var _gapWidth: CGFloat = 0.0
    private var _sliceRadius: CGFloat = 0.0
    private var _hollowRadius: CGFloat = 0.0
    private var _sliceColor: UIColor = UIColor.white
    private var _currentScale: CGFloat = 1.05
    
    private var _sliceLayer: CAShapeLayer? = nil
    private var _maskLayer: CAShapeLayer? = nil
    
    private let kStartAngle: CGFloat = -CGFloat.pi / 2.0
    private let kEndAngle: CGFloat = -CGFloat.pi / 2.0 + 2 * CGFloat.pi
    
    public var percentageValue: CGFloat {
        get {
            return _percentageValue
        }
        set {
            _percentageValue = newValue
            drawSlice()
        }
    }
    
    public var startingValue: CGFloat {
        get {
            return _startingValue
        }
        set {
            _startingValue = newValue
            drawSlice()
        }
    }
    
    public var gapWidth: CGFloat {
        get {
            return _gapWidth
        }
        set {
            _gapWidth = newValue
            drawSlice()
        }
    }
    
    public var sliceRadius: CGFloat {
        get {
            return _sliceRadius
        }
        set {
            _sliceRadius = newValue
            drawSlice()
        }
    }
    
    public var hollowRadius: CGFloat {
        get {
            return _hollowRadius
        }
        set {
            _hollowRadius = newValue
            if (_hollowRadius > _sliceRadius) {
                _hollowRadius = _sliceRadius
            }
            drawSlice()
        }
    }
    
    public var sliceColor: UIColor {
        get {
            return _sliceColor
        }
        set {
            _sliceColor = newValue
            drawSlice()
        }
    }
    
    override func layoutSublayers() {
        self.lineJoin = kCALineCapButt
        drawSlice()
    }
    
    internal func drawSlice() {
        if (_percentageValue <= 0) {
            self.path = nil
            return
        }
        
        let originPoint: CGPoint = CGPoint(x: self.bounds.width / 2.0, y: self.bounds.height / 2.0)
        
        let absoluteRadius: CGFloat = getAbsoluteRadius()
        let absoluteHollowRadius: CGFloat = getAbsoluteHollowRadius()
        
        let pathRadius: CGFloat = absoluteHollowRadius + (absoluteRadius - absoluteHollowRadius) / 2.0
        let circlePath = UIBezierPath(arcCenter: originPoint, radius: pathRadius, startAngle: kStartAngle, endAngle: kEndAngle, clockwise: true)
        
        if (_sliceLayer == nil) {
            _sliceLayer = CAShapeLayer()
            self.addSublayer(_sliceLayer!)
        }
        
        _sliceLayer?.frame = self.bounds
        _sliceLayer?.path = circlePath.cgPath
        _sliceLayer?.lineJoin = kCALineCapButt
        _sliceLayer?.fillColor = UIColor.clear.cgColor
        _sliceLayer?.lineWidth = absoluteRadius - absoluteHollowRadius
        _sliceLayer?.strokeStart = _startingValue
        _sliceLayer?.strokeEnd = _startingValue + _percentageValue
        
        if (_maskLayer == nil) {
            _maskLayer = CAShapeLayer()
            _sliceLayer?.mask = _maskLayer!
        }
        
        _maskLayer?.frame = self.bounds
        _maskLayer?.path = UIBezierPath(arcCenter: originPoint, radius: getMaxRadius() / 2.0, startAngle: kStartAngle, endAngle: kEndAngle, clockwise: true).cgPath
        _maskLayer?.lineJoin = kCALineCapButt
        _maskLayer?.fillColor = UIColor.clear.cgColor
        _maskLayer?.lineWidth = getMaxRadius()
        _maskLayer?.strokeStart = _startingValue
        _maskLayer?.strokeEnd = _startingValue + _percentageValue
        _maskLayer?.strokeColor = UIColor.white.cgColor
        _maskLayer?.position = getMaskOrigin()
        
        self.rasterizationScale = UIScreen.main.scale
        self.shouldRasterize = true
    }
    
    internal func drawSliceForInterfaceBuilder() {
        if (_percentageValue <= 0) {
            self.path = nil
            return
        }
        
        let originPoint: CGPoint = CGPoint(x: self.bounds.width / 2.0, y: self.bounds.height / 2.0)
        
        let absoluteRadius: CGFloat = getAbsoluteRadius()
        let absoluteHollowRadius: CGFloat = getAbsoluteHollowRadius()
        
        let pathRadius: CGFloat = absoluteHollowRadius + (absoluteRadius - absoluteHollowRadius) / 2.0
        let circlePath = UIBezierPath(arcCenter: originPoint, radius: pathRadius, startAngle: kStartAngle, endAngle: kEndAngle, clockwise: true)
        
        if (_sliceLayer == nil) {
            _sliceLayer = CAShapeLayer()
            self.addSublayer(_sliceLayer!)
        }
        
        self.path = circlePath.cgPath
        self.lineJoin = kCALineCapButt
        self.fillColor = UIColor.clear.cgColor
        self.lineWidth = absoluteRadius - absoluteHollowRadius
        self.strokeStart = _startingValue
        self.strokeEnd = _startingValue + _percentageValue
    }
    
    func scaleInTo(sliceData: SliceData) {
        _percentageValue = sliceData.percentageValue
        _startingValue = sliceData.startingValue
        _gapWidth = sliceData.gapWidth
        _sliceRadius = sliceData.sliceRadius
        _hollowRadius = sliceData.hollowRadius
        
        drawSlice()
        
        _sliceLayer!.strokeColor = sliceData.sliceColor.cgColor
        self.transform = CATransform3DMakeScale(0.0, 0.0, 0.0)
        
        self.removeAllAnimations()
        
        let scaleAnimation:CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = _currentScale
        scaleAnimation.toValue = 1.0
        _currentScale = 1.0
        
        let opacityAnimation:CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 0.0
        opacityAnimation.toValue = 1.0
        
        let animationGroup: CAAnimationGroup = CAAnimationGroup()
        animationGroup.animations = [scaleAnimation, opacityAnimation]
        animationGroup.beginTime = CACurrentMediaTime() + sliceData.fadeInDelay
        animationGroup.duration = sliceData.fadeInDuration
        animationGroup.repeatCount = 0
        animationGroup.fillMode = kCAFillModeForwards
        animationGroup.isRemovedOnCompletion = false;
        animationGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        self.add(animationGroup, forKey: "animationGroup")
    }
    
    func offsetBy(ratio: CGFloat, duration: Double, delay: Double) {
        let middleAngle: CGFloat = getMiddleAngle()
        let displacementRadius: CGFloat = getMaxRadius() * ratio
        
        let xDisplacement = displacementRadius * cos(middleAngle)
        let yDisplacement = displacementRadius * sin(middleAngle)
        let displacementPoint: CGPoint = CGPoint(x: xDisplacement + self.bounds.width / 2.0, y: yDisplacement + self.bounds.height / 2.0)
        
        let moveAnimation:CABasicAnimation = CABasicAnimation(keyPath: "position")
        moveAnimation.fromValue = self.position
        moveAnimation.toValue = displacementPoint
        moveAnimation.beginTime = CACurrentMediaTime() + delay
        moveAnimation.duration = duration
        moveAnimation.repeatCount = 0
        moveAnimation.fillMode = kCAFillModeForwards
        moveAnimation.isRemovedOnCompletion = false;
        moveAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.add(moveAnimation, forKey: "position")
    }
    
    func getMiddleAngle() -> CGFloat {
        return ((_startingValue + _percentageValue / 2.0) * 2.0 * CGFloat.pi) + kStartAngle
    }
    
    func getMaskOrigin() -> CGPoint {
        let middleAngle: CGFloat = getMiddleAngle()
        let displacementRadius: CGFloat = getDisplacementRadius()
        
        let xDisplacement = displacementRadius * cos(middleAngle)
        let yDisplacement = displacementRadius * sin(middleAngle)
        
        return CGPoint(x: xDisplacement + self.bounds.width / 2.0, y: yDisplacement + self.bounds.height / 2.0)
    }
    
    func getMaxRadius() -> CGFloat {
        return min(self.bounds.width, self.bounds.height) * 0.5
    }
    
    func getAbsoluteRadius() -> CGFloat {
        return getMaxRadius() * _sliceRadius
    }
    
    func getAbsoluteHollowRadius() -> CGFloat {
        return getMaxRadius() * _hollowRadius
    }
    
    func getDisplacementRadius() -> CGFloat {
        let angle: CGFloat = _percentageValue * CGFloat.pi * 2.0
        return _gapWidth / (2.0 * sin(angle))
    }
    
    func getSliceData() -> SliceData {
        var sliceData: SliceData = SliceData()
        
        sliceData.percentageValue = percentageValue
        sliceData.startingValue = startingValue
        sliceData.gapWidth = gapWidth
        sliceData.sliceRadius = sliceRadius
        sliceData.hollowRadius = hollowRadius
        sliceData.sliceColor = sliceColor
        
        return sliceData
    }
}

struct SliceData {
    var percentageValue: CGFloat    = 0.0 // relative value from 0 to 1
    var startingValue: CGFloat      = 0.0 // relative value from 0 to 1
    var gapWidth: CGFloat           = 0.0 // points
    var sliceRadius: CGFloat        = 0.0 // relative value from 0 to 1
    var hollowRadius: CGFloat       = 0.0 // relative value from 0 to 1
    var sliceColor: UIColor         = UIColor.white
    var fadeInDuration: Double      = 0.0
    var fadeInDelay: Double         = 0.0
    
    func getEndValue() -> CGFloat {
        return startingValue + percentageValue
    }
}
