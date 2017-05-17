//
//  VariableSlicesViewController.swift
//  PieChart
//
//  Created by Victor Obretin on 2016-11-28.
//  Copyright © 2016 Victor Obretin. All rights reserved.
//

import UIKit

class VariableSlicesViewController: PageItemViewController {

    @IBOutlet weak var pieChart: UIPieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        pieChart.clearSlices()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        pieChart.setValues(values: getGraphData())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent //or default
    }
    
    private func getGraphData()->Array<SliceData> {
        var colorsArray: Array<UIColor> = Array<UIColor>()
        colorsArray.append(UIColor.init(red: 97/255,    green: 199/255,     blue: 214/255,  alpha: 1.0))
        colorsArray.append(UIColor.init(red: 27/255,    green: 156/255,     blue: 167/255,  alpha: 1.0))
        colorsArray.append(UIColor.init(red: 111/255,   green: 190/255,     blue: 110/255,  alpha: 1.0))
        colorsArray.append(UIColor.init(red: 200/255,   green: 208/255,     blue: 85/255,   alpha: 1.0))
        colorsArray.append(UIColor.init(red: 254/255,   green: 208/255,     blue: 77/255,   alpha: 1.0))
        colorsArray.append(UIColor.init(red: 255/255,   green: 135/255,     blue: 57/255,   alpha: 1.0))
        colorsArray.append(UIColor.init(red: 244/255,   green: 107/255,     blue: 160/255,  alpha: 1.0))
        colorsArray.append(UIColor.init(red: 199/255,   green: 103/255,     blue: 163/255,  alpha: 1.0))
        
        var slicesData:Array<SliceData> = Array<SliceData>()
        
        let gapWidth: CGFloat = 2.0
        
        // overview slices
        let overviewSlicesCount: Int = colorsArray.count
        let overviewPercentageValue: CGFloat = 1.0 / CGFloat(overviewSlicesCount)
        let overviewHollowRadius: CGFloat = 0.44
        let overviewSliceRadius: CGFloat = 0.47
        let overviewFadeInDuration: Double = 0.5
        
        var currentStartingValue: CGFloat = 0.0
        var currentFadeinDelay: Double = 0.0
        
        for i in 0 ..< overviewSlicesCount {
            var sliceData: SliceData = SliceData()
            sliceData.percentageValue = overviewPercentageValue
            sliceData.startingValue = currentStartingValue
            sliceData.gapWidth = gapWidth
            sliceData.sliceRadius = overviewSliceRadius
            sliceData.hollowRadius = overviewHollowRadius
            sliceData.sliceColor = colorsArray[i]
            sliceData.fadeInDuration = overviewFadeInDuration
            sliceData.fadeInDelay = currentFadeinDelay
            
            slicesData.append(sliceData)
            
            currentFadeinDelay += 0.05
            currentStartingValue += overviewPercentageValue
        }
        
        // detail slices
        let detailSlicesPerColor: Int = 12
        let detailSlicesCount: Int = colorsArray.count * detailSlicesPerColor
        let detailPercentageValue: CGFloat = 1.0 / CGFloat(detailSlicesCount)
        let detailHollowRadius: CGFloat = 0.5
        let minSliceRadius: CGFloat = detailHollowRadius + 0.1
        let radiusInterval: CGFloat = 1.0 - minSliceRadius
        
        currentStartingValue = 0.0
        currentFadeinDelay += 0.5
        
        for i in 0 ..< overviewSlicesCount {
            for _ in 0 ..< detailSlicesPerColor {
                let randomRadiusRatio: CGFloat = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
                let detailSliceRadius: CGFloat = minSliceRadius + randomRadiusRatio * radiusInterval
                let fadeInDelay: Double = currentFadeinDelay + Double(randomRadiusRatio) * 0.5
                
                var sliceData: SliceData = SliceData()
                sliceData.percentageValue = detailPercentageValue
                sliceData.startingValue = currentStartingValue
                sliceData.gapWidth = gapWidth
                sliceData.sliceRadius = detailSliceRadius
                sliceData.hollowRadius = detailHollowRadius
                sliceData.sliceColor = colorsArray[i]
                sliceData.fadeInDuration = overviewFadeInDuration
                sliceData.fadeInDelay = fadeInDelay
                
                slicesData.append(sliceData)
                
                currentStartingValue += detailPercentageValue
            }
        }
        
        return slicesData
    }
}

