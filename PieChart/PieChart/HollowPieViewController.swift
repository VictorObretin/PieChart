//
//  HollowPieViewController.swift
//  PieChart
//
//  Created by Victor Obretin on 2016-11-28.
//  Copyright © 2016 Victor Obretin. All rights reserved.
//

import UIKit

class HollowPieViewController: PageItemViewController {
    
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
        
        let valuesArray: Array<CGFloat> = [0.05, 0.2, 0.1, 0.2, 0.1, 0.05, 0.1, 0.2]
        
        let slicesCount: Int = valuesArray.count
        
        let gapWidth: CGFloat = 4.0
        let mainSliceRadius: CGFloat = 0.9
        let mainHollowRadius: CGFloat = 0.8
        
        let secondarySliceRadius: CGFloat = 0.77
        let secondaryHollowRadius: CGFloat = 0.75
        
        let startSliceRadius: CGFloat = 1.0
        let startHollowRadius: CGFloat = 0.93
        
        var currentStartingValue: CGFloat = 0.0
        var currentFadeinDelay: Double = 0.0
        
        let dotColor: UIColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.75)
        
        var slicesData:Array<SliceData> = Array<SliceData>()
        
        for i in 0 ..< slicesCount {
            
            // color slice
            var mainSliceData: SliceData = SliceData()
            mainSliceData.percentageValue = valuesArray[i]
            mainSliceData.startingValue = currentStartingValue
            mainSliceData.gapWidth = gapWidth
            mainSliceData.sliceRadius = mainSliceRadius
            mainSliceData.hollowRadius = mainHollowRadius
            mainSliceData.sliceColor = colorsArray[i]
            mainSliceData.fadeInDuration = 0.5
            mainSliceData.fadeInDelay = currentFadeinDelay
            
            slicesData.append(mainSliceData)
            
            // inner white slice
            let alpha: CGFloat = (valuesArray[i] / 0.2) * 0.7
            let secondaryColor: UIColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: alpha)
            
            var secondarySliceData: SliceData = SliceData()
            secondarySliceData.percentageValue = valuesArray[i]
            secondarySliceData.startingValue = currentStartingValue
            secondarySliceData.gapWidth = gapWidth
            secondarySliceData.sliceRadius = secondarySliceRadius
            secondarySliceData.hollowRadius = secondaryHollowRadius
            secondarySliceData.sliceColor = secondaryColor
            secondarySliceData.fadeInDuration = 0.5
            secondarySliceData.fadeInDelay = 0.7
            
            slicesData.append(secondarySliceData)
            
            // starting line slice
            var startSliceData: SliceData = SliceData()
            startSliceData.percentageValue = 0.002
            startSliceData.startingValue = currentStartingValue
            startSliceData.gapWidth = 0.0
            startSliceData.sliceRadius = startSliceRadius
            startSliceData.hollowRadius = startHollowRadius
            startSliceData.sliceColor = dotColor
            startSliceData.fadeInDuration = 0.5
            startSliceData.fadeInDelay = currentFadeinDelay
            
            slicesData.append(startSliceData)
            
            currentStartingValue += mainSliceData.percentageValue
            currentFadeinDelay += 0.05
        }
        
        return slicesData
    }
}
