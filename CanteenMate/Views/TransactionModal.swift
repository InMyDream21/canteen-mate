import SwiftUI

struct TransactionModal: View {
    @Environment(\.modelContext) private var context
    @State private var isCustomMode: Bool = false
    @State private var isIncomeMode: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                if !isIncomeMode {
                    ZStack {
                        if isCustomMode {
                            IncomeModeCustomView(isCustomMode: $isCustomMode, isIncomeMode: $isIncomeMode)
                                .transition(.identity)
                        } else {
                            IncomeModeMenuView(isCustomMode: $isCustomMode, isIncomeMode: $isIncomeMode)
                                .transition(.identity)
                        }
                    }
                    .animation(.linear, value: isCustomMode)
                } else {
                    ExpenseView(isIncomeMode: $isIncomeMode)
                        .transition(.identity)
                }
            }
        }
        .background(Color(.white))
//        .ignoresSafeArea(.container, edges: .bottom)
    }
}

#Preview {
    TransactionModal()
}

//Gak Kepake
