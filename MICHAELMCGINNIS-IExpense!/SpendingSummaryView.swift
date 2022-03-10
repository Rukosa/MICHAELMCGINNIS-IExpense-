//
//  SpendingSummaryView.swift
//  MICHAELMCGINNIS-IExpense!
//
//  Created by Michael Mcginnis on 3/9/22.
//

import SwiftUI

struct SpendingSummaryView: View {
    let expenses: [ExpenseItem]
    @State private var personalTotal = 0.0
    @State private var busTotal = 0.0
    @State private var expenseTotal = 0.0
    func calculateExpenses(){
        for expense in expenses{
            //Personal+Business+Total
            if expense.type == "Personal"{
                personalTotal += expense.amount
            }
            else{
                busTotal += expense.amount
            }
            expenseTotal += expense.amount
        }
    }
    var body: some View {
        NavigationView{
            VStack{
                Text("Expenses:")
                    .font(.title)
                Text("Net expenses: $\(expenseTotal, specifier: "%.2f")")
                    .font(.title2)
                Text("Total personal expense: $\(personalTotal, specifier: "%.2f")")
                    .font(.title2)
                Text("Total business expense: $\(busTotal, specifier: "%.2f")")
                    .font(.title2)
                Spacer()
                Text("Net Percentages:")
                    .font(.title)
                Text("\(personalTotal/expenseTotal*100, specifier: "%.0f")% personal")
                    .font(.title2)
                Text("\(busTotal/expenseTotal*100, specifier: "%.0f")% business")
                    .font(.title2)
                Spacer()
            }
        }
        .onAppear(perform: calculateExpenses)
    }
}

struct SpendingSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SpendingSummaryView(expenses: [ExpenseItem]())
    }
}
