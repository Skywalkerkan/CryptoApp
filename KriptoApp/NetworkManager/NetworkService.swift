//
//  NetworkService.swift
//  KriptoApp
//
//  Created by Erkan on 1.05.2024.
//

import Foundation
import Alamofire


final class NetworkService{
    
    static let shared: NetworkService = {
        let instance = NetworkService()
        return instance
    }()
    
    private init() {}
    
    
    func cryptoRequest<T: Decodable>(request: URLRequestConvertible,
                                     decodeType type: T.Type,
                                     completion: @escaping (Result<T, Error>) -> Void){
        
        AF.request(request).responseData { [weak self] response in
            guard let self else{return}
    
            switch response.result{
            case .success(let data):
                
                do{
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedData))
                }catch{
                    print("json decode error!")
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
    
    
}
