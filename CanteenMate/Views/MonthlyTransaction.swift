import SwiftUI
import SwiftData

struct MonthlyTransaction: View {
    @Environment(\.modelContext) private var context
    @Environment(\.calendar) private var calendar
    @Binding var isEmpty: Bool
    
    let selectedDate: Date
    
    private var startOfMonth: Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: selectedDate))!
    }
    
    private var endOfMonth: Date {
        calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
    }
    
    @Query private var transactions: [Transaction]
    
    init(selectedDate: Date, isEmpty: Binding<Bool>) {
        self._isEmpty = isEmpty
        self.selectedDate = selectedDate
        
        let calendar = Calendar.current
        guard let monthInterval = calendar.dateInterval(of: .month, for: selectedDate) else {
            print("Invalid month interval")
            return
        }
        let start = monthInterval.start
        let end = monthInterval.end.addingTimeInterval(-1)
        
        _transactions = Query(filter: #Predicate { transaction in
            transaction.date >= start && transaction.date <= end
        }, sort: [SortDescriptor(\.date)])
    }
    
    private var groupedByDate: [(Date, [Transaction])] {
        let grouped = Dictionary(grouping: transactions) { tx in
            calendar.startOfDay(for: tx.date)
        }
        return grouped.sorted(by: { $0.key > $1.key })
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        return formatter
    }
    
    private func groupedListSection() -> some View {
        List {
            ForEach(groupedByDate, id: \.0) { date, items in
                let incomeItems = items.filter { $0.type == .income }
                let expenseItems = items.filter { $0.type == .expense }
                let totalIncome = incomeItems.map { $0.amount }.reduce(0, +)
                let totalExpense = expenseItems.map { $0.amount }.reduce(0, +)
                let total = totalIncome - totalExpense

                Section(
                    header:
                        VStack(spacing: 4) {
                            HStack {
                                Text(dateFormatter.string(from: date))
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.black)

                                Spacer()

                                Text("\(abs(total).formattedWithSeparator())")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.gray)
                            }

                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.black)
                        }
                ) {
                    // Income Row (selalu tampil)
                    HStack(spacing: 12) {
                        Image(systemName: "arrow.down.left")
                            .font(.system(size: 25, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 35, height: 35)
                            .background(Color(hex: "#47AF56"))
                            .clipShape(RoundedRectangle(cornerRadius: 10))

                        Text("Income")
                            .font(.system(size: 16, weight: .medium))

                        Spacer()

                        Text("\(totalIncome.formattedWithSeparator())")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.black)
                    }
                    .listRowSeparator(.hidden)

                    // Expense Row (selalu tampil)
                    HStack(spacing: 12) {
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 25, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 35, height: 35)
                            .background(Color(hex: "#A5270F"))
                            .clipShape(RoundedRectangle(cornerRadius: 10))

                        Text("Expense")
                            .font(.system(size: 16, weight: .medium))

                        Spacer()

                        Text("\(totalExpense.formattedWithSeparator())")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.black)
                    }
                    
                    .listRowSeparator(.hidden)
                }
            }
        }
        .padding(.horizontal, 20)
        .listStyle(.plain)
    }


    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                if !isEmpty {
                    let totalIncome = transactions
                        .filter { $0.type == .income }
                        .map { $0.amount }
                        .reduce(0, +)
                    
                    let totalExpense = transactions
                        .filter { $0.type == .expense }
                        .map { $0.amount }
                        .reduce(0, +)
                    
                    let netAmount = totalIncome - totalExpense
                    
                    HStack {
                        Spacer()
                        VStack(spacing: 12) {
                            Text("Net Total")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                            
                            SummaryCard(amount: netAmount, type: .net, fontSize: 36)
                            
                            HStack(spacing: 12) {
                                SummaryCard(amount: totalIncome, type: .income, fontSize: 20)
                                
                                Divider()
                                    .frame(width: 1, height: 20)
                                    .background(Color.gray)
                                
                                SummaryCard(amount: totalExpense, type: .expense, fontSize: 20)
                            }
                        }
                        Spacer()
                    }
                    
                    groupedListSection()
                    .onAppear {
                        isEmpty = groupedByDate.isEmpty
                    }
                    .onChange(of: groupedByDate.count) { _, _ in
                        isEmpty = groupedByDate.isEmpty
                    }
                    .onChange(of: selectedDate) {
                        isEmpty = groupedByDate.isEmpty
                    }
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

    let sameDay = now
    let otherDay = calendar.date(byAdding: .day, value: -1, to: now)!

    // Transaksi untuk hari yang sama dengan income dan expense
    let dummyData: [Transaction] = [
        Transaction(name: "Freelance Project", date: sameDay, amount: 300000, type: .income, count: 1),
        Transaction(name: "Client Lunch", date: sameDay, amount: 50000, type: .expense, count: 1),

        // Transaksi tambahan untuk variasi
        Transaction(name: "Side Hustle", date: otherDay, amount: 200000, type: .income, count: 1),
        Transaction(name: "Internet Bill", date: otherDay, amount: 100000, type: .expense, count: 1)
    ]

    dummyData.forEach { context.insert($0) }

    return MonthlyTransaction(
        selectedDate: now,
        isEmpty: .constant(false)
    )
    .modelContainer(modelContainer)
}


//#Preview {
//    let config = ModelConfiguration(isStoredInMemoryOnly: true)
//    let modelContainer = try! ModelContainer(for: Transaction.self, configurations: config)
//    
//    let context = modelContainer.mainContext
//    let calendar = Calendar.current
//    let now = Date()
//    
//    let sampleDates = [
//        now,
//        calendar.date(byAdding: .day, value: -1, to: now)!,
//        calendar.date(byAdding: .day, value: -2, to: now)!,
//        calendar.date(byAdding: .day, value: -7, to: now)!,
//        calendar.date(byAdding: .day, value: -14, to: now)!
//    ]
//    
//    let dummyData = [
//        Transaction(name: "Salary", date: sampleDates[0], amount: 5000000, type: .income, count: 1),
//        Transaction(name: "Lunch", date: sampleDates[1], amount: 25000, type: .expense, count: 1),
//        Transaction(name: "Internet", date: sampleDates[2], amount: 150000, type: .expense, count: 1),
//        Transaction(name: "Internet", date: sampleDates[2], amount: 150000, type: .expense, count: 1),
//        Transaction(name: "Side Job", date: sampleDates[3], amount: 1000000, type: .income, count: 1),
//        Transaction(name: "Groceries", date: sampleDates[4], amount: 200000, type: .expense, count: 1),
//    ]
//    
//    dummyData.forEach { context.insert($0) }
//    
//    return MonthlyTransaction(selectedDate: now, isEmpty: .constant(false))
//        .modelContainer(modelContainer)
//}
