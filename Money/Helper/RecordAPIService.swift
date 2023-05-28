//
//  RecordAPIService.swift
//  Money
//
//  Created by Vicki Yang on 2023/5/28.
//

import Foundation

class RecordAPIService {
    private let url = "https://api.airtable.com/v0/appLrblBIgiRkLHYX/Record"
    
    private func createRequest(url: String = "") -> URLRequest {
        var request = URLRequest(url: URL(string: self.url+url)!)
        request.setValue("Bearer patBLWqEleL1fNLbj.dafb055ae0ad65d8eb8404eb145eb37f4823f0a696e2521808a9b4d38f57415f", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    func fetchRecords(completion: @escaping ([RecordModel]) -> Void) {
        var request = self.createRequest(url: "?sort[0][field]=date&sort[0][direction]=desc&sort[1][field]=createdTime&sort[1][direction]=desc")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard let data = data, error == nil else {
                print("vvv_Error")
                return
            }
            
            do {
                let response = try JSONDecoder().decode(RecordsResponse.self, from: data)
                let recordModels = response.records.map { $0.fields }
                completion(recordModels)
            } catch {
                print("vvv_解析錯誤：\(error)")
            }
        }.resume()
    }
}
