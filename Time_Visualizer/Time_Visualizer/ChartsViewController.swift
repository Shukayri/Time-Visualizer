//
//  ChartsViewController.swift
//  Time_Visualizer
//
//  Created by administrator on 1/10/22.
//

import UIKit
import Charts
import CoreData

class ChartsViewController: UIViewController, ChartViewDelegate {
    
    var pieChart = PieChartView()
    var radarChart = RadarChartView()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var dataList = [Times]()
    
    var switchButton: UIButton = {
        let button = UIButton()
        button.setTitle("SWITCH CHART", for: .normal)
        button.layer.backgroundColor = UIColor.systemPink.cgColor
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        return button
    }()
    
    var chartValues: [(String, Double)] = [("ios", 0),("algorith", 0),("uikit", 0),("swift", 0),("data structures", 0),("swift ui", 0)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        pieChart.delegate = self
        
        fetchingData()
    }
    
    func fetchingData() {
        let dataResult: NSFetchRequest<Times> = Times.fetchRequest()
        do {
            dataList = try context.fetch(dataResult)
        }catch {
            print(error)
        }
        for dataList in dataList {
            for chartValue in 0..<chartValues.count{
                if let check = dataList.note?.contains(chartValues[chartValue].0){
                    if check{
                        chartValues[chartValue].1 += 1
                    }
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setUpPieChart()
        view.addSubview(pieChart)
        pieChart.isHidden = false

        setUpRadarChart()
        view.addSubview(radarChart)
        radarChart.isHidden = true
        
        setUpSwitchButton()
        view.addSubview(switchButton)
        
    }
    
    func setUpPieChart() {
        pieChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 100)
        var entries = [PieChartDataEntry]()
        for chartValue in chartValues{
            entries.append(PieChartDataEntry(value: chartValue.1, label: chartValue.0))
        }
        let dataSet = PieChartDataSet(entries: entries, label: "")
        dataSet.colors = [.systemCyan, .blue, .purple, .systemCyan, .blue, .purple]
        let data = PieChartData(dataSet: dataSet)
        pieChart.data = data
        pieChart.legend.horizontalAlignment = .center
        pieChart.holeColor = .white
        pieChart.backgroundColor = .white
        pieChart.legend.textColor = .black
        //pieChart.chartDescription?.enabled = false
        //pieChart.drawHoleEnabled = false //To Add Hole in the Middle
        pieChart.rotationAngle = 0
        pieChart.rotationEnabled = false //For Rotating The Chart
        //pieChart.isUserInteractionEnabled = false //Used For Clicking on the chart
        //pieChart.legend.enabled = false //Used To Display Uder Data
        pieChart.drawSlicesUnderHoleEnabled = false
        //pieChart.drawEntryLabelsEnabled = false //Rwiting Entry Label in slices
        pieChart.usePercentValuesEnabled = true
    }
    
    func setUpRadarChart() {
        radarChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 100)
        var entries = [RadarChartDataEntry]()
        var legend = [LegendEntry]()
        for chartValue in chartValues{
            entries.append(RadarChartDataEntry(value: chartValue.1))
            legend.append(LegendEntry())
        }
        let colors = [UIColor.systemCyan, UIColor.blue, UIColor.purple, UIColor.systemCyan, UIColor.blue, UIColor.purple]
        for x in 0..<chartValues.count{
            legend[x].label = chartValues[x].0
            legend[x].form = .square
            legend[x].formColor = colors[x]
            legend[x].formSize = 10
        }
        
        let dataSet = RadarChartDataSet(entries: entries, label: "")
        dataSet.colors = colors
        dataSet.fillColor = UIColor.red
        dataSet.drawFilledEnabled = true
        let data = RadarChartData(dataSet: dataSet)
        radarChart.data = data
        
        radarChart.legend.entries = legend
        radarChart.legend.yEntrySpace = 2
        radarChart.legend.verticalAlignment = .bottom
        radarChart.legend.orientation = .vertical
        legend.removeLast()
        legend.removeLast()
        radarChart.legend.extraEntries = legend
        radarChart.legend.horizontalAlignment = .left
        
        radarChart.rotationEnabled = false
        radarChart.backgroundColor = .white
    }
    
    func setUpSwitchButton() {
        switchButton.frame = CGRect(x: 0, y: self.view.frame.height - 75, width: self.view.frame.width, height: 50)
        switchButton.layer.cornerRadius = 20
        switchButton.layer.borderColor = UIColor.red.cgColor
        switchButton.layer.borderWidth = 2
        switchButton.addTarget(self, action: #selector(switchChart), for: .touchUpInside)
    }
    
    @objc func switchChart() {
        if pieChart.isHidden {
            pieChart.isHidden = false
            radarChart.isHidden = true
        }else {
            pieChart.isHidden = true
            radarChart.isHidden = false
        }
    }
    
}

