import SwiftUI
import SwiftData

struct DailyTransaction: View {
    @Binding var isEmpty: Bool
    let selectedDate: Date
    
    @State private var selectedTransaction: Transaction?
    
    private var startOfDay: Date {
        Calendar.current.startOfDay(for: selectedDate)
    }
    
    private var endOfDay: Date {
        Calendar.current.date(byAdding: DateComponents(day: 1, second: -1), to: startOfDay)!
    }
    
    @Query private var allTransactions: [Transaction]
    
    private var filteredTransactions: [Transaction] {
        allTransactions
            .filter { tx in tx.date >= startOfDay && tx.date <= endOfDay }
    }
    
    private var groupedTransactions: [(key: String, value: [Transaction])] {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH.mm"
        
        let grouped = Dictionary(grouping: filteredTransactions) { tx in
            formatter.string(from: tx.date)
        }
        
        return grouped
            .sorted { $0.key > $1.key } // sort dari jam terbaru ke terlama
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                if !isEmpty {
                    
                    let incomeTotal = filteredTransactions.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
                    let expenseTotal = filteredTransactions.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
                    let netAmount = incomeTotal - expenseTotal
                    
                    VStack(spacing: 12) {
                        Text("Net Total")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)

                        SummaryCard(amount: netAmount, type: .net, fontSize: 36)

                        HStack(spacing: 12) {
                            SummaryCard(amount: incomeTotal, type: .income, fontSize: 20)

                            Divider()
                                .frame(width: 1, height: 20)
                                .background(Color.gray)

                            SummaryCard(amount: expenseTotal, type: .expense, fontSize: 20)
                        }
                    }

                    // List
                    List {
                        ForEach(groupedTransactions, id: \.key) { time, transactionsAtTime in
                            Section(
                                header:
                                    VStack(spacing: 4) {
                                        HStack {
                                            Text(time)
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(.black)
                                            
                                            Spacer()
                                            
                                            let totalAmount = transactionsAtTime.reduce(0) { $0 + $1.amount }
                                            Text("\(totalAmount.formattedWithSeparator())")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                        Rectangle()
                                            .frame(height: 1)
                                            .foregroundColor(.black)
                                            .padding(.top, -4)
                                    }
                            ) {
                                ForEach(transactionsAtTime) { tx in
                                    HStack(spacing: 0) {
                                        Image("icon_food")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(.white)
                                            .frame(width: 25, height: 25)
                                            .padding(8)
                                            .background(Color(hex: "#4592AF"))
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                            .frame(width: 35, height: 35)
                                            .padding(.trailing, 12)

                                        VStack(alignment: .leading) {
                                            Text(tx.name)
                                            Text("\((tx.amount / tx.count).formattedWithSeparator()) x \(tx.count)")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }

                                        Spacer()

                                        Text("\(tx.amount.formattedWithSeparator())")
                                            .fontWeight(.bold)
                                            .foregroundColor(tx.type == .expense ? .red : .green)
                                    }
                                    .contentShape(Rectangle()) // agar bisa ditekan
                                    .onTapGesture {
                                        selectedTransaction = tx
                                    }
                                    .listRowSeparator(.hidden)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .padding(.horizontal, 20)
                    .sheet(item: $selectedTransaction) { transaction in
                        EditTransactionView(transaction: transaction)
                    }
                }
            }
        }
        .background(Color.white)
        .onAppear {
            isEmpty = filteredTransactions.isEmpty
        }
        .onChange(of: filteredTransactions) {
            isEmpty = filteredTransactions.isEmpty
        }
        .onChange(of: selectedDate) {
            isEmpty = filteredTransactions.isEmpty
        }
    }
}



#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Transaction.self, configurations: config)
    let context = container.mainContext
    let now = Date()
    
    let dummyData = [
        Transaction(name: "Mie Ayam Spesial", date: now, amount: 45000, type: .expense, count: 3),
        Transaction(name: "Es Teh Manis", date: now, amount: 15000, type: .expense, count: 3),
        Transaction(name: "Mendoan", date: now, amount: 6000, type: .expense, count: 3),
    ]
    
    dummyData.forEach { context.insert($0) }
    
    return DailyTransaction(isEmpty: .constant(false), selectedDate: now)
        .modelContainer(container)
}
