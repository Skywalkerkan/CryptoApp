//
//  CryptoProtocol.swift
//  KriptoApp
//
//  Created by Erkan on 1.05.2024.
//

import Foundation

protocol CryptoProtocol{
    func getAllCryptos(completion: @escaping(Result<CryptoResult, Error>) -> Void)
}
