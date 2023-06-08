//
//  TypesModel.swift
//  Money
//
//  Created by Vicki Yang on 2023/6/8.
//

import UIKit

struct TypesModel: Codable {
    let records: [TypeModel]
}

struct TypeModel: Codable {
    let id: String
    let createdTime: String
    let fields: TypeFieldsModel
}

struct TypeFieldsModel: Codable {
    let typeID: String
    let name: String
    let icon: String
    let index: Int
    
    init(typeID: String, name: String, iconName: String = "", index: Int) {
        self.typeID = typeID
        self.name = name
        self.icon = iconName
        self.index = index
    }
}
