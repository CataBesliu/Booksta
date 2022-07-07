//
//  LineChart.swift
//  booksta
//
//  Created by Catalina Besliu on 05.07.2022.
//

import SwiftUI
import Charts

struct LineChart : UIViewRepresentable {
    @Binding var selectedItem: String
    var chartLegend: String
    var usernames: [String]
    var entries : [[ChartDataEntry]]
    let lineChartView = LineChartView()
    let months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
    
    // this func is required to conform to UIViewRepresentable protocol
    func makeUIView(context: Context) -> LineChartView {
        lineChartView.delegate = context.coordinator
        return lineChartView
    }
    
    // this func is required to conform to UIViewRepresentable protocol
    func updateUIView(_ uiView: LineChartView, context: Context) {
        //when data changes chartd.data update is required
        uiView.data = addData()
            
        uiView.rightAxis.enabled = false
        uiView.setScaleEnabled(false)
        //        if uiView.scaleX == 1.0
        //        chart.zoom(scaleX: 1.5, scaleY: 1, x: 0, y: 0)
        formatLeftAxis(leftAxis: uiView.leftAxis)
        formatXAxis(xAxis: uiView.xAxis)
        formatLegend(legend: uiView.legend)
        uiView.notifyDataSetChanged()
        uiView.highlightPerTapEnabled = true
        uiView.xAxis.granularityEnabled = true
    }
    
    class Coordinator: NSObject, ChartViewDelegate {
        let parent: LineChart
        init(parent: LineChart) {
            self.parent = parent
        }
        
        func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
//            let user = parent.usernames[Int(entry.x)]
            let value = entry.y
//            parent.selectedItem = "@\(user) wrote \(value) posts"
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    
    func addData() -> LineChartData{
        
        let data = LineChartData()
        for entry in entries {
            let line = LineChartDataSet(entries: entry,
                                        label: "\(entry[0].data as? String ?? "")")
            line.colors = [generateRandomPastelColor()]
            line.lineWidth = 3
            data.addDataSet(line)
        }
        formatDataSet(dataSet: data)
        return data
    }
    
    func formatDataSet(dataSet: LineChartData) {
//        dataSet.colors = (1...10).map({ _ in generateRandomPastelColor()})
//        dataSet.valueColors = [UIColor.purple]
//        //change data label
////        dataSet.stackLabels = [chartLegend,"bla"]
//        dataSet.label = chartLegend
        
    }
    
    func formatLeftAxis(leftAxis: YAxis) {
        leftAxis.labelTextColor = .purple
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)
        leftAxis.axisMinimum = 0
        
    }
    
    func formatXAxis(xAxis: XAxis) {
        xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
        xAxis.labelPosition = .bottom
        xAxis.labelTextColor = .purple
    }
    
    func formatLegend(legend: Legend) {
        legend.textColor = .purple
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        //        legend.drawInside = true
        //        legend.yOffset = 30.0
    }
    
    func generateRandomPastelColor(withMixedColor mixColor: UIColor? = nil) -> UIColor {
        // Randomly generate number in closure
        let randomColorGenerator = { ()-> CGFloat in
            CGFloat(arc4random() % 256 ) / 256
        }
        
        var red: CGFloat = randomColorGenerator()
        var green: CGFloat = randomColorGenerator()
        var blue: CGFloat = randomColorGenerator()
        
        // Mix the color
        if let mixColor = mixColor {
            var mixRed: CGFloat = 0, mixGreen: CGFloat = 0, mixBlue: CGFloat = 0;
            mixColor.getRed(&mixRed, green: &mixGreen, blue: &mixBlue, alpha: nil)
            
            red = (red + mixRed) / 2;
            green = (green + mixGreen) / 2;
            blue = (blue + mixBlue) / 2;
        }
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    typealias UIViewType = LineChartView
    
}
