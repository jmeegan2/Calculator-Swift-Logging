//
//  ContentView.swift
//  CalculatorLogger
//
//  Created by James Meegan on 4/3/23.
//

import SwiftUI

struct ContentView: View {
    let buttons = [
        ["7", "8", "9", "×"],
        ["4", "5", "6", "−"],
        ["1", "2", "3", "+"],
        [".", "0", "C", "="]
    ]
    
    @State var currentNumber: String = ""
    @State var storedNumber: Double = 0
    @State var storedOperation: String = ""
    @State var previousCalculations: [String] = []
    @State private var calculationLog = ""
    @State var currentFunction: String = "" // added state variable for current function

    
    var body: some View {
        
        VStack(spacing: 12) {
            Text(currentFunction)
                .font(.headline)
                .multilineTextAlignment(.trailing)
                .padding(.horizontal)
            
            // Previous calculations view
            // Current number display
            Spacer()
            Text(currentNumber)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .font(.system(size: 70))
                .fontWeight(.bold)
                .multilineTextAlignment(.trailing)
                .lineLimit(1)
                .padding()
                .minimumScaleFactor(0.5)
      

            // Buttons grid
            ForEach(buttons, id: \.self) { row in
                HStack(spacing: 18) {
                    ForEach(row, id: \.self) { button in
                        Button(action: {
                            self.buttonTapped(button)
                        }) {
                            Text(button)
                            .font(.headline)
                            .frame(width: 80, height: 80)
                            .background(specificOperation(button) ? Color.blue.opacity(0.5) : Color.black)
                            .foregroundColor(specificOperation(button) ? Color.black : Color.white)
                            .cornerRadius(35)
                        }
                    }
                }
            }
        }
        
    }
    
    
//    func addToCalculationLog(_ button: String) {
//        switch button {
//        case "C":
//            calculationLog = ""
//        case "+", "-", "x", "÷":
//            calculationLog = "\(currentNumber) \(button) " + calculationLog
//        case "=":
//            calculationLog = "\(currentNumber) = " + calculationLog
//        default:
//            calculationLog = button + calculationLog
//        }
//    }
    
    func buttonTapped(_ button: String) {
        if let number = Double(button) {
            if currentNumber == "0" {
                currentNumber = button
            } else {
                currentNumber += button
            }
            // Append the number to the current function string
            currentFunction += button
        } else if button == "." {
            if !currentNumber.contains(".") {
                currentNumber += "."
                // Append the dot to the current function string
                currentFunction += "."
            }
        } else if button == "C" {
            currentNumber = "0"
            storedNumber = 0
            storedOperation = ""
            previousCalculations.removeAll()
            currentFunction = "" // clear current function on clear
        } else if let operation = button.first {
            if storedOperation.isEmpty {
                storedNumber = Double(currentNumber) ?? 0
                currentNumber = ""
            } else {
                performCalculation()
            }
            storedOperation = String(operation)
            // Append the operation to the current function string
            currentFunction += " \(storedOperation) "
        } else if button == "=" {
            performCalculation()
            // Append the current result to the current function string
        }
    }

    
    func performCalculation() {
        if let operation = storedOperation.first {
            switch operation {
            case "+":
                storedNumber += Double(currentNumber) ?? 0
            case "−":
                storedNumber -= Double(currentNumber) ?? 0
            case "×":
                storedNumber *= Double(currentNumber) ?? 0
            case "÷":
                storedNumber /= Double(currentNumber) ?? 1
            default:
                break
            }
        }
        currentNumber = String(storedNumber)
        storedOperation = ""
        currentFunction += " = \(currentNumber)" // add calculation result to
    }

}



func specificOperation(_ button: String) -> Bool {
    let specificOperations: Set<String> = ["×", "−", "+", "=", "C"]
    return specificOperations.contains(button)
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
