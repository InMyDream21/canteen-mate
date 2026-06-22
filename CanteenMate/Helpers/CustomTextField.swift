import SwiftUI

struct CustomTextFieldForTitle: View {
    var label: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image("icon_title")
                .resizable()
                .frame(width: 24, height: 21)
                .foregroundColor(.black)
                .frame(width: 30, alignment: .center)
                .padding(.leading, 16)
            
            Spacer()
            
            TextField("Title", text: $text)
                .foregroundColor(.gray)
            
        }
        .frame(width: 333, height: 54)
        .background(Color(hex: "#F0F0F0"))
        .cornerRadius(10)
    }
}

struct CustomTextFieldForAmount: View {
    var label: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image("icon_amount")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(.black)
                .frame(width: 30, alignment: .center)
                .padding(.leading, 16)
            
            Spacer()
            
            TextField("Amount", text: $text)
                .keyboardType(.numberPad)
                .foregroundColor(.gray)
            
        }
        .frame(width: 333, height: 54)
        .background(Color(hex: "#F0F0F0"))
        .cornerRadius(10)    }
}

struct CustomTextFieldForQuantity: View {
    var label: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image("icon_quantity")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(.black)
                .frame(width: 30, alignment: .center)
                .padding(.leading, 16)
            
            Spacer()
            
            TextField("Amount", text: $text)
                .keyboardType(.numberPad)
                .foregroundColor(.gray)
            
        }
        .frame(width: 333, height: 54)
        .background(Color(hex: "#F0F0F0"))
        .cornerRadius(10)    }
}

struct CustomTextFieldForDesc: View {
    var label: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image("icon_desc")
                .resizable()
                .frame(width: 24, height: 15)
                .foregroundColor(.black)
                .frame(width: 30, alignment: .center)
                .padding(.leading, 16)
            
            Spacer()
            
            TextField("Description", text: $text)
                .foregroundColor(.gray)
            
        }
        .frame(width: 333, height: 54)
        .background(Color(hex: "#F0F0F0"))
        .cornerRadius(10)
    }
}


struct CustomTextFieldForCategory: View {
    var label: String
    @Binding var selectedCategory: String
    
    let categories = ["Food", "Drinks", "Snack"]

    var body: some View {
        SwiftUI.Menu {
            ForEach(categories, id: \.self) { category in
                Button {
                    selectedCategory = category
                } label: {
                    Text(category)
                }
            }
        } label: {
            HStack(spacing: 12) {
                Image("icon_category")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.black)
                    .padding(.leading, 16)

                Text(selectedCategory.isEmpty ? label : selectedCategory)
                    .foregroundColor(selectedCategory.isEmpty ? .gray : .black)

                Spacer()

                Image(systemName: "chevron.down")
                    .foregroundColor(.gray)
                    .padding(.trailing, 16)
            }
            .frame(width: 333, height: 54)
            .background(Color(hex: "#F0F0F0"))
            .cornerRadius(10)
        }
    }
}

struct CustomTextFieldForDate: View {
    
    @Binding var selectedDate: Date
    @State private var showDatePicker = false
//    var label: String
//    @Binding var selectedDate: Date
    
    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 6) {
                Image(systemName: "calendar")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14, height: 14)
                    .foregroundColor(.black)

                Text(formattedDate(selectedDate))
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.black)
            }
            .frame(width: 124, height: 28)
            .background(Color.gray.opacity(0.3))
            .clipShape(Capsule())
            .onTapGesture {
                withAnimation {
                    showDatePicker.toggle()
                }
            }

            if showDatePicker {
                DatePicker("", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                    .padding(.top, 4)
            }
        }
//        
//        HStack {
//            Text(label)
//                .font(.system(size: 18, weight: .medium))
//                .foregroundColor(.black)
//                .frame(width: 100, alignment: .leading) // Fixed width for label
//            
//            DatePicker("", selection: $selectedDate, displayedComponents: .date)
//                .datePickerStyle(CompactDatePickerStyle())
//                .labelsHidden() // Hide label to prevent extra spacing
//                .frame(maxWidth: .infinity, alignment: .leading) // Force DatePicker to align left
//        }
//        .frame(width: 333, height: 54)
//        .background(Color(hex: "#F0F0F0"))
//        .cornerRadius(10)
//        .frame(maxWidth: .infinity, alignment: .leading) // Ensure the whole HStack aligns left
    }
    
    // Format tanggal seperti "18 March 2025"
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter.string(from: date)
    }
}


//#Preview{
//    CustomTextFieldForAmount(
//        label: "Quantity",
//        text: Binding(
//            get: { String(transaction.count) },
//            set: { transaction.count = Int($0) ?? 0 }
//        )
//    )
//}

#Preview {
    CustomTextFieldForCategory(label: "Category", selectedCategory: .constant("Food"))
}

