import SwiftUI

struct DailyPickerView: View {
    @Binding var selectedDate: Date
    @State private var showDatePicker = false
    @State private var isShowingPicker = false

    var body: some View {
        VStack(spacing: 4) {
            Button(action: { isShowingPicker.toggle() }) {
                HStack {
                    Image(systemName: "chevron.down")
                        .foregroundColor(.secondary)
                    Text(formattedDate(selectedDate))
                        .foregroundColor(.primary)
                }
                .padding(14)
                .frame(height: 26)
                .background(Color.white)
                .overlay(
                    Capsule()
                        .stroke(Color.black, lineWidth: 1)
                    )
                .onTapGesture {
                                withAnimation {
                                    showDatePicker.toggle()
                                }
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
    DailyPickerView(selectedDate: .constant(Date()))
}
