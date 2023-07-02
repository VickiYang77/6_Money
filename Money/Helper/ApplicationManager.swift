//
//  kAM.swift
//  Money
//
//  Created by Vicki Yang on 2023/6/8.
//

import Foundation

typealias kAM = ApplicationManager

class ApplicationManager {
    static let share = ApplicationManager()
    private init() {}
    
    var types: [TypeModel] = [TypeModel.init(id: "recyPVeygabYnLQ84", createdTime: "2000-01-01 00:00:00", fields: TypeFieldsModel(typeID: "recBoPXAUe0KzP777", name: "Default", iconName: "slowmo", index: 0))]
    
    func getTypeWithId(_ typeID: String) -> TypeModel {
        return kAM.share.types.first(where: { $0.fields.typeID == typeID }) ?? firstTypeModel
    }
    
    private var firstTypeModel: TypeModel {
        if types.count > 2 {
            return kAM.share.types[1]
        } else {
            return kAM.share.types.first! //Default
        }
    }
}
