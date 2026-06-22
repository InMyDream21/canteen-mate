import SwiftUI
import SwiftData

struct AddMenuModal: View {
    @Binding var isPresented: Bool
    
    @State private var name: String = ""
    @State private var price: String = ""
    @State private var selectedCategory = "Food"
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @Environment(\.modelContext) private var modelContext

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
            VStack {
                // Header
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

                // Title
                HStack {
                    Text("Add Menu")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.leading, 25)
                    Spacer()
                }
                .padding(.bottom, 20)

                // Input Fields
                VStack(spacing: 12) {
                    CustomTextFieldForTitle(label: "Title", text: $name)
                    CustomTextFieldForAmount(label: "Amount", text: $price)
                    CustomTextFieldForCategory(label: "Category", selectedCategory: $selectedCategory)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 32)

                // Save Button
                CancelDoneButtonView(
                    content: {
                        Text("Save")
                            .font(.system(size: 16, weight: .medium))
                            .frame(width: 333, height: 45)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    },
                    action: saveMenu
                )
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Invalid Input"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
        }
    }

    // MARK: - Save Logic
    private func saveMenu() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty else {
            alertMessage = "Please enter a valid name."
            showAlert = true
            return
        }

        guard let intPrice = Int(price), intPrice > 0 else {
            alertMessage = "Price must be greater than zero."
            showAlert = true
            return
        }

        let newItem = MenuModel(name: trimmedName, price: intPrice, category: selectedCategory)
        do {
            modelContext.insert(newItem)
            try modelContext.save()
            isPresented = false
        } catch {
            alertMessage = "Failed to save menu: \(error.localizedDescription)"
            showAlert = true
        }
    }
}

#Preview {
    AddMenuModal(isPresented: .constant(false))
}
