//
//  EditMenuModal.swift
//  CanteenMate
//
//  Created by Reinhart on 27/03/25.
//

import SwiftUI

struct EditMenuModal: View {
    @Binding var isPresented: Bool
    @Binding var item: MenuModel
    @State private var name: String = ""
    @State private var price: String = ""
    
    @Environment(\.modelContext) private var modelContext
    
    
    init(item: Binding<MenuModel>, isPresented: Binding<Bool>) {
        self._item = item
        self._isPresented = isPresented
        _name = State(initialValue: item.wrappedValue.name)
        _price = State(initialValue: String(item.wrappedValue.price))
    }
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                TextField("Price", text: $price)
                    .keyboardType(.decimalPad)
                Section {
                    Button(action: {
                            modelContext.delete(item)
                            try? modelContext.save()
                            isPresented = false
                    }) {
                        Text("Delete Item")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationBarItems(
                leading: Button("Cancel") {
                    isPresented = false
                },
                trailing: Button("Save") {
                    if let priceValue = Int(price) {
                        item.name = name
                        item.price = priceValue
                        try? modelContext.save()
                        isPresented = false
                    }
                }
            )
            .navigationTitle("Edit Menu Item")
        }
    }
}

//#Preview {
//    EditMenuModal()
//}
