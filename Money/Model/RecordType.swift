//
//  RecordType.swift
//  Money
//
//  Created by Vicki Yang on 2023/6/6.
//

enum RecordType {
    case none
    case dailyNecessities
    case breakfast
    case lunch
    case dinner
    case dessert
    case drinks
    case shopping
    case transportation
    case gift
    
    var icon: String {
        switch self {
        case .none:                 return "dollarsign.circle"
        case .dailyNecessities:     return "cart"
        case .breakfast:            return "fork.knife"
        case .lunch:                return "fork.knife"
        case .dinner:               return "fork.knife"
        case .dessert:              return "fork.knife"
        case .drinks:               return "cup.and.saucer"
        case .shopping:             return "bag"
        case .transportation:       return "tram"
        case .gift:                 return "gift"
        }
    }
}
