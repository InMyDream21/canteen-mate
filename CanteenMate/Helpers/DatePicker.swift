import SwiftUI

struct DatePickerView: View {
    @Binding var selectedDate: Date
    @State private var showDatePicker = false

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
    }

    // Format tanggal seperti "18 March 2025"
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter.string(from: date)
    }
}

#Preview {
    DatePickerView(selectedDate: .constant(Date()))
}
