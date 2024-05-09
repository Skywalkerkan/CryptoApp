//
//  DetailViewController.swift
//  KriptoApp
//
//  Created by Erkan on 2.05.2024.
//

import UIKit
import CoreData
import Kingfisher


class DetailViewController: UIViewController {
    
    var singleCoin: Coin?
    var isStarred: Bool = false
    var allValues = [Float]()
    
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
    
    let cryptoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
    
    lazy var webButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "network")?.withRenderingMode(.alwaysOriginal).withTintColor(.white), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.addTarget(self, action: #selector(webClicked), for: .touchUpInside)
        return button
    }()
    
    @objc func webClicked() {
        let webViewController = WebViewController()
        webViewController.url = singleCoin?.coinrankingURL ?? "https://coinranking.com"
        let navigationController = UINavigationController(rootViewController: webViewController)
        navigationController.modalPresentationStyle = .pageSheet
        present(navigationController, animated: true, completion: nil)
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
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.text = "2.4350"
        return label
    }()
    
    let priceLabelUsd: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.text = "≈ $2.43"
        return label
    }()
    
    let changeLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
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
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
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
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
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
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.text = "Market Cap"
        label.textColor = .gray
        return label
    }()
    
    let marketCapValue: UILabel = {
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
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
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
        view.isHidden = true
        return view
    }()
    
    var rsiLineChartView: LineChartView = {
       let view = LineChartView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let candleCharView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var lineChartButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "chart.xyaxis.line")?.withRenderingMode(.alwaysOriginal).withTintColor(.white), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.addTarget(self, action: #selector(lineChartClicked), for: .touchUpInside)
        return button
    }()
    
    @objc func lineChartClicked(){
        setupLineChartView(dataValues: allValues)
        candleCharView.isHidden = true
        lineChartView.isHidden = false
    }
    
    lazy var candleChartButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "chart.bar.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.white), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.addTarget(self, action: #selector(candleChartClicked), for: .touchUpInside)
        return button
    }()
    
    @objc func candleChartClicked(){
        lineChartView.isHidden = true
        candleCharView.isHidden = false
        setupCandleChart(data: allValues)
    }
    
    let rsiLabel: UILabel = {
        let rsiLabel = UILabel()
        rsiLabel.translatesAutoresizingMaskIntoConstraints = false
        rsiLabel.textColor = .white
        rsiLabel.font = .systemFont(ofSize: 16, weight: .black)
        rsiLabel.text = "RSI"
        return rsiLabel
    }()
    
    let chartLabel: UILabel = {
        let rsiLabel = UILabel()
        rsiLabel.translatesAutoresizingMaskIntoConstraints = false
        rsiLabel.textColor = .white
        rsiLabel.font = .systemFont(ofSize: 16, weight: .black)
        rsiLabel.text = "Candle Chart"
        return rsiLabel
    }()
    
    lazy var buyButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Buy", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .black)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = AppColors.green
        button.layer.cornerRadius = 4
        return button
    }()
    
    lazy var sellButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sell", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .black)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = AppColors.red
        button.layer.cornerRadius = 4
        return button
    }()
    
    let buttonStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 16
        return stackView
    }()
    
    let detailView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let dataStrings = singleCoin?.sparkline else { return }
        let dataValues = dataStrings.compactMap { Float($0) }

        allValues = dataValues
        view.backgroundColor = UIColor(red: 38/255, green: 41/255, blue: 48/255, alpha: 1)
        
        setDetails()
        setupViews()
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchCoins()
        setupCandleChart(data: allValues)
        setupRsiChartView()
        buttonSetup()
    }
    
    var labelOuterLeading = UILabel()
    func setupLineChartView(dataValues: [Float]){
        let maxFloat = dataValues.max() ?? 0
        let minFloat = dataValues.min() ?? 0

        let range = maxFloat - minFloat
        let step = range / 4

        var values: [Float] = []
        for i in 0...4 {
            let value = minFloat + step * Float(i)
            values.append(value)
        }

        view.backgroundColor = UIColor(red: 38/255, green: 41/255, blue: 48/255, alpha: 1)

        view.addSubview(lineChartView)
        lineChartView.topAnchor.constraint(equalTo: chartLabel.bottomAnchor, constant: 24).isActive = true
        lineChartView.heightAnchor.constraint(equalToConstant: 0.33*view.frame.size.height).isActive = true
        lineChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        lineChartView.trailingAnchor.constraint(equalTo: labelOuterLeading.leadingAnchor, constant: -5).isActive = true
        lineChartView.data = dataValues
    }
    
    func setupRsiChartView(){
        
        view.addSubview(rsiLabel)
        rsiLabel.topAnchor.constraint(equalTo: labelOuterLeading.bottomAnchor, constant: 16).isActive = true
        rsiLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        
        view.addSubview(rsiLineChartView)
        rsiLineChartView.topAnchor.constraint(equalTo: labelOuterLeading.bottomAnchor, constant: 32).isActive = true
        rsiLineChartView.heightAnchor.constraint(equalToConstant: 0.07*view.frame.size.height).isActive = true
        rsiLineChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        rsiLineChartView.trailingAnchor.constraint(equalTo: labelOuterLeading.leadingAnchor, constant: -5).isActive = true
        rsiLineChartView.backgroundColor = .red
        let rsiDatas = calculateRSI(data: allValues, period: 13)
        rsiLineChartView.data = rsiDatas
    }
    
    func calculateRSI(data: [Float], period: Int) -> [Float] {
        var rsiValues: [Float] = []
        
        if data.count < period {
            print("Veri sayısı, RSI periyodundan daha az olduğu için RSI hesaplanamaz.")
            return rsiValues
        }
        
        var gainSum: Float = 0
        var lossSum: Float = 0
        for i in 1..<period {
            let change = data[i] - data[i - 1]
            if change > 0 {
                gainSum += change
            } else {
                lossSum += abs(change)
            }
        }
        let initialAvgGain = gainSum / Float(period)
        let initialAvgLoss = lossSum / Float(period)
        
        var avgGain = initialAvgGain
        var avgLoss = initialAvgLoss
        
        for i in period..<data.count {
            let change = data[i] - data[i - 1]
            if change > 0 {
                avgGain = (avgGain * Float(period - 1) + change) / Float(period)
                avgLoss = (avgLoss * Float(period - 1)) / Float(period)
            } else {
                avgGain = (avgGain * Float(period - 1)) / Float(period)
                avgLoss = (avgLoss * Float(period - 1) + abs(change)) / Float(period)
            }
            
            let rs = avgGain / avgLoss
            let rsi = 100 - (100 / (1 + rs))
            rsiValues.append(rsi)
        }
        
        return rsiValues
    }


    
    func setDetails(){
        guard let singleCoin = singleCoin else{return}
        cryptoNameLabel.text = singleCoin.symbol
        guard let price = singleCoin.price, let priceFloat = Float(price) else { return }

        let formattedPriceUsdt = String(format: "%.2f", priceFloat)
        priceLabelUsdt.text = formattedPriceUsdt
        let formattedPriceUsd = String(format: "%.1f", priceFloat)
        priceLabelUsd.text = "$" + formattedPriceUsd
        
        guard let coinChange = singleCoin.change else{
            return
        }
        
        if Float(coinChange) ?? 0 > 0{
            changeLabel.textColor = AppColors.green
        }else{
            changeLabel.textColor = AppColors.red
        }
        
        changeLabel.text = (singleCoin.change ?? "no value") + " %"
    
        let sparklineDoubles = singleCoin.sparkline?.compactMap { Double($0) }

        guard let maxPriceDouble = sparklineDoubles?.max(),
              let minPriceDouble = sparklineDoubles?.min() else {
            return
        }
        let formattedHighestPrice = String(format: "%.2f", maxPriceDouble)
        let formattedLowestPrice = String(format: "%.2f", minPriceDouble)
        high24hValueLabel.text = formattedHighestPrice
        low24hValueLabel.text = formattedLowestPrice
        marketCapValue.text = singleCoin.marketCap?.formatVolume()
        vol24hUsdtValueLabel.text = singleCoin.the24HVolume?.formatVolume()
        
        guard let iconUrl = singleCoin.iconURL else{return}
        if iconUrl.contains("svg") {
            let newIconUrl = iconUrl.replacingOccurrences(of: "svg", with: "png")
                if let imageUrl = URL(string: newIconUrl) {
                cryptoImageView.kf.setImage(with: imageUrl)
            }
        }else{
            if let imageUrl = URL(string: iconUrl) {
                cryptoImageView.kf.setImage(with: imageUrl)
            }
        }
       
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
    
    func fetchCoins() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        print("okey")
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoinData")
        guard let coinID = singleCoin?.uuid else { return }
        let predicate = NSPredicate(format: "id == %@", coinID)
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false

        do {
            let coins = try context.fetch(fetchRequest)

            if let _ = coins.first as? NSManagedObject {
                isStarred = true
                starButton.setBackgroundImage(UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.yellow), for: .normal)
            } else {
                isStarred = false
                starButton.setBackgroundImage(UIImage(systemName: "star")?.withRenderingMode(.alwaysOriginal).withTintColor(.white), for: .normal)
            }

        } catch let error as NSError {
            print("Veriler getirilirken hata oluştu: \(error.localizedDescription)")
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
    var statusBarHeight: CGFloat = 0


    func setupViews(){
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
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        topNavigationView.addSubview(cryptoImageView)
        cryptoImageView.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 16).isActive = true
        cryptoImageView.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).isActive = true
        cryptoImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        cryptoImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true

        topNavigationView.addSubview(cryptoNameLabel)
        cryptoNameLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).isActive = true
        cryptoNameLabel.leadingAnchor.constraint(equalTo: cryptoImageView.trailingAnchor, constant: 12).isActive = true
        
        topNavigationView.addSubview(starButton)
        starButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 3).isActive = true
        starButton.trailingAnchor.constraint(equalTo: topNavigationView.trailingAnchor, constant: -16).isActive = true
        starButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        starButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        topNavigationView.addSubview(webButton)
        webButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 3).isActive = true
        webButton.trailingAnchor.constraint(equalTo: starButton.leadingAnchor, constant: -16).isActive = true
        webButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        webButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
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
        rightStackView.addArrangedSubview(marketCapValue)
        rightStackView.addArrangedSubview(vol24hUsdtLabel)
        rightStackView.addArrangedSubview(vol24hUsdtValueLabel)
        rightStackView.setCustomSpacing(8, after: marketCapValue)
        
        view.addSubview(leftStackView)
        leftStackView.topAnchor.constraint(equalTo: topNavigationView.bottomAnchor, constant: 16).isActive = true
        leftStackView.trailingAnchor.constraint(equalTo: rightStackView.leadingAnchor, constant: -16).isActive = true
        leftStackView.addArrangedSubview(high24hLabel)
        leftStackView.addArrangedSubview(high24hValueLabel)
        leftStackView.addArrangedSubview(low24hLabel)
        leftStackView.addArrangedSubview(low24hValueLabel)
        leftStackView.setCustomSpacing(8, after: high24hValueLabel)
        
        view.addSubview(lineChartButton)
        lineChartButton.topAnchor.constraint(equalTo: rightStackView.bottomAnchor, constant: 16).isActive = true
        lineChartButton.trailingAnchor.constraint(equalTo: rightStackView.trailingAnchor, constant: 0).isActive = true
        lineChartButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        lineChartButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        view.addSubview(candleChartButton)
        candleChartButton.topAnchor.constraint(equalTo: rightStackView.bottomAnchor, constant: 16).isActive = true
        candleChartButton.trailingAnchor.constraint(equalTo: lineChartButton.leadingAnchor, constant: -16).isActive = true
        candleChartButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        candleChartButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    func buttonSetup(){
        view.addSubview(buttonStackView)
        buttonStackView.topAnchor.constraint(equalTo: rsiLineChartView.bottomAnchor, constant: 24).isActive = true
        buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        buttonStackView.addArrangedSubview(buyButton)
        buttonStackView.addArrangedSubview(sellButton)
        
        buyButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        buyButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        sellButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sellButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
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
                height = 0
            }
            positionsAndHeights.append((position: position, height: height))
        }
        
        return positionsAndHeights
    }
    
    var primaryPercent: Float = 0.0

    private func setupCandleChart(data: [Float]){

        view.addSubview(chartLabel)
        chartLabel.topAnchor.constraint(equalTo: candleChartButton.bottomAnchor, constant: 16).isActive = true
        chartLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true

        let maxFloat = data.max() ?? 0
        let minFloat = data.min() ?? 0

        let range = maxFloat - minFloat
        let step = range / 4

        var values: [Float] = []
        for i in 0...4 {
            let value = minFloat + step * Float(i)
            values.append(value)
        }

        view.backgroundColor = UIColor(red: 38/255, green: 41/255, blue: 48/255, alpha: 1)

        let startValue = maxFloat
        let endValue = minFloat
        let averageValue = (startValue - endValue) / 4

        var labelOuter = UILabel()
        for i in 0...4 {
            let value = startValue - averageValue * Float(i)
            let label = UILabel()
            label.text = String(format: "%.3f", value)
            label.font = UIFont.systemFont(ofSize: 12)
            view.addSubview(label)
            label.backgroundColor = .clear
            label.textAlignment = .right
            label.textColor = .lightGray
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
                label.heightAnchor.constraint(equalToConstant: 12),
                label.topAnchor.constraint(equalTo: chartLabel.bottomAnchor, constant: CGFloat(i) * (0.33*view.frame.size.height)/4 + 12)
            ])
            labelOuter = label
            labelOuterLeading = label
        }
 
        view.addSubview(candleCharView)
        candleCharView.topAnchor.constraint(equalTo: chartLabel.bottomAnchor, constant: 0).isActive = true
        candleCharView.heightAnchor.constraint(equalToConstant: 0.33*view.frame.size.height).isActive = true
        candleCharView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        candleCharView.trailingAnchor.constraint(equalTo: labelOuter.leadingAnchor, constant: -5).isActive = true
        
        var primaryView = UIView()
        
        let positionsAndHeights = calculatePositionsAndHeights(data: data, viewHeight: 0.33*view.frame.size.height)
        var heights = [Int]()
        var positions = [Float]()
        for (_, item) in positionsAndHeights.enumerated() {
            let absoluteHeight = Int(abs(item.height))
               heights.append(absoluteHeight)
                positions.append(Float(item.position))
        }
        
        
        for i in 0...data.count-2 {
            let candleView = UIView()
            candleView.translatesAutoresizingMaskIntoConstraints = false
            let percentDiff = (data[i + 1] - data[i]) / data[i] * 100
            
            let candleWidth: CGFloat = (view.frame.size.width - 125)/37
            let position = 0.33*view.frame.size.height - (calculatePositions(data: data, viewHeight: 0.33*view.frame.size.height ).first ?? 0)
            candleCharView.addSubview(candleView)
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
                    candleView.heightAnchor.constraint(equalToConstant: CGFloat(heights[i])),
                    candleView.widthAnchor.constraint(equalToConstant: candleWidth),
                    candleView.topAnchor.constraint(equalTo: candleCharView.topAnchor, constant: CGFloat(position)),
                    candleView.leadingAnchor.constraint(equalTo: candleCharView.leadingAnchor, constant: 5),
                ])
              
            }else{
                if percentDiff > 0 && primaryPercent > 0{
                    NSLayoutConstraint.activate([
                        candleView.heightAnchor.constraint(equalToConstant: CGFloat(heights[i])),
                        candleView.widthAnchor.constraint(equalToConstant: candleWidth),
                        candleView.bottomAnchor.constraint(equalTo: primaryView.topAnchor),
                        candleView.leadingAnchor.constraint(equalTo: primaryView.trailingAnchor, constant: 5),
                    ])
                }else if percentDiff < 0 && primaryPercent < 0{
                    NSLayoutConstraint.activate([
                        candleView.heightAnchor.constraint(equalToConstant: CGFloat(heights[i])),
                        candleView.widthAnchor.constraint(equalToConstant: candleWidth),
                        candleView.topAnchor.constraint(equalTo: primaryView.bottomAnchor),
                        candleView.leadingAnchor.constraint(equalTo: primaryView.trailingAnchor, constant: 5),
                    ])
                }
                else if percentDiff > 0 && primaryPercent < 0{
                    NSLayoutConstraint.activate([
                        candleView.heightAnchor.constraint(equalToConstant: CGFloat(heights[i])),
                        candleView.widthAnchor.constraint(equalToConstant: candleWidth),
                        candleView.bottomAnchor.constraint(equalTo: primaryView.bottomAnchor),
                        candleView.leadingAnchor.constraint(equalTo: primaryView.trailingAnchor, constant: 5),
                    ])
                }
                else if percentDiff < 0 && primaryPercent > 0{
                    NSLayoutConstraint.activate([
                        candleView.heightAnchor.constraint(equalToConstant: CGFloat(heights[i])),
                        candleView.widthAnchor.constraint(equalToConstant: candleWidth),
                        candleView.topAnchor.constraint(equalTo: primaryView.topAnchor),
                        candleView.leadingAnchor.constraint(equalTo: primaryView.trailingAnchor, constant: 5),
                    ])
                }
            }
            primaryPercent = percentDiff
            primaryView = candleView
        }
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
        
        UIColor(red: 255/255, green: 206/255, blue: 47/255, alpha: 1).setStroke()
        let linePath = UIBezierPath()
        linePath.lineWidth = 2.0
        
        linePath.move(to: CGPoint(x: 0, y: height))
        
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
        linePath.addLine(to: CGPoint(x: rect.width, y: height))
        linePath.addLine(to: CGPoint(x: 0, y: height))
        UIColor(red: 255/255, green: 206/255, blue: 47/255, alpha: 0.5).setFill()
        linePath.fill()
    }

}
