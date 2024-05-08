//
//  CyptoLogic.swift
//  KriptoApp
//
//  Created by Erkan on 1.05.2024.
//

import Foundation

final class CryptoLogic: CryptoProtocol{
  
    static let shared: CryptoLogic = {
        let instance = CryptoLogic()
        return instance
    }()
    
    private init(){}
    
    func getAllCryptos(completion: @escaping (Result<CryptoResult, any Error>) -> Void) {
        NetworkService.shared.cryptoRequest(request: Router.allCrpytos,
                                            decodeType: CryptoResult.self,
                                            completion: completion)
    }
}
