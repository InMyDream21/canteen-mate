//
//  Encome.swift
//  CanteenMate
//
//  Created by Chairal Octavyanz on 02/04/25.
//

import Foundation

import SwiftUI

struct ExpenseView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var isIncomeMode: Bool
    @State private var date = Date()
    @State private var amount: String = ""
    @State private var title: String = ""
    @State private var description: String = ""
    @Environment(\.modelContext) private var context
    
    @State private var showCancelAlert = false
    @State private var showMissingFieldsAlert = false
    
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
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack {
                HStack {
                    CancelDoneButtonView(
                        content: {
                            Image(systemName: "xmark")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(.black)
                        },
                        action: {
                            if !title.isEmpty || (Int(amount) ?? 0) > 0 || !description.isEmpty {
                                showCancelAlert = true
                            } else {
                                dismiss()
                            }
                        }
                    )
                    Spacer()
                }
                .padding(20)
                
                //                IncomeExpenseButtonView(isIncomeMode: $isIncomeMode)
                
                HStack{
                    Text("Add Expense")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.leading, 25)
                    Spacer()
                    
                    DatePickerView(selectedDate: $date)
                        .padding(.trailing, 25)
                }
                .padding(.bottom, 40)
                
                
                VStack(spacing: 12) {
                    //                    CustomTextFieldForDate(label: "Date", selectedDate: $date)
                    CustomTextFieldForTitle(label: "Title", text: $title)
                    CustomTextFieldForAmount(label: "Amount", text: $amount)
                    CustomTextFieldForDesc(label: "Description", text: $description)
                }
                .padding(.horizontal, 30)
                .padding(.top, 20)
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
                        if title.isEmpty || (Int(amount) ?? 0) <= 0 {
                            showMissingFieldsAlert = true
                        } else {
                            let newTransaction = Transaction(
                                name: title,
                                date: date,
                                amount: Int(amount) ?? 0,
                                type: .expense,
                                count: 1,
                                desc: description
                            )
                            context.insert(newTransaction)
                            dismiss()
                        }
                    }
                )
                
                Spacer()
            }
        }
        .alert("Clear this entry?", isPresented: $showCancelAlert) {
            Button("Reset and Exit", role: .destructive) {
                resetForm()
                dismiss()
            }
            Button("Stay", role: .cancel) {}
        } message: {
            Text("You have unsaved data. Are you sure you want to cancel?")
        }
        .alert("Please fill in title and amount!", isPresented: $showMissingFieldsAlert) {
            Button("OK", role: .cancel) {}
        }
    }
    
    func resetForm() {
        title = ""
        amount = ""
        description = ""
        date = Date()
    }
}

#Preview {
    ExpenseView(isIncomeMode: .constant(true))
}
