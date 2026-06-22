import SwiftUI
import SwiftData

struct EditTransactionView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var transaction: Transaction
    
    @State private var showCancelAlert = false
    @State private var showMissingFieldsAlert = false
    @State private var showDeleteAlert = false
    @Environment(\.modelContext) private var context
    
    
    
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
                Color(.white)
                    .ignoresSafeArea()
                
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
                                        showCancelAlert = true
                                    }
                                    
                                )
                                
                                Spacer()
                            }
                            .padding(25)
                            
                            HStack {
                                Text("Edit Transaction")
                                    .font(.system(size: 26, weight: .bold))
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                Button(role: .destructive) {
                                    showDeleteAlert = true
                                } label: {
                                    Text("Delete")
                                        .font(.system(size:16, weight: .regular))
                                        .foregroundColor(.red)
                                }
                            }
                            .padding(.horizontal, 25)
                            .padding(.bottom, 20)
                            
                            VStack(spacing: 12) {
                                CustomTextFieldForTitle(label: "Title", text: $transaction.name)
                                CustomTextFieldForAmount(
                                    label: "Amount",
                                    text: Binding(
                                        get: { String(transaction.amount) },
                                        set: { transaction.amount = Int($0) ?? 0 }
                                    )
                                )
                                CustomTextFieldForDesc(label: "Description", text: Binding(
                                    get: { transaction.desc ?? "" },
                                    set: { transaction.desc = $0.isEmpty ? nil : $0 }
                                ))
                                CustomTextFieldForQuantity(
                                    label: "Quantity",
                                    text: Binding(
                                        get: { String(transaction.count) },
                                        set: { transaction.count = Int($0) ?? 0 }
                                    )
                                )
                                
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
                                        if transaction.name.isEmpty || transaction.amount <= 0 {
                                            showMissingFieldsAlert = true
                                        } else {
                                            dismiss()
                                        }
                                    }
                                    
                                )
                                .padding(.top, 32)
                            }
                            .padding()
                        }
                    }
                    Spacer()
                }
                .ignoresSafeArea(edges: .bottom)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .alert("Clear this entry?", isPresented: $showCancelAlert) {
            Button("Discard Changes", role: .destructive) {
                dismiss()
            }
            Button("Stay", role: .cancel) {}
        } message: {
            Text("Are you sure you want to cancel editing this transaction?")
        }
        .alert("Please fill in title and amount!", isPresented: $showMissingFieldsAlert) {
            Button("OK", role: .cancel) {}
        }
        .alert("Delete this transaction?", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                context.delete(transaction)
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This action cannot be undone.")
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: Transaction.self)
    
    let sample = Transaction(
        name: "Sample",
        date: Date(),
        amount: 10000,
        type: .expense,
        count: 1,
        desc: "Preview transaction"
    )
    
    EditTransactionView(transaction: sample)
        .modelContainer(container)
}


