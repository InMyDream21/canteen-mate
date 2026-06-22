import SwiftUI
import SwiftData

struct DailyTransactionPark: View {
    @Binding var isEmpty: Bool
    let selectedDate: Date
    
    @State private var selectedTransaction: Transaction?
    @State private var isEditing = false
    
    private var startOfDay: Date {
        Calendar.current.startOfDay(for: selectedDate)
    }
    
    private var endOfDay: Date {
        Calendar.current.date(byAdding: DateComponents(day: 1, second: -1), to: startOfDay)!
    }
    
    @Query private var allTransactions: [Transaction]
    private var filteredTransactions: [Transaction] {
        allTransactions.filter { tx in
            tx.date >= startOfDay && tx.date <= endOfDay
        }
    }
    
    var body: some View {
        ZStack{
            VStack(spacing: 0){
                if !isEmpty {
//                    HStack(spacing: 16) {
//                        SummaryCard(title: "Income", amount: filteredTransactions.filter{$0.type == .income}.reduce(0){$0 + $1.amount}, color: Color.green, imageName: "chart.line.uptrend.xyaxis")
//                        SummaryCard(title: "Expenses", amount: filteredTransactions.filter{$0.type == .expense}.reduce(0){$0 + $1.amount}, color: Color.red, imageName: "chart.line.downtrend.xyaxis")
//                    }
//                    .padding(.horizontal)
//                    .padding(.bottom, 8)
//                    .zIndex(1)
                    
                    List(filteredTransactions) { transaction in
                        HStack {
                            Text(transaction.date, style: .time)
                                .fontWeight(.bold)
                                .padding(.trailing)
                            VStack(alignment: .leading) {
                                Text("\(transaction.name)")
                                Text("Quantity: \(transaction.count)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Text("Rp\(transaction.amount)")
                                .fontWeight(.bold)
                                .foregroundColor(transaction.type == .expense ? .red : .green)
                        }
                        .padding(.vertical, 8)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedTransaction = transaction
                            isEditing = true
                        }
                    }
                    .padding(.top, -25)
                    .sheet(item: $selectedTransaction) { transaction in
                        EditTransactionView(transaction: transaction)
                    }
                }
            }
        }
        .background(
            Color(UIColor { trait in
                trait.userInterfaceStyle == .dark ? .black : .white            })
        )
        .onAppear {
            isEmpty = filteredTransactions.isEmpty
        }
        .onChange(of: filteredTransactions) {
            isEmpty = filteredTransactions.isEmpty
        }
        .onChange(of: selectedDate) {
            print("selectedDate: \(selectedDate)")
            isEmpty = filteredTransactions.isEmpty
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let modelContainer = try! ModelContainer(for: Transaction.self, configurations: config)

    let context = modelContainer.mainContext
    let now = Date()

    let dummyData = [
        Transaction(name: "Lunch", date: now, amount: 25000, type: .expense, count: 1),
        Transaction(name: "Coffee", date: now, amount: 15000, type: .expense, count: 1),
        Transaction(name: "Freelance", date: now, amount: 100000, type: .income, count: 1),
    ]

    dummyData.forEach { context.insert($0) }

    return DailyTransactionPark(isEmpty: .constant(false), selectedDate: now)
        .modelContainer(modelContainer)
}
