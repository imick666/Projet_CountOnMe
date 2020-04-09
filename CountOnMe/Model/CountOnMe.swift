//
//  SimpleCalc.swift
//  CountOnMe
//
//  Created by mickael ruzel on 03/04/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

class CountOnMe{
    // MARK: - Proprieties
    var operation = "" {
        didSet {
            sendNotification("currentCalcul")
        }
    }
    
    //convert operation in array
    var elements: [String] {
        return operation.split(separator: " ").map { "\($0)" }
    }
    
    // Error check computed variables
    private var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-"
            && elements.last != "/" && elements.last != "*"
    }
    
    private var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    private var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-"
            && elements.last != "/" && elements.last != "*"
    }
    
    private var expressionHaveResult: Bool {
        return elements.firstIndex(of: "=") != nil
    }
    
    // MARK: - Methodes
    func buttonEqualTaped() {
        guard expressionIsCorrect else {
            sendNotification("alertExpression")
            return
        }
        guard expressionHaveEnoughElement else {
            sendNotification("alertNewCalcul")
            return
        }
        makeFinalOperation()
    }
    
    func addAditionOperator() {
        checkIfOperatorCanBeAdd {
            operation.append(" + ")
        }
    }
    
    func addSubstractionOperator() {
        checkIfOperatorCanBeAdd {
            operation.append(" - ")
        }
        
    }
    
    func addMultiplicationOperator() {
        checkIfOperatorCanBeAdd {
            operation.append(" * ")
        }
    }
    
    func addDivisionOperator() {
        checkIfOperatorCanBeAdd {
            operation.append(" / ")
        }
    }
    
    func addNumber(_ number: String){
        if expressionHaveResult {
            operation = ""
        }
        operation.append(number)
    }
    
    // MARK: - Private Methodes
    //create norification sender
    private func sendNotification(_ name: String) {
        let notificationName = Notification.Name(name)
        let notification = Notification(name: notificationName)
        NotificationCenter.default.post(notification)
    }
    // check if an operartor can be add
    private func checkIfOperatorCanBeAdd(_ closure: () -> Void) {
        if canAddOperator {
            if expressionHaveResult {
                operation = elements.last!
            }
            closure()
        } else {
            sendNotification("alertOperator")
        }
    }
    //make operation when "=" pressed
    private func makeFinalOperation() {
        var finalResult = elements

        while finalResult.count > 1 {
           guard let left = Int(finalResult[0]) else { return }
           let operand = finalResult[1]
           guard let right = Int(finalResult[2]) else { return }
           
           let result: Int
           switch operand {
           case "+": result = left + right
           case "-": result = left - right
           case "/": result = left / right
           case "*": result = left * right
           case "=": return
           default: fatalError("Unknown operator !")
           }
           
           finalResult = Array(finalResult.dropFirst(3))
           finalResult.insert("\(result)", at: 0)
        }
        operation.append(" = \(finalResult.first!) ")
    }
}
