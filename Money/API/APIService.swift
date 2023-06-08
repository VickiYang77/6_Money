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
    
    private let url = "https://api.airtable.com/v0/appLrblBIgiRkLHYX/"
    
    private func createRequest(type: dataBaseTableType, url: String = "") -> URLRequest {
        var request = URLRequest(url: URL(string: self.url+type.rawValue+url)!)
        request.setValue("Bearer patBLWqEleL1fNLbj.dafb055ae0ad65d8eb8404eb145eb37f4823f0a696e2521808a9b4d38f57415f", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    // MARK: - Record API
    func fetchRecords(completion: @escaping ([RecordModel]) -> Void) {
        var request = createRequest(type: .record, url: "?sort[0][field]=date&sort[0][direction]=desc&sort[1][field]=updateTime&sort[1][direction]=desc")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard let data = data, error == nil else {
                print("vvv_Error")
                return
            }
            
            do {
                let response = try JSONDecoder().decode(RecordsModel.self, from: data)
                completion(response.records)
            } catch {
                print("vvv_解析錯誤：\(error)")
            }
        }.resume()
    }
    
    func insertRecords(_ items: InsertRecordRequest, completion: @escaping () -> Void) {
        var request = createRequest(type: .record)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(items)
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard error == nil else {
                print("vvv_Error")
                return
            }
            
            completion()
        }.resume()
    }
    
    func updateRecords(_ items: updateRecordRequest, completion: @escaping () -> Void) {
        var request = createRequest(type: .record)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(items)
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard error == nil else {
                print("vvv_Error")
                return
            }
            
            completion()
        }.resume()
    }
    
    func deleteRecords(_ ids: [String], completion: @escaping () -> Void) {
        var deleteString = ""
        
        ids.forEach { id in
            deleteString += "records[]=\(id)"
        }
        
        var request = createRequest(type: .record, url: "?\(deleteString)")
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard error == nil else {
                print("vvv_Error")
                return
            }
            
            completion()
        }.resume()
    }
    
    
    // MARK: - Type API
    func fetchTypes(completion: @escaping ([TypeModel]) -> Void) {
        var request = createRequest(type: .type, url: "?sort[0][field]=index&sort[0][direction]=asc")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard let data = data, error == nil else {
                print("vvv_Error")
                return
            }
            
            do {
                let response = try JSONDecoder().decode(TypesModel.self, from: data)
                completion(response.records)
            } catch {
                print("vvv_解析錯誤：\(error)")
            }
        }.resume()
    }
    
    func insertTypes(_ items: InsertTypeRequest, completion: @escaping () -> Void) {
        var request = createRequest(type: .type)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(items)
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard error == nil else {
                print("vvv_Error")
                return
            }
            
            completion()
        }.resume()
    }
    
    func updateTypes(_ items: updateTypeRequest, completion: @escaping () -> Void) {
        var request = createRequest(type: .type)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(items)
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard error == nil else {
                print("vvv_Error")
                return
            }
            
            completion()
        }.resume()
    }
    
    func deleteTypes(_ ids: [String], completion: @escaping () -> Void) {
        var deleteString = ""
        
        ids.forEach { id in
            deleteString += "records[]=\(id)"
        }
        
        var request = createRequest(type: .type, url: "?\(deleteString)")
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
