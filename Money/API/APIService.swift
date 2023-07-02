//
//  APIService.swift
//  Money
//
//  Created by Vicki Yang on 2023/5/28.
//

import Foundation

enum dataBaseTableType: String {
    case record     = "Record"
    case type       = "Type"
}

class APIService {
    static let share = APIService()
    private init() {}
    
    private let apiUrl = "https://api.airtable.com/v0/appLrblBIgiRkLHYX/"
    
    private func createRequest(_ tableType: dataBaseTableType, urlCommand: String = "") -> URLRequest {
        var request = URLRequest(url: URL(string: apiUrl + tableType.rawValue + urlCommand)!)
        request.setValue("Bearer patBLWqEleL1fNLbj.dafb055ae0ad65d8eb8404eb145eb37f4823f0a696e2521808a9b4d38f57415f", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    func fetch<T: Decodable>(_ tableType: dataBaseTableType, completion: @escaping (T?) -> Void) {
        var urlCommand = ""
        
        switch tableType {
        case .record:
            urlCommand = "?sort[0][field]=date&sort[0][direction]=desc&sort[1][field]=updateTime&sort[1][direction]=desc"
        case .type:
            urlCommand = "?sort[0][field]=index&sort[0][direction]=asc"
        }
        
        var request = createRequest(tableType, urlCommand: urlCommand)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard let data = data, error == nil else {
                print("vvv_Error")
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                let response = try decoder.decode(T.self, from: data)
                completion(response)
            } catch {
                print("vvv_解析錯誤：\(error)")
                completion(nil)
            }
        }.resume()
    }
    
    func insert<T: Encodable>(_ tableType: dataBaseTableType, data: T, completion: @escaping () -> Void) {
        var request = createRequest(tableType)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(data)
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard error == nil else {
                print("vvv_Error")
                return
            }
            
            completion()
        }.resume()
    }
    
    func update<T: Encodable>(_ tableType: dataBaseTableType, data: T, completion: @escaping () -> Void) {
        var request = createRequest(tableType)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(data)
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard error == nil else {
                print("vvv_Error")
                return
            }
            
            completion()
        }.resume()
    }
    
    func delete(_ tableType: dataBaseTableType, ids: [String], completion: @escaping () -> Void) {
        var deleteString = ""
        
        ids.forEach { id in
            deleteString += "records[]=\(id)"
        }
        
        var request = createRequest(tableType, urlCommand: "?\(deleteString)")
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard error == nil else {
                print("vvv_Error")
                return
            }
            
            completion()
        }.resume()
    }
}
