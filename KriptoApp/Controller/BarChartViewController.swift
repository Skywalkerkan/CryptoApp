//
//  BarChartViewController.swift
//  KriptoApp
//
//  Created by Erkan on 2.05.2024.
//

import UIKit

class BarChartViewController: UIViewController {
    
    var primaryPercent: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Örnek veri oluşturma
        let data: [Float] = [100, 102, 103, 100, 98, 120, 115, 118, 119, 110, 95]
        
        // En yüksek ve en düşük değerleri bul
        let maxValue = data.max() ?? 0
        let minValue = data.min() ?? 0
        
        let percentageDifference = (maxValue - minValue) / minValue * 100
        
        
        
        // CandlestickView oluşturma
        let backView = UIView()
        backView.translatesAutoresizingMaskIntoConstraints = false
        backView.backgroundColor = .lightGray
        
        backView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        backView.widthAnchor.constraint(equalToConstant: 400).isActive = true
        
        
        var primaryView = UIView()
        
        var constantHeight: Float = 0.0

        
        for i in 0...9{
            let percentDiff = (data[i + 1] - data[i]) / data[i] * 100
            if percentDiff < 5{
               constantHeight = 10
            }
        }
        
        for i in 0...9 { // İki label oluşturacağız
            let candleView = UIView()
            candleView.translatesAutoresizingMaskIntoConstraints = false
            candleView.backgroundColor = .black
            
            
            let percentDiff = (data[i + 1] - data[i]) / data[i] * 100
            let differenceHepsi = data[i] / (maxValue + minValue)
            
            
            
            let ikisininOran = 300 * (1-differenceHepsi)
            print(differenceHepsi)
            let difference = data[i+1] - data[i]
            
            let candleHeight: CGFloat = abs(CGFloat(percentDiff + constantHeight).rounded())
            
            

            backView.addSubview(candleView)
            
            //print(percentDiff)
            if i == 0{
                NSLayoutConstraint.activate([
                    candleView.heightAnchor.constraint(equalToConstant: candleHeight), // Yükseklik
                    candleView.widthAnchor.constraint(equalToConstant: 20),
                    candleView.topAnchor.constraint(equalTo: backView.bottomAnchor, constant: CGFloat(ikisininOran)),
                    candleView.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 10), // Sol kenar
                ])
                if percentDiff > 0{
                    candleView.backgroundColor = .green
                }else{
                    candleView.backgroundColor = .red
                }
            }else{
                if percentDiff > 0 && primaryPercent > 0{
                    NSLayoutConstraint.activate([
                        candleView.heightAnchor.constraint(equalToConstant: candleHeight), // Yükseklik
                        candleView.widthAnchor.constraint(equalToConstant: 20),
                        candleView.bottomAnchor.constraint(equalTo: primaryView.topAnchor),
                        candleView.leadingAnchor.constraint(equalTo: primaryView.trailingAnchor, constant: 10), // Sol kenar
                    ])
                    candleView.backgroundColor = .green
                }else if percentDiff < 0 && primaryPercent < 0{
                    NSLayoutConstraint.activate([
                        candleView.heightAnchor.constraint(equalToConstant: candleHeight), // Yükseklik
                        candleView.widthAnchor.constraint(equalToConstant: 20),
                        candleView.topAnchor.constraint(equalTo: primaryView.bottomAnchor),
                        candleView.leadingAnchor.constraint(equalTo: primaryView.trailingAnchor, constant: 10), // Sol kenar
                    ])
                    candleView.backgroundColor = .red
                }
                else if percentDiff > 0 && primaryPercent < 0{
                    NSLayoutConstraint.activate([
                        candleView.heightAnchor.constraint(equalToConstant: candleHeight), // Yükseklik
                        candleView.widthAnchor.constraint(equalToConstant: 20),
                        candleView.bottomAnchor.constraint(equalTo: primaryView.bottomAnchor),
                        candleView.leadingAnchor.constraint(equalTo: primaryView.trailingAnchor, constant: 10), // Sol kenar
                    ])
                    candleView.backgroundColor = .green
                }
                else if percentDiff < 0 && primaryPercent > 0{
                    NSLayoutConstraint.activate([
                        candleView.heightAnchor.constraint(equalToConstant: candleHeight), // Yükseklik
                        candleView.widthAnchor.constraint(equalToConstant: 20),
                        candleView.topAnchor.constraint(equalTo: primaryView.topAnchor),
                        candleView.leadingAnchor.constraint(equalTo: primaryView.trailingAnchor, constant: 10), // Sol kenar
                    ])
                    candleView.backgroundColor = .red
                }
                
               
            }
            primaryPercent = percentDiff
            primaryView = candleView
        }

        
        
        
        

        // CandlestickView'i eklemek
        view.addSubview(backView)
    }
}

