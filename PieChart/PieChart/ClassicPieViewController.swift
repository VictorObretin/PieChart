//
//  ClassicPieViewController.swift
//  PieChart
//
//  Created by Victor Obretin on 2016-11-28.
//  Copyright © 2016 Victor Obretin. All rights reserved.
//

import UIKit

class ClassicPieViewController: PageItemViewController {
    
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
        
        let offsetSliceIndexes: Array<Int> = [1]
        var delay: Double = 1.0
        
        for i in 0 ..< offsetSliceIndexes.count {
            let sliceIndex: Int = offsetSliceIndexes[i]
            pieChart.offsetSlice(sliceIndex: 2 * sliceIndex, byRatio: 0.15, duration: 0.5, delay: delay)
            pieChart.offsetSlice(sliceIndex: 2 * sliceIndex + 1, byRatio: 0.15, duration: 0.5, delay: delay)
            delay += 0.1
        }
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
        
        let valuesArray: Array<CGFloat> = [0.05, 0.17, 0.08, 0.2, 0.15, 0.05, 0.1, 0.2]
        
        let slicesCount: Int = valuesArray.count
        
        let gapWidth: CGFloat = 1.0
        let fadeInDuration: Double = 0.5
        let fadeInDelayIncrement: Double = 0.05
        let mainSliceRadius: CGFloat = 0.95
        let mainHollowRadius: CGFloat = 0.0
        
        let secondarySliceRadius: CGFloat = 1.0
        let secondaryHollowRadius: CGFloat = 0.98
        
        var currentStartingValue: CGFloat = 0.0
        var currentFadeinDelay: Double = 0.0
        
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
            mainSliceData.fadeInDuration = fadeInDuration
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
            secondarySliceData.fadeInDuration = fadeInDuration
            secondarySliceData.fadeInDelay = Double(slicesCount) * fadeInDelayIncrement
            
            slicesData.append(secondarySliceData)
            
            currentStartingValue += mainSliceData.percentageValue
            currentFadeinDelay += fadeInDelayIncrement
        }
        
        return slicesData
    }
}
