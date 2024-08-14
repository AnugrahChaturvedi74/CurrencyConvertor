//
//  APIManager.swift
//  CuurencyConvertor
//
//  Created by Anugrah on 04/08/24.
//

import Foundation

struct APIManager {
    
    func getApiData<T: Decodable>(url: URL, resultType: T.Type, completion: @escaping(Result<T,Error>) -> Void){
        
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            if data != nil && error == nil {
                guard let data else {
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let result  = try decoder.decode(T.self, from: data)
                    completion(.success(result))
                }
                catch (let err){
                    completion(.failure(err))
                }
            }
            
        }.resume()
    }
    
    
    func postApiData<T: Decodable>(url: URL, resultType: T.Type, params: Data ,completion: @escaping(Result<T,Error>) -> Void){
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "post"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = params
     
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            if data != nil && error == nil {
                guard let data else {
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let result  = try decoder.decode(T.self, from: data)
                    completion(.success(result))
                }
                catch (let err){
                    completion(.failure(err))
                }
            }
            
        }.resume()
    }
    
    
    
}
