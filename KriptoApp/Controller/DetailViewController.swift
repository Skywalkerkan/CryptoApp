//
//  DetailViewController.swift
//  KriptoApp
//
//  Created by Erkan on 2.05.2024.
//

import UIKit

class DetailViewController: UIViewController {

    
    var singleCoin: Coin?
    
    var lineChartView: LineChartView = {
       let view = LineChartView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let backView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        guard let dataStrings = singleCoin?.sparkline else { return }
        let dataValues = dataStrings.compactMap { Float($0) }

        view.backgroundColor = .black
        
        view.addSubview(backView)
        backView.backgroundColor = .gray
        backView.backgroundColor = .black
        
        
        backView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        backView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        backView.widthAnchor.constraint(equalToConstant: 400).isActive = true
        
        setupCandleChart(data: dataValues)
        
        
        
      /*  let maxFloat = dataValues.max() ?? 0
        let minFloat = dataValues.min() ?? 0

        let range = maxFloat - minFloat
        let step = range / 4

        var values: [Float] = []
        for i in 0...4 {
            let value = minFloat + step * Float(i)
            values.append(value)
        }

        print(values) // 5 eşit aralıklı değer


        view.backgroundColor = UIColor(red: 38/255, green: 41/255, blue: 48/255, alpha: 1)


        
        let startValue = maxFloat
        let endValue = minFloat
        let stepcik = (startValue - endValue) / 4 // 5 adet değer olduğu için 4 adet aralık var

        var labelOuter = UILabel()
        for i in 0...4 {
            let value = startValue - stepcik * Float(i)
            let label = UILabel()
            label.text = String(format: "%.2f", value)
            label.font = UIFont.systemFont(ofSize: 12)
            view.addSubview(label)
            label.backgroundColor = .clear
            label.textAlignment = .right
            label.textColor = .lightGray
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
                label.heightAnchor.constraint(equalToConstant: 12),
                label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: CGFloat(i) * 75 - 5)
            ])
            labelOuter = label
        }
        
        view.addSubview(lineChartView)

        lineChartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        lineChartView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        lineChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        lineChartView.trailingAnchor.constraint(equalTo: labelOuter.leadingAnchor, constant: -5).isActive = true

        
        
        
        
                
        lineChartView.data = dataValues*/
        
      
        
        
        

    }
    
    func calculatePositions(data: [Float], viewHeight: CGFloat) -> [CGFloat] {
        let maxValue = CGFloat(data.max() ?? 0)
        let minValue = CGFloat(data.min() ?? 0)
        let totalRange = maxValue - minValue
        
        var positions: [CGFloat] = []
        
        for value in data {
            let relativePosition = (CGFloat(value) - minValue) / totalRange
            let position = viewHeight * relativePosition
            positions.append(position)
        }
        
        return positions
    }

    
    
    func calculatePositionsAndHeights(data: [Float], viewHeight: CGFloat) -> [(position: CGFloat, height: CGFloat)] {
        let maxValue = CGFloat(data.max() ?? 0)
        let minValue = CGFloat(data.min() ?? 0)
        let totalRange = maxValue - minValue
        
        var positionsAndHeights: [(position: CGFloat, height: CGFloat)] = []
        
        for i in 0..<data.count {
            let value = CGFloat(data[i])
            let relativePosition = (value - minValue) / totalRange
            let position = viewHeight * relativePosition
            
            var height: CGFloat
            if i < data.count - 1 {
                let nextValue = CGFloat(data[i + 1])
                let valueDifference = nextValue - value
                let relativeHeight = valueDifference / totalRange
                height = relativeHeight * viewHeight
            } else {
                height = 0 // Son eleman, yani en üstteki eleman
            }
            
            positionsAndHeights.append((position: position, height: height))
        }
        
        return positionsAndHeights
    }
    
    
    var primaryPercent: Float = 0.0

    
    private func setupCandleChart(data: [Float]){
        print(data)
        
        let maxValue = data.max() ?? 0
        let minValue = data.min() ?? 0
        
        let percentageDifference = (maxValue - minValue) / minValue * 100
        
        
        
        // CandlestickView oluşturma

        
        
        var primaryView = UIView()
        
        var constantHeight: Float = 0.0
        for i in 0...9{
            let percentDiff = (data[i + 1] - data[i]) / data[i] * 100
            if percentDiff < 5{
               constantHeight = 25
            }
        }
        
        let positionsAndHeights = calculatePositionsAndHeights(data: data, viewHeight: 300)
        var heights = [Int]()
      //  print("Positions and Heights:")
        for (index, item) in positionsAndHeights.enumerated() {
            let absoluteHeight = Int(abs(item.height)) // Yüksekliğin mutlak değeri alınıyor
               print("Item \(index + 1): position \(item.position), height \(absoluteHeight)")
                
               heights.append(absoluteHeight)
        }
        
        
        for i in 0...data.count-2 { // İki label oluşturacağız
            let candleView = UIView()
            candleView.translatesAutoresizingMaskIntoConstraints = false
            candleView.backgroundColor = .purple
            
            
            let percentDiff = (data[i + 1] - data[i]) / data[i] * 100
            let differenceHepsi = data[i] / (maxValue + minValue)
            
            let candleWidth: CGFloat = (view.frame.size.width - 125)/35
          //  print(candleWidth)
            
            let ikisininOran = 300 * (1-differenceHepsi)
           // let ikisininOran = 300/((maxValue+minValue)/data[i])
           // print(ikisininOran)
            let position = 300 - (calculatePositions(data: data, viewHeight: 300).first ?? 0)
           // let ikisininOran = 300 - positions[i]
            //print(ikisininOran)
           // print(differenceHepsi)
            
           
            let difference = data[i+1] - data[i]
            
            let candleHeight: CGFloat = abs(CGFloat(percentDiff * constantHeight).rounded())

            backView.addSubview(candleView)
            if heights[i] == 0{
                heights[i] = 1
            }
            
            //print(percentDiff)
            if i == 0{
                NSLayoutConstraint.activate([
                    candleView.heightAnchor.constraint(equalToConstant: CGFloat(heights[i])), // Yükseklik
                    candleView.widthAnchor.constraint(equalToConstant: candleWidth),
                    candleView.topAnchor.constraint(equalTo: backView.topAnchor, constant: CGFloat(position)),
                    candleView.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 5), // Sol kenar
                ])
                if percentDiff > 0{
                    candleView.backgroundColor = .green
                }else{
                    candleView.backgroundColor = .red
                }
            }else{
                if percentDiff > 0 && primaryPercent > 0{
                    NSLayoutConstraint.activate([
                        candleView.heightAnchor.constraint(equalToConstant: CGFloat(heights[i])), // Yükseklik
                        candleView.widthAnchor.constraint(equalToConstant: candleWidth),
                        candleView.bottomAnchor.constraint(equalTo: primaryView.topAnchor),
                        candleView.leadingAnchor.constraint(equalTo: primaryView.trailingAnchor, constant: 5), // Sol kenar
                    ])
                    candleView.backgroundColor = .green
                }else if percentDiff < 0 && primaryPercent < 0{
                    NSLayoutConstraint.activate([
                        candleView.heightAnchor.constraint(equalToConstant: CGFloat(heights[i])), // Yükseklik
                        candleView.widthAnchor.constraint(equalToConstant: candleWidth),
                        candleView.topAnchor.constraint(equalTo: primaryView.bottomAnchor),
                        candleView.leadingAnchor.constraint(equalTo: primaryView.trailingAnchor, constant: 5), // Sol kenar
                    ])
                    candleView.backgroundColor = .red
                }
                else if percentDiff > 0 && primaryPercent < 0{
                    NSLayoutConstraint.activate([
                        candleView.heightAnchor.constraint(equalToConstant: CGFloat(heights[i])), // Yükseklik
                        candleView.widthAnchor.constraint(equalToConstant: candleWidth),
                        candleView.bottomAnchor.constraint(equalTo: primaryView.bottomAnchor),
                        candleView.leadingAnchor.constraint(equalTo: primaryView.trailingAnchor, constant: 5), // Sol kenar
                    ])
                    candleView.backgroundColor = .green
                }
                else if percentDiff < 0 && primaryPercent > 0{
                    NSLayoutConstraint.activate([
                        candleView.heightAnchor.constraint(equalToConstant: CGFloat(heights[i])), // Yükseklik
                        candleView.widthAnchor.constraint(equalToConstant: candleWidth),
                        candleView.topAnchor.constraint(equalTo: primaryView.topAnchor),
                        candleView.leadingAnchor.constraint(equalTo: primaryView.trailingAnchor, constant: 5), // Sol kenar
                    ])
                    candleView.backgroundColor = .red
                }
                
               
            }
            primaryPercent = percentDiff
            primaryView = candleView
        }

        
        
        
        

        // CandlestickView'i eklemek
    }


}



class LineChartView: UIView {
    
    var data: [Float] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        UIColor(red: 38/255, green: 41/255, blue: 48/255, alpha: 1).setFill()
        context.fill(rect)
        
        guard data.count > 1 else { return }
        
        let maxValue = CGFloat(data.max()!)
        let minValue = CGFloat(data.min()!)
        let valueRange = maxValue - minValue
        
        let width = rect.width
        let height = rect.height
        
        let stepX = width / CGFloat(data.count - 1)
        let stepY = height / valueRange
        
        // Line'ı çiz
        UIColor(red: 255/255, green: 206/255, blue: 47/255, alpha: 1).setStroke()
        let linePath = UIBezierPath()
        linePath.lineWidth = 2.0
        
        // Alt kısmı dolduracak poligon için başlangıç noktası
        linePath.move(to: CGPoint(x: 0, y: height))
        
        for (index, value) in data.enumerated() {
            let x = stepX * CGFloat(index)
            let y = height - (CGFloat(value) - minValue) * stepY
            
            if index == 0 {
                linePath.move(to: CGPoint(x: x, y: y))
            } else {
                linePath.addLine(to: CGPoint(x: x, y: y))
            }
            
            // x değerlerini eksenin altına yerleştir
           /* let xValueLabel = UILabel()
            xValueLabel.text = "\(index)" // veya burada göstermek istediğiniz başka bir değer olabilir
            xValueLabel.font = UIFont.systemFont(ofSize: 10)
            xValueLabel.sizeToFit()
            xValueLabel.center = CGPoint(x: x, y: rect.height + 5) // 5: ekstra bir boşluk
            addSubview(xValueLabel)*/
        }
        
        // Çizgiyi çiz
        linePath.stroke()
        
        // Alt kısmı doldur
        linePath.addLine(to: CGPoint(x: rect.width, y: height)) // Alt kenarı tamamla
        linePath.addLine(to: CGPoint(x: 0, y: height)) // Sol alt köşeye dön
        
        // Doldur
        UIColor(red: 255/255, green: 206/255, blue: 47/255, alpha: 0.5).setFill()
        linePath.fill()
    }

}


