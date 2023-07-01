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
    
    @Published var typeFetching = false
    var types: [TypeModel] = []
    
    func getTypeWithId(_ typeID: String) -> TypeModel {
        return kAM.share.types.first(where: { $0.fields.typeID == typeID }) ?? kAM.share.types.first!
    }
}
