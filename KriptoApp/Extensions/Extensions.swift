//
//  Extensions.swift
//  KriptoApp
//
//  Created by Erkan on 5.05.2024.
//

import Foundation

extension String {
    func formatVolume() -> String {
        guard let volumeDouble = Double(self) else {
            return "N/A"
        }
        
        let absVolume = abs(volumeDouble)
        let sign = (volumeDouble < 0) ? "-" : ""
        
        switch absVolume {
        case 0..<1_000_000:
            return "\(sign)\(self)"
        case 1_000_000..<1_000_000_000:
            let millionVolume = volumeDouble / 1_000_000
            return "\(sign)\(String(format: "%.2f", millionVolume))M"
        case 1_000_000_000..<1_000_000_000_000:
            let billionVolume = volumeDouble / 1_000_000_000
            return "\(sign)\(String(format: "%.2f", billionVolume))B"
        default:
            let trillionVolume = volumeDouble / 1_000_000_000_000
            return "\(sign)\(String(format: "%.2f", trillionVolume))T"
        }
    }
}

extension String {
    func formatPrice() -> (firstLabel: String, secondLabel: String) {
        var firstPrice = ""
        var secondPrice = ""
        
        if let dotRange = self.range(of: ".") {
            let fractionPart = self[dotRange.upperBound...]
            let fractionDigits = Array(fractionPart)
            var count = 0
            for digit in fractionDigits {
                if digit != "0" {
                    break
                }
                count += 1
            }
            
            let priceFloat = (self as NSString).floatValue
            
            if count > 2 {
                firstPrice = String(format: "%.\(count + 3)f", priceFloat)
                secondPrice = String(format: "%.\(count + 2)f", priceFloat) + " $"
            } else {
                firstPrice = String(format: "%.3f", priceFloat)
                secondPrice = String(format: "%.2f", priceFloat) + " $"
            }
        }
        
        return (firstPrice, secondPrice)
    }
}




