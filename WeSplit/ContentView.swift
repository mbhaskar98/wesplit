//
//  ContentView.swift
//  WeSplit
//
//  Created by Bhaskar Mahajan on 02/06/24.
//

import SwiftUI



struct ContentView: View {
    typealias MoneyType = Double
    
    @State private var totalAmount : MoneyType = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    @FocusState private var isAmountFocused : Bool
    
    private let tipPercentages = [5, 10, 15, 20, 0]
    private let minimumPeople = 2
    
    private let currencyCode = FloatingPointFormatStyle<MoneyType>.Currency(code: Locale.current.currency?.identifier ?? "USD")
    
    private var totalPerPerson : MoneyType {
        get {
            var amountPerPerson = totalAmount + ((totalAmount*Double(tipPercentage))/100)
            
            let peopleCount = numberOfPeople >= minimumPeople ? numberOfPeople : minimumPeople
            
            amountPerPerson /= Double(peopleCount)
            
            print("peopleCount:\(peopleCount), tipPercentage:\(tipPercentage), totalAmount:\(totalAmount), amountPerPerson:\(amountPerPerson)")
            return amountPerPerson
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section{
                    TextField(
                        "Total Amount",
                        value:$totalAmount,
                        format: currencyCode
                    )
                    .keyboardType(.numberPad)
                    .focused($isAmountFocused)
                    
                    Picker(
                        "Number of People",
                        selection: $numberOfPeople
                    ){
                        ForEach(minimumPeople..<100, id: \.self) {
                            Text("\($0) people")
                        }
                    }
                }
                
                Section("How much do you want to tip?") {
                    Picker(
                        "Tip percentage",
                        selection: $tipPercentage
                    ) {
                        ForEach(tipPercentages, id: \.self) {
                            Text($0, format: .percent)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section {
                    Text(totalPerPerson,
                         format: currencyCode)
                }
                
            }
            .navigationTitle("WeSplit")
            .toolbar{
                if isAmountFocused {
                    Button("Done") {
                        isAmountFocused = false
                    }
                }
            }
        }
    }
    
}

#Preview {
    ContentView()
}
