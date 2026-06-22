import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedTab = 0
    
    
    @Environment(\.modelContext) private var context
    @State private var isCustomMode: Bool = false
    @State private var isIncomeMode: Bool = false
    
    @State private var isMonthly = true
    @State private var selectedDate = Date()
    @State private var isShowingTransactionModal = false
    @State private var isEmpty = false
    
    @Query private var transactions: [Transaction]
    @StateObject private var onboardingManager = OnboardingManager()
    @State private var showOnboarding = true
    @State private var isOnboardingShowing = true

    @State private var showAddExpense = false
    @State private var showAddIncome = false
    @State private var isAddMenuPresented = false
    
    
    var body: some View {
        ZStack {
            // Main content & navbar
            VStack(spacing: 0) {
                Group {
                    if selectedTab == 0 {
                        AnyView(RecapPage())
                    } else if selectedTab == 1 {
                        AnyView(MenuView(manager: onboardingManager, isShowing: $isOnboardingShowing))
                    } else {
                        AnyView(EmptyView())
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .ignoresSafeArea(.all, edges: .bottom)
                Spacer() // Push content to top
                
                // Custom Bottom Navigation Bar
                HStack {
                    Spacer()
                    Button(action: {
                        selectedTab = 0
                    }) {
                        Image(systemName: "chart.bar.doc.horizontal")
                            .font(.system(size: 25, weight: .semibold))
                            .foregroundColor(selectedTab == 0 ? .black : .gray)
                    }
                    Spacer()
                    Spacer()
                    Button(action: {
                        selectedTab = 1
                        // trigger guide4 secara manual
                        if onboardingManager.currentStep == .guide3 {
                            onboardingManager.triggerGuide4()
                        }
                    }) {
                        Image(systemName: "menucard")
                            .font(.system(size: 25, weight: .semibold))
                            .foregroundColor(selectedTab == 1 ? .black : .gray)
                    }

                    Spacer()
                }
                .frame(height: 70)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(20, corners: [.topLeft, .topRight])
                .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: -8)
                .ignoresSafeArea(.all, edges: .bottom)
            }
            
            // FAB Layer (selalu di atas semua)
            Group {
                if selectedTab == 0 {
                    TransactionFAB(
                        onExpense: {
                            showAddExpense = true
                        },
                        onIncome: {
                            showAddIncome = true
                        }
                    )
                    .sheet(isPresented: $showAddExpense) {
                        ExpenseView(isIncomeMode: $isIncomeMode)
                    }.sheet(isPresented: $showAddIncome) {
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
                        }
                    }
                }
                if showOnboarding {
                    OnboardingOverlay(manager: onboardingManager, isShowing: $showOnboarding)
                        .zIndex(99)
                }
                else if selectedTab == 1 {
                    MenuFAB {
                        isAddMenuPresented = true
                    }
                    .sheet(isPresented: $isAddMenuPresented) {
                            AddMenuModal(isPresented: $isAddMenuPresented)
                                .modelContext(context) // ✅ fix: wariskan context dari ContentView
                                .presentationDetents([.medium])
                        }
//                    .sheet(isPresented: $isAddMenuPresented) {
//                        AddMenuModal(isPresented: $isAddMenuPresented)
//                            .presentationDetents([.medium])
//                    }
                }
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}



#Preview {
    ContentView()
}



