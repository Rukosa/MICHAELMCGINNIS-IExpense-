//
//  ContentView.swift
//  Shared
//
//  Created by Michael Mcginnis on 3/7/22.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable{
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

class Expenses: ObservableObject{
    @Published var items = [ExpenseItem](){
        didSet{
            if let encoded = try? JSONEncoder().encode(items){
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    init(){
        if let savedItems = UserDefaults.standard.data(forKey: "Items"){
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems){
                items = decodedItems
                return
            }
        }
        
        items = []
    }
}

struct ContentView: View {
    @StateObject var expenses = Expenses()
    func removeItems(at offsets: IndexSet){
        expenses.items.remove(atOffsets: offsets)
    }
    
    @State private var showingAddExpense = false
    
    func textColor(amount: Double) -> Color{
        if amount < 10{
            return Color.green
        }
        if amount < 100 && amount >= 10{
            return Color.yellow
        }
        return Color.red
    }
    var body: some View {
        NavigationView{
            VStack{
                Text("Personal")
            List{
                ForEach(expenses.items){ item in
                    if item.type == "Personal"{
                    HStack{
                        VStack(alignment: .leading){
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        
                        Spacer()
                        Text(item.amount, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                            .foregroundColor(textColor(amount: item.amount))
                    }
                }
                }
                .onDelete(perform: removeItems)
            }//personal
                Text("Business")
                List{
                    ForEach(expenses.items){ item in
                        if item.type == "Business"{
                        HStack{
                            VStack(alignment: .leading){
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type)
                            }
                            
                            Spacer()
                            Text(item.amount, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                                .foregroundColor(textColor(amount: item.amount))
                        }
                    }
                    }
                    .onDelete(perform: removeItems)
                }//business
            }
            .navigationTitle("iExpense")
            .toolbar{
                Button{
                    showingAddExpense = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddExpense){
                AddView(expenses: expenses)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
