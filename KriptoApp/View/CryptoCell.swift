//
//  CryptoCell.swift
//  KriptoApp
//
//  Created by Erkan on 2.05.2024.
//

import UIKit
import Kingfisher

class CryptoCell: UICollectionViewCell {

    let cryptoSymbolLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cryptoUsdtLabel: UILabel = {
       let label = UILabel()
        label.textColor = .lightGray
        label.text = "/USDT"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dayVolumeLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .lightGray
        return label
    }()
    
    let firstPriceLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .black)
        label.textColor = .white
        label.text = "63830"
        return label
    }()    
    
    let secondPriceLabel: UILabel = {
        let label = UILabel()
         label.translatesAutoresizingMaskIntoConstraints = false
         label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
         label.textColor = .lightGray
        label.text = "63830"
         return label
     }()
    
    let stackViewPrices: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.alignment = .trailing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let percentChangeLabel: UILabel = {
        let label = UILabel()
         label.translatesAutoresizingMaskIntoConstraints = false
         label.font = UIFont.systemFont(ofSize: 14, weight: .black)
         label.backgroundColor = .red
         label.textColor = .white
         label.layer.cornerRadius = 8
         label.text = "+0.15%"
         label.textAlignment = .center
         label.clipsToBounds = true
         return label
     }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    private func setupViews(){
        contentView.addSubview(cryptoSymbolLabel)
        cryptoSymbolLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        cryptoSymbolLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
         
        
        contentView.addSubview(cryptoUsdtLabel)
        cryptoUsdtLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        cryptoUsdtLabel.bottomAnchor.constraint(equalTo: cryptoSymbolLabel.bottomAnchor).isActive = true
        cryptoUsdtLabel.leadingAnchor.constraint(equalTo: cryptoSymbolLabel.trailingAnchor, constant: 0).isActive = true
        
        contentView.addSubview(dayVolumeLabel)
        dayVolumeLabel.topAnchor.constraint(equalTo: cryptoSymbolLabel.bottomAnchor, constant: 6).isActive = true
        dayVolumeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        
        
        contentView.addSubview(percentChangeLabel)
        percentChangeLabel.topAnchor.constraint(equalTo: cryptoSymbolLabel.topAnchor, constant: 4).isActive = true
        percentChangeLabel.bottomAnchor.constraint(equalTo: dayVolumeLabel.bottomAnchor, constant: -4).isActive = true
        percentChangeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        percentChangeLabel.widthAnchor.constraint(equalToConstant: 90).isActive = true
        
        
        contentView.addSubview(stackViewPrices)
        stackViewPrices.topAnchor.constraint(equalTo: percentChangeLabel.topAnchor, constant: 0).isActive = true
        stackViewPrices.trailingAnchor.constraint(equalTo: percentChangeLabel.leadingAnchor, constant: -20).isActive = true
        stackViewPrices.addArrangedSubview(firstPriceLabel)
        stackViewPrices.addArrangedSubview(secondPriceLabel)
        

        
       /* contentView.addSubview(stackViewPrices)
        stackViewPrices.addArrangedSubview(firstPriceLabel)
        stackViewPrices.addArrangedSubview(secondPriceLabel)*/


    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func configure(coin: Coin?){
    
        guard let coin = coin else{return}
        
        cryptoSymbolLabel.text = coin.symbol
        dayVolumeLabel.text = formatVolume(coin.the24HVolume)
        
        guard let change = coin.change, let changeValue = Float(change) else { return }

        if changeValue > 0.0 {
            percentChangeLabel.backgroundColor = UIColor(red: 68/255, green: 200/255, blue: 130/255, alpha: 1)
        } else {
            percentChangeLabel.backgroundColor = UIColor(red: 255/255, green: 75/255, blue: 75/255, alpha: 1)
        }

        percentChangeLabel.text = "\(change)%"
        
        guard let price = coin.price, let priceFloat = Float(price) else { return }

        let formattedPrice = String(format: "%.4f", priceFloat)
        firstPriceLabel.text = formattedPrice
        
        let formattedPrice2 = String(format: "%.2f", priceFloat)
        secondPriceLabel.text = formattedPrice2 + " $"

        
    }
    
    
    func formatVolume(_ volume: String?) -> String {
        guard let volumeStr = volume, let volumeDouble = Double(volumeStr) else {
            return "N/A"
        }
        
        let absVolume = abs(volumeDouble)
        let sign = (volumeDouble < 0) ? "-" : ""
        
        switch absVolume {
        case 0..<1_000_000:
            return "\(sign)\(volumeDouble)"
        case 1_000_000..<1_000_000_000:
            let millionVolume = volumeDouble / 1_000_000
            return "\(sign)\(String(format: "%.2f", millionVolume))M"
        default:
            let billionVolume = volumeDouble / 1_000_000_000
            return "\(sign)\(String(format: "%.2f", billionVolume))B"
        }
    }
}
