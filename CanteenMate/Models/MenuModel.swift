//
//  MenuModel.swift
//  CanteenMate
//
//  Created by Reinhart on 27/03/25.
//

import Foundation
import SwiftData

@Model
class MenuModel: Identifiable {
    var id: UUID
    var name: String
    var price: Int
    var category: String
    
    init(name: String, price: Int, category: String) {
        self.id = UUID()
        self.name = name
        self.price = price
        self.category = category
    }
}


