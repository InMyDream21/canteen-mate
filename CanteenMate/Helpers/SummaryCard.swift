import SwiftUI

enum SummaryType {
    case income
    case expense
    case net
}

struct SummaryCard: View {
    let amount: Int
    let type: SummaryType
    let fontSize: CGFloat

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(sign)Rp\(formattedAmount)")
                .font(.system(size: fontSize, weight: .bold))
                .foregroundColor(textColor)
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .allowsTightening(true)
        }
    }

    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter.string(from: NSNumber(value: abs(amount))) ?? "\(abs(amount))"
    }

    var sign: String {
        switch type {
        case .income:
            return "+"
        case .expense:
            return "-"
        case .net:
            return amount >= 0 ? "+" : "-"
        }
    }

    var textColor: Color {
        switch type {
        case .income:
            return Color(hex: "#47AF56")
        case .expense:
            return Color(hex: "#A5270F")
        case .net:
            return .black
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        SummaryCard(amount: 25102002, type: .income, fontSize: 16)
        SummaryCard(amount: 830000, type: .expense, fontSize: 12)
        SummaryCard(amount: 25102002 - 830000, type: .net, fontSize: 12)
    }
    .padding()
}
