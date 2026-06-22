import SwiftUI
import SwiftData

struct RecapPage: View {
    @State private var isMonthly = true
    @State private var selectedDate = Date()
    @State private var isShowingTransactionModal = false
    @State private var isEmpty = false

    @Environment(\.modelContext) private var context
    @Query private var transactions: [Transaction]

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 35) {
                HStack(spacing: 6) {
                    Spacer()
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
                    
                    Spacer()
                }

                ZStack {
                    if isMonthly {
                        MonthlyTransaction(selectedDate: selectedDate, isEmpty: $isEmpty)
                    } else {
                        DailyTransaction(isEmpty: $isEmpty, selectedDate: selectedDate)
                    }

                    if isEmpty {
                        ContentUnavailableView(label: {
                            Label("No Transactions", systemImage: "list.bullet.rectangle.portrait")
                        }, description: {
                            Text("Start adding expenses to see your list.")
                        })
                        .offset(y: -60)
                        .background(
                            Color(UIColor { trait in
                                trait.userInterfaceStyle == .dark ? .black : .white
                            })
                        )
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(
                Color(UIColor { trait in
                    trait.userInterfaceStyle == .dark ? .black : .white
                })
            )
            .sheet(isPresented: $isShowingTransactionModal) {
                TransactionModal()
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Recap")
                        .font(.title)
                        .fontWeight(.bold)
                }
            }
        }
        .background(
            Color(UIColor { trait in
                trait.userInterfaceStyle == .dark ? .black : .white
            })
        )
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let modelContainer = try! ModelContainer(for: Transaction.self, configurations: config)

    let context = modelContainer.mainContext
    let calendar = Calendar.current
    let now = Date()

    // Sample dates throughout the month
    let sampleDates = [
        now,
        calendar.date(byAdding: .day, value: -1, to: now)!,
        calendar.date(byAdding: .day, value: -2, to: now)!,
        calendar.date(byAdding: .day, value: -7, to: now)!,
        calendar.date(byAdding: .day, value: -14, to: now)!
    ]

    let dummyData = [
        Transaction(name: "Salary", date: sampleDates[0], amount: 5000000, type: .income, count: 1),
        Transaction(name: "Lunch", date: sampleDates[1], amount: 25000, type: .expense, count: 1),
        Transaction(name: "Internet", date: sampleDates[2], amount: 150000, type: .expense, count: 1),
        Transaction(name: "Internet", date: sampleDates[2], amount: 150000, type: .expense, count: 1),
        Transaction(name: "Side Job", date: sampleDates[3], amount: 1000000, type: .income, count: 1),
        Transaction(name: "Groceries", date: sampleDates[4], amount: 200000, type: .expense, count: 1),
    ]

    dummyData.forEach { context.insert($0) }

    return RecapPage()
        .modelContainer(modelContainer)
}

enum TimeFilter {
    case daily, monthly
}
