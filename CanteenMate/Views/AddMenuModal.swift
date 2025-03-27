//
//  AddMenuModal.swift
//  CanteenMate
//
//  Created by Reinhart on 27/03/25.
//

import SwiftUI

struct AddMenuModal: View {
    @Binding var isPresented: Bool
    @State private var name: String = ""
    @State private var price: String = ""
    
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                TextField("Price", text: $price)
                    .keyboardType(.decimalPad)
            }
            .navigationBarItems(
                leading: Button("Cancel") {
                    isPresented = false
                },
                trailing: Button("Done") {
                    if let priceValue = Int(price) {
                        let newItem = MenuModel(name: name, price: priceValue)
                        modelContext.insert(newItem)
                        try? modelContext.save()
                        isPresented = false
                    }
                }
            )
            .navigationTitle("Add Menu Item")
        }
    }
}

//#Preview {
//    AddMenuModal()
//}
