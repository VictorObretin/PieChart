//
//  UIPieChartView.swift
//  PieChart
//
//  Created by Victor Obretin on 2017-03-13.
//  Copyright © 2017 Victor Obretin. All rights reserved.
//

import UIKit

@IBDesignable
class UIPieChartView: UIView {
    
    var slices: Array<CASliceLayer> = Array<CASliceLayer>()
    
    private var _sliceValues: Array<SliceData> = Array<SliceData>()
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setValues(values: getInterfaceBuilderData(), animated: false)
        
        for i in 0 ..< slices.count {
            slices[i].drawSliceForInterfaceBuilder()
        }
    }
    
    internal func setupComponent(animated: Bool = true) {

        while _sliceValues.count < slices.count {
            let sliceLayer: CASliceLayer? = slices.popLast()
            
            if (sliceLayer != nil) {
                sliceLayer?.removeAllAnimations()
                sliceLayer?.removeFromSuperlayer()
            }
        }
        
        if (_sliceValues.count > slices.count) {
            var startingValue: CGFloat = 0.0
            if (slices.count > 0 && animated) {
                startingValue = slices.last!.startingValue + slices.last!.percentageValue
            }
            
            for _ in slices.count ..< _sliceValues.count {
                let sliceLayer: CASliceLayer = CASliceLayer()
                sliceLayer.startingValue = startingValue
                sliceLayer.frame = self.bounds
                
                slices.append(sliceLayer)
                self.layer.addSublayer(sliceLayer)
            }
        }
        
        for i in 0 ..< slices.count {
            let sliceLayer: CASliceLayer = slices[i]
            let sliceData: SliceData = _sliceValues[i]
            
            if (animated) {
                sliceLayer.scaleInTo(sliceData: sliceData)
            } else {
                sliceLayer.percentageValue = sliceData.percentageValue
                sliceLayer.startingValue = sliceData.startingValue
                sliceLayer.gapWidth = sliceData.gapWidth
                sliceLayer.sliceRadius = sliceData.sliceRadius
                sliceLayer.hollowRadius = sliceData.hollowRadius
                sliceLayer.strokeColor = sliceData.sliceColor.cgColor
            }
        }
    }
    
    func offsetSlice(sliceIndex: Int, byRatio: CGFloat, duration: Double, delay: Double) {
        if (slices.count > 0 && sliceIndex >= 0 && sliceIndex < slices.count) {
            let slice: CASliceLayer = slices[sliceIndex]
            slice.offsetBy(ratio: byRatio, duration: duration, delay: delay)
        }
    }
    
    func setValues(values: Array<SliceData>? = nil, animated: Bool = true) {
        _sliceValues = Array<SliceData>()
        
        if (values != nil && values!.count > 0) {
            _sliceValues.append(contentsOf: values!)
        }
        
        setupComponent(animated: animated)
    }
    
    func clearSlices() {
        while slices.count > 0 {
            let sliceLayer: CASliceLayer? = slices.popLast()
            
            if (sliceLayer != nil) {
                sliceLayer?.removeFromSuperlayer()
            }
        }
        
        _sliceValues = Array<SliceData>()
    }
    
    internal func getInterfaceBuilderData()->Array<SliceData> {
        var colorsArray: Array<UIColor> = Array<UIColor>()
        colorsArray.append(UIColor.init(red: 97/255,    green: 199/255,     blue: 214/255,  alpha: 1.0))
        colorsArray.append(UIColor.init(red: 27/255,    green: 156/255,     blue: 167/255,  alpha: 1.0))
        colorsArray.append(UIColor.init(red: 111/255,   green: 190/255,     blue: 110/255,  alpha: 1.0))
        colorsArray.append(UIColor.init(red: 200/255,   green: 208/255,     blue: 85/255,   alpha: 1.0))
        colorsArray.append(UIColor.init(red: 254/255,   green: 208/255,     blue: 77/255,   alpha: 1.0))
        colorsArray.append(UIColor.init(red: 255/255,   green: 135/255,     blue: 57/255,   alpha: 1.0))
        colorsArray.append(UIColor.init(red: 244/255,   green: 107/255,     blue: 160/255,  alpha: 1.0))
        colorsArray.append(UIColor.init(red: 199/255,   green: 103/255,     blue: 163/255,  alpha: 1.0))
        
        var testData:Array<SliceData> = Array<SliceData>()
        
        let slicesCount: Int = colorsArray.count
        let percentageValue: CGFloat = 1.0 / CGFloat(slicesCount)
        let gapWidth: CGFloat = 4.0
        let sliceRadius: CGFloat = 1.0
        let hollowRadius: CGFloat = 0.8
        
        for i in 0 ..< slicesCount {
            let startingValue: CGFloat =  CGFloat(i) * percentageValue
            
            var sliceData: SliceData = SliceData()
            sliceData.percentageValue = percentageValue
            sliceData.startingValue = startingValue
            sliceData.gapWidth = gapWidth
            sliceData.sliceRadius = sliceRadius
            sliceData.hollowRadius = hollowRadius
            sliceData.sliceColor = colorsArray[i]
            
            testData.append(sliceData)
        }
        return testData
    }
}
