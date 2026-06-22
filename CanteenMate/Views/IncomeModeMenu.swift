//
//  IncomeModeMenu.swift
//  CanteenMate
//
//  Created by Chairal Octavyanz on 02/04/25.
//

import SwiftUI
import SwiftData

struct IncomeModeMenuView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var isCustomMode: Bool
    @Binding var isIncomeMode: Bool
    @State private var selectedDate: Date = Date()
    
    @Environment(\.modelContext) private var context
    @Query private var menuModels: [MenuModel]
    
    @State private var itemQuantities: [UUID: Int] = [:]
    
    var totalPrice: Int {
        menuModels.reduce(0) { total, item in
            let qty = itemQuantities[item.id] ?? 0
            return total + item.price * qty
        }
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
        VStack {
            ZStack {
                Color.white.ignoresSafeArea()
                VStack {
                    ScrollView {
                        VStack {
                            HStack {
                                CancelDoneButtonView(
                                    content: {
                                        Image(systemName: "xmark")
                                            .font(.system(size: 30, weight: .bold))
                                            .foregroundColor(.black)
                                    },
                                    action: {
                                        dismiss()
                                    }
                                )
                                
                                Spacer()
                            }
                            .padding(25)
                            
                            HStack{
                                Text("Add Income")
                                    .font(.system(size: 30, weight: .bold))
                                    .foregroundColor(.black)
                                    .padding(.leading, 25)
                                Spacer()
                                
                                DatePickerView(selectedDate: $selectedDate)
                                    .padding(.trailing, 25)
                            }
                            .padding(.bottom, 32)
                            
                            ToggleView(isCustomMode: $isCustomMode)
                                .padding(.bottom, 20)
                            
                            //                            IncomeExpenseButtonView(isIncomeMode: $isIncomeMode)
                            
                            ForEach(menuModels) { item in
                                MenuCashierCard(
                                    title: item.name,
                                    price: item.price,
                                    numberOfTotal: Binding(
                                        get: { itemQuantities[item.id] ?? 0 },
                                        set: { itemQuantities[item.id] = $0 }
                                    )
                                )
                            }
                            
                            Spacer()
                        }
                    }
                    .overlay {
                        if menuModels.isEmpty {
                            ContentUnavailableView(label: {
                                Label("No Menu", systemImage: "list.bullet.rectangle.portrait")
                            }, description: {
                                Text("Start adding menus to see your list.")
                            })
                            .offset(y: 80)
                        }
                    }
                    
                    //total box
                    VStack {
                        HStack {
                            Text("Total: ")
                                .font(.system(size: 18, weight: .regular))
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            Text("\(totalPrice.formattedWithSeparator())")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                        }
                        .padding(.horizontal, 40)
                        .padding(.top, 14)
                        .padding(.bottom, 10)
                        
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
                                print("Income from menu saved:")
                                for item in menuModels {
                                    let qty = itemQuantities[item.id] ?? 0
                                    if qty > 0 {
                                        let newTransaction = Transaction(
                                            name: item.name,
                                            date: selectedDate,
                                            amount: item.price * qty,
                                            type: .income,
                                            count: qty
                                        )
                                        context.insert(newTransaction)
                                        print("- \(item.name): \(qty) x \(Int(item.price))")
                                    }
                                }
                                print("Total: \(totalPrice)")
                                dismiss()
                            }
                        )
                    }
                    .frame(maxWidth: .infinity, maxHeight: 140)
                    .background(Color(hex: "#F4F4F4"))
                    
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        }
        .onAppear {
            for item in menuModels {
                if itemQuantities[item.id] == nil {
                    itemQuantities[item.id] = 0
                }
            }
        }
    }
}


#Preview {
    PreviewContainerView()
}
