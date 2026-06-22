//
//  IncomeModeCustom.swift
//  CanteenMate
//
//  Created by Chairal Octavyanz on 02/04/25.
//

import SwiftUI

struct IncomeModeCustomView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var isCustomMode: Bool
    @Binding var isIncomeMode: Bool
    @State private var selectedDate: Date = Date()
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
    
    var headerSection: some View {
        HStack {
            CancelDoneButtonView(
                content: {
                    Image(systemName: "xmark")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.black)
                },
                action: {
                    if !title.isEmpty || (Int(amount) ?? 0 <= 0) || !description.isEmpty {
                        showCancelAlert = true
                    } else {
                        dismiss()
                    }
                }
            )
            Spacer()
        }
        .padding(25)
    }
    
    var formSection: some View {
        VStack(spacing: 12) {
            CustomTextFieldForTitle(label: "Title", text: $title)
            CustomTextFieldForAmount(label: "Amount", text: $amount)
            CustomTextFieldForDesc(label: "Description", text: $description)
        }
        .padding(.horizontal, 30)
        .padding(.top, 20)
        .padding(.bottom, 32)
    }
    
    
    var body: some View {
        VStack {
            ZStack {
                Color.white.ignoresSafeArea()
                VStack {
                    ScrollView {
                        VStack {
                            headerSection
                            
                            HStack {
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
                            formSection
                            
                            CancelDoneButtonView(
                                content: {
                                    Text("Save")
                                        .font(.system(size: 16, weight: .medium))
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
                                            date: selectedDate,
                                            amount: Int(amount) ?? 0,
                                            type: .income,
                                            count: 1,
                                            desc: description
                                        )
                                        context.insert(newTransaction)
                                        dismiss()
                                    }
                                }
                            )
                        }
                    }
                    Spacer()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .alert("Clear this entry?", isPresented: $showCancelAlert) {
            Button("Reset and Exit", role: .destructive) {
                resetForm()
                dismiss()
            }
            Button("Stay", role: .cancel) {}
        } message: {
            Text("You have unsaved data. Are you sure you want to cancel?")
        }
    }
    
    func resetForm() {
        title = ""
        amount = ""
        description = ""
        selectedDate = Date()
    }
}

#Preview {
    IncomeModeCustomView(isCustomMode: .constant(false), isIncomeMode: .constant(true))
}
