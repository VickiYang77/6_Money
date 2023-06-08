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
    
    lazy var types: [TypeModel] = {
        var types: [TypeModel] = []
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()

        APIService.share.fetchTypes { typesModel in
            types = typesModel
            dispatchGroup.leave()
        }

        dispatchGroup.wait()
        return types
    }()
}
