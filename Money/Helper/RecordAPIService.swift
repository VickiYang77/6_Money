//
//  RecordAPIService.swift
//  Money
//
//  Created by Vicki Yang on 2023/5/28.
//

import Foundation

class RecordAPIService {
    static let share = RecordAPIService()
    
    private let url = "https://api.airtable.com/v0/appLrblBIgiRkLHYX/Record"
    
    private func createRequest(url: String = "") -> URLRequest {
        var request = URLRequest(url: URL(string: self.url+url)!)
        request.setValue("Bearer patBLWqEleL1fNLbj.dafb055ae0ad65d8eb8404eb145eb37f4823f0a696e2521808a9b4d38f57415f", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    func fetchRecords(completion: @escaping ([RecordModel]) -> Void) {
        var request = createRequest(url: "?sort[0][field]=date&sort[0][direction]=desc&sort[1][field]=createdTime&sort[1][direction]=desc")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard let data = data, error == nil else {
                print("vvv_Error")
                return
            }
            
            do {
                let response = try JSONDecoder().decode(FetchRecordResponse.self, from: data)
                let records = response.records.map { $0.fields }
                completion(records)
            } catch {
                print("vvv_解析錯誤：\(error)")
            }
        }.resume()
    }
    
    func insertRecords(_ records: InsetRecordRequest, completion: @escaping () -> Void) {
        var request = createRequest()
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(records)
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard error == nil else {
                print("vvv_Error")
                return
            }
            
            completion()
        }.resume()
    }
}
