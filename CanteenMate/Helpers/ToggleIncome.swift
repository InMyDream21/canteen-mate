import SwiftUI

struct ToggleView: View {
    @Binding var isCustomMode: Bool
    
    var body: some View {
        ZStack {
            // Background abu-abu untuk toggle
            Capsule()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 145, height: 26)
            
            // Capsule putih yang bergerak (menu/custom)
            HStack {
                if isCustomMode { Spacer() }
                
                Capsule()
                    .fill(Color.white)
                    .shadow(radius: 1)
                    .frame(width: 72.5, height: 26)
                
                if !isCustomMode { Spacer() }
            }
            .frame(width: 145)
            .animation(.easeInOut(duration: 0.2), value: isCustomMode)
            
            // Tombol teks
            HStack(spacing: 0) {
                Button(action: {
                    withAnimation { isCustomMode = false }
                }) {
                    Text("menu")
                        .frame(width: 72.5, height: 26)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(isCustomMode ? .gray : .black)
                }
                
                Button(action: {
                    withAnimation { isCustomMode = true }
                }) {
                    Text("custom")
                        .frame(width: 72.5, height: 26)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(isCustomMode ? .black : .gray)
                }
            }
        }
        .clipShape(Capsule())
        .overlay(Capsule().stroke(Color.black, lineWidth: 1))
    }
}

#Preview {
    ToggleView(isCustomMode: .constant(false))
}
