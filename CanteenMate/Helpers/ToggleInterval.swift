import SwiftUI

struct ToggleInterval: View {
    //    @Binding var isCustomMode: Bool
    
    @State private var isMonthly = false
    @State private var selectedDate = Date()
    
    var body: some View {
        HStack(spacing: 6) {
            
            // MARK: - Segmented Capsule Toggle
            ZStack {
                // Background abu-abu untuk toggle
                Capsule()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 145, height: 26)
                
                // Capsule putih yang bergerak (menu/custom)
                HStack {
                    if isMonthly { Spacer() }
                    
                    Capsule()
                        .fill(Color.white)
                        .shadow(radius: 1)
                        .frame(width: 72.5, height: 26)
                    
                    if !isMonthly { Spacer() }
                }
                .frame(width: 145)
                .animation(.easeInOut(duration: 0.2), value: isMonthly)
                
                // Tombol teks
                HStack(spacing: 0) {
                    Button(action: {
                        withAnimation { isMonthly = false }
                    }) {
                        Text("Daily")
                            .frame(width: 72.5, height: 26)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(isMonthly ? .gray : .black)
                    }
                    
                    Button(action: {
                        withAnimation { isMonthly = true }
                    }) {
                        Text("Monthly")
                            .frame(width: 72.5, height: 26)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(isMonthly ? .black : .gray)
                    }
                }
            }
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            
            if !isMonthly {
                DailyPickerView(selectedDate: $selectedDate)
            } else {
                YearMonthPickerView(selectedDate: $selectedDate)
                    .padding(.leading, 18)
            }
        }
        
    }
}
    
    #Preview {
        ToggleInterval()
    }

