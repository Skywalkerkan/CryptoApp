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
        default:
            let billionVolume = volumeDouble / 1_000_000_000
            return "\(sign)\(String(format: "%.2f", billionVolume))B"
        }
    }
}

