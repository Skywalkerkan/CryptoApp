import UIKit

class ViewController: UIViewController {
    
    var lineChartView: LineChartView! // ViewController'a özellik olarak ekledik
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // LineChartView'i oluştur
        lineChartView = LineChartView(frame: CGRect(x: 20, y: 100, width: view.frame.width - 40, height: 200))
        view.addSubview(lineChartView) // View'e ekle
        
        // Rastgele Integer değerleri oluştur
        let randomData = [5, 4, 7, 4, 5, 4, 7, 4, 5]
        
        lineChartView.data = randomData
    }
}

class LineChartView: UIView {
    
    var data: [Int] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        UIColor.white.setFill()
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
        UIColor.blue.setStroke()
        let linePath = UIBezierPath()
        linePath.lineWidth = 2.0
        
        for (index, value) in data.enumerated() {
            let x = stepX * CGFloat(index)
            let y = height - (CGFloat(value) - minValue) * stepY
            
            if index == 0 {
                linePath.move(to: CGPoint(x: x, y: y))
            } else {
                linePath.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        linePath.stroke()
    }
}
