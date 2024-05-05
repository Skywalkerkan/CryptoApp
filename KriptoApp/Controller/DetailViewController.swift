//
//  DetailViewController.swift
//  KriptoApp
//
//  Created by Erkan on 2.05.2024.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    var singleCoin: Coin?
    var isStarred: Bool = false
    
    let topNavigationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let cryptoNameLabel: UILabel = {
        let label = UILabel()
        label.text = "ARKM/USDT"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var starButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "star")?.withRenderingMode(.alwaysOriginal).withTintColor(.white), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.addTarget(self, action: #selector(starClicked), for: .touchUpInside)
        return button
    }()
    
    @objc func starClicked(){
        if !isStarred{
            starButton.setBackgroundImage(UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.yellow), for: .normal)
            saveCoin()
        }else{
            starButton.setBackgroundImage(UIImage(systemName: "star")?.withRenderingMode(.alwaysOriginal).withTintColor(.white), for: .normal)
            guard let id = singleCoin?.uuid else{return}
            deleteCoin(withId: id)
        }
        isStarred = !isStarred
        fetchCoins()
    }
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "arrow.backward")?.withRenderingMode(.alwaysOriginal).withTintColor(.white), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.addTarget(self, action: #selector(backClicked), for: .touchUpInside)
        return button
    }()
    
    @objc func backClicked(){
        navigationController?.popViewController(animated: true)
    }
    
    let infoView: UIView = {
       let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let priceChangeStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing = 4
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let priceLabelUsdt: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .green
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.text = "2.4350"
        return label
    }()
    
    let priceLabelUsd: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "≈ $2.43"
        return label
    }()
    
    let changeLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "+10.11%"
        label.textColor = .green
        return label
    }()
    
    let leftStackView: UIStackView = {
        let stackView = UIStackView()
         stackView.axis = .vertical
         stackView.alignment = .leading
         stackView.spacing = 2
         stackView.translatesAutoresizingMaskIntoConstraints = false
         return stackView
     }()
    
    let high24hLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "24h High"
        label.textColor = .gray
        return label
    }()
    
    let high24hValueLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "+10.1123211%"
        label.textColor = .white
        return label
    }()
    
    let low24hLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "24h Low"
        label.textColor = .gray
        return label
    }()
    
    let low24hValueLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "+10.11%"
        label.textColor = .white
        return label
    }()
    
    let rightStackView: UIStackView = {
        let stackView = UIStackView()
         stackView.axis = .vertical
         stackView.alignment = .leading
         stackView.spacing = 2
         stackView.translatesAutoresizingMaskIntoConstraints = false
         return stackView
     }()
    
    
    let vol24hCryptoLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "24h High"
        label.textColor = .gray
        return label
    }()
    
    let vol24hCryptoValueLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "24h Vol"
        label.textColor = .white
        return label
    }()
    
    let vol24hUsdtLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "24h Vol(USDT)"
        label.textColor = .gray
        return label
    }()
    
    let vol24hUsdtValueLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "126.66M"
        label.textColor = .white
        return label
    }()
     
    
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
        print(dataValues)
        view.backgroundColor = UIColor(red: 38/255, green: 41/255, blue: 48/255, alpha: 1)


        setDetails()
        setupViews()
        fetchCoins()
        
      /*  view.addSubview(backView)
        backView.backgroundColor = .gray
        backView.backgroundColor = .black
          
        backView.topAnchor.constraint(equalTo: rightStackView.bottomAnchor, constant: 16).isActive = true
        backView.heightAnchor.constraint(equalToConstant: 330).isActive = true
        backView.widthAnchor.constraint(equalToConstant: 400).isActive = true
          
        setupCandleChart(data: dataValues)*/
    
        let maxFloat = dataValues.max() ?? 0
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
                label.topAnchor.constraint(equalTo: rightStackView.bottomAnchor, constant: CGFloat(i) * 80 + 40)
            ])
            labelOuter = label
        }
        
        view.addSubview(lineChartView)

        lineChartView.topAnchor.constraint(equalTo: rightStackView.bottomAnchor, constant: 40).isActive = true
        lineChartView.heightAnchor.constraint(equalToConstant: 330).isActive = true
        lineChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        lineChartView.trailingAnchor.constraint(equalTo: labelOuter.leadingAnchor, constant: -5).isActive = true
                
        lineChartView.data = dataValues
    
    }
    
    func setDetails(){
        guard let singleCoin = singleCoin else{return}
        cryptoNameLabel.text = singleCoin.symbol
        guard let price = singleCoin.price, let priceFloat = Float(price) else { return }

        let formattedPriceUsdt = String(format: "%.2f", priceFloat)
        priceLabelUsdt.text = formattedPriceUsdt
        let formattedPriceUsd = String(format: "%.1f", priceFloat)
        priceLabelUsd.text = formattedPriceUsd
        
        changeLabel.text = singleCoin.change
        

        let sparklineDoubles = singleCoin.sparkline?.compactMap { Double($0) }

        guard let maxPriceDouble = sparklineDoubles?.max(),
              let minPriceDouble = sparklineDoubles?.min() else {
            return
        }
        let formattedHighestPrice = String(format: "%.2f", maxPriceDouble)
        let formattedLowestPrice = String(format: "%.2f", minPriceDouble)
        high24hValueLabel.text = formattedHighestPrice
        low24hValueLabel.text = formattedLowestPrice

        vol24hUsdtValueLabel.text = singleCoin.the24HVolume?.formatVolume()
    }
    
    func saveCoin(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "CoinData", in: context)!
        let coin = NSManagedObject(entity: entity, insertInto: context)
        
        guard let id = singleCoin?.uuid else{return}
        coin.setValue(id, forKey: "id")
        
        do{
            try context.save()
            print("Veri Başarıyla kaydedildi")
        }catch let error as NSError{
            print("Veri Kaydedilirken hata oluştu \(error.localizedDescription)")
        }
        
    }
    
    func fetchCoins(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoinData")
        fetchRequest.returnsObjectsAsFaults = false

        do{
            let coins = try context.fetch(fetchRequest)
                   
            for case let coin as NSManagedObject in coins {
                if let id = coin.value(forKey: "id") as? String {
                    if id == singleCoin?.uuid{
                        isStarred = true
                        starButton.setBackgroundImage(UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.yellow), for: .normal)
                    }
                }
            }
            
        }catch let error as NSError{
            print("veriler geitirlirken hata oluştu \(error.localizedDescription)")
        }
    }
    
    func deleteCoin(withId id: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoinData")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                guard let coin = object as? NSManagedObject else { continue }
                context.delete(coin)
            }
            try context.save()
            print("Coin \(id) silindi.")
        } catch {
            print("Coin silinirken hata oluştu: \(error.localizedDescription)")
        }
    }

    
    
    func setupViews(){
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            statusBarHeight = UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        
        view.addSubview(topNavigationView)
        topNavigationView.heightAnchor.constraint(equalToConstant: statusBarHeight+40).isActive = true
        topNavigationView.widthAnchor.constraint(equalToConstant: view.frame.size.width).isActive = true
        topNavigationView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        topNavigationView.addSubview(backButton)
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        topNavigationView.addSubview(cryptoNameLabel)
        cryptoNameLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).isActive = true
        cryptoNameLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 16).isActive = true
        
        topNavigationView.addSubview(starButton)
        starButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 3).isActive = true
        starButton.trailingAnchor.constraint(equalTo: topNavigationView.trailingAnchor, constant: -16).isActive = true
        starButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        starButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        view.addSubview(priceLabelUsdt)
        priceLabelUsdt.topAnchor.constraint(equalTo: topNavigationView.bottomAnchor, constant: 16).isActive = true
        priceLabelUsdt.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true

        view.addSubview(priceChangeStackView)
        priceChangeStackView.topAnchor.constraint(equalTo: priceLabelUsdt.bottomAnchor, constant: 4).isActive = true
        priceChangeStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true

        priceChangeStackView.addArrangedSubview(priceLabelUsd)
        priceChangeStackView.addArrangedSubview(changeLabel)
        
        
        view.addSubview(rightStackView)
        rightStackView.topAnchor.constraint(equalTo: topNavigationView.bottomAnchor, constant: 16).isActive = true
        rightStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        rightStackView.addArrangedSubview(vol24hCryptoLabel)
        rightStackView.addArrangedSubview(vol24hCryptoValueLabel)
        rightStackView.addArrangedSubview(vol24hUsdtLabel)
        rightStackView.addArrangedSubview(vol24hUsdtValueLabel)
        rightStackView.setCustomSpacing(8, after: vol24hCryptoValueLabel)
        
        view.addSubview(leftStackView)
        leftStackView.topAnchor.constraint(equalTo: topNavigationView.bottomAnchor, constant: 16).isActive = true
        leftStackView.trailingAnchor.constraint(equalTo: rightStackView.leadingAnchor, constant: -16).isActive = true
        leftStackView.addArrangedSubview(high24hLabel)
        leftStackView.addArrangedSubview(high24hValueLabel)
        leftStackView.addArrangedSubview(low24hLabel)
        leftStackView.addArrangedSubview(low24hValueLabel)
        leftStackView.setCustomSpacing(8, after: high24hValueLabel)
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
            
            if percentDiff > 0{
                candleView.backgroundColor = AppColors.green
            }else{
                candleView.backgroundColor = AppColors.red
            }

            if i == 0{
                NSLayoutConstraint.activate([
                    candleView.heightAnchor.constraint(equalToConstant: CGFloat(heights[i])), // Yükseklik
                    candleView.widthAnchor.constraint(equalToConstant: candleWidth),
                    candleView.topAnchor.constraint(equalTo: backView.topAnchor, constant: CGFloat(position)),
                    candleView.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 5), // Sol kenar
                ])
              
            }else{
                if percentDiff > 0 && primaryPercent > 0{
                    NSLayoutConstraint.activate([
                        candleView.heightAnchor.constraint(equalToConstant: CGFloat(heights[i])), // Yükseklik
                        candleView.widthAnchor.constraint(equalToConstant: candleWidth),
                        candleView.bottomAnchor.constraint(equalTo: primaryView.topAnchor),
                        candleView.leadingAnchor.constraint(equalTo: primaryView.trailingAnchor, constant: 5), // Sol kenar
                    ])
                }else if percentDiff < 0 && primaryPercent < 0{
                    NSLayoutConstraint.activate([
                        candleView.heightAnchor.constraint(equalToConstant: CGFloat(heights[i])), // Yükseklik
                        candleView.widthAnchor.constraint(equalToConstant: candleWidth),
                        candleView.topAnchor.constraint(equalTo: primaryView.bottomAnchor),
                        candleView.leadingAnchor.constraint(equalTo: primaryView.trailingAnchor, constant: 5), // Sol kenar
                    ])
                }
                else if percentDiff > 0 && primaryPercent < 0{
                    NSLayoutConstraint.activate([
                        candleView.heightAnchor.constraint(equalToConstant: CGFloat(heights[i])), // Yükseklik
                        candleView.widthAnchor.constraint(equalToConstant: candleWidth),
                        candleView.bottomAnchor.constraint(equalTo: primaryView.bottomAnchor),
                        candleView.leadingAnchor.constraint(equalTo: primaryView.trailingAnchor, constant: 5), // Sol kenar
                    ])
                }
                else if percentDiff < 0 && primaryPercent > 0{
                    NSLayoutConstraint.activate([
                        candleView.heightAnchor.constraint(equalToConstant: CGFloat(heights[i])), // Yükseklik
                        candleView.widthAnchor.constraint(equalToConstant: candleWidth),
                        candleView.topAnchor.constraint(equalTo: primaryView.topAnchor),
                        candleView.leadingAnchor.constraint(equalTo: primaryView.trailingAnchor, constant: 5), // Sol kenar
                    ])
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


