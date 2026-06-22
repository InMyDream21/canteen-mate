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
    
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @Environment(\.modelContext) private var modelContext
    
    
    init(item: Binding<MenuModel>, isPresented: Binding<Bool>) {
        self._item = item
        self._isPresented = isPresented
        _name = State(initialValue: item.wrappedValue.name)
        _price = State(initialValue: String(item.wrappedValue.price))
    }
    
    struct CancelDoneButtonView<Content: View>: View {
        let content: () -> Content
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                content()
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack{
                HStack {
                    CancelDoneButtonView(
                        content: {
                            Image(systemName: "xmark")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(.black)
                        },
                        action: {
                            isPresented = false
                        }
                    )
                    
                    Spacer()
                }
                .padding(25)
                
                HStack {
                    Text("Edit Menu")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Button(action: {
                        modelContext.delete(item)
                        try? modelContext.save()
                        isPresented = false
                    }) {
                        Text("Delete Item")
                            .font(.system(size:16, weight: .regular))
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal, 25)
                .padding(.bottom, 20)
                
                VStack(spacing: 12) {
                    CustomTextFieldForTitle(label: "Title", text: $name)
                    CustomTextFieldForAmount(label: "Amount", text: $price)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 32)
                
                CancelDoneButtonView(
                    content: {
                        Text("Save")
                            .font(.system(size: 16, weight: .medium)) // Ukuran dan berat font
                            .frame(width: 333, height: 45)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    },
                    action: {
                        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            alertMessage = "Please enter a valid name."
                            showAlert = true
                        } else if let priceValue = Int(price), priceValue > 0 {
                            item.name = name
                            item.price = priceValue
                            try? modelContext.save()
                            isPresented = false
                        } else {
                            alertMessage = "Price must be greater than zero."
                            showAlert = true
                        }
                    }

                )
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Invalid Input"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
        }
    }
}
    
    
    #Preview {
        EditMenuModal(item: .constant(MenuModel(name: "Sample Item", price: 10000, category: "Food")), isPresented: .constant(false))
    }
