//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Jose Luis Lucini Reviriego on 2/8/15.
//  Copyright (c) 2015 JLLucini. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private enum Op : Printable{
        case Operand(Double)
        case Variable(String)
        case Constant(String)
        case UnaryOperation (String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get{
                switch self{
                case .Operand(let operand):
                    return "\(operand)"
                case .Variable(let operand):
                    return "\(operand)"
                case .Constant(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]()
    
    private var knownOps = [String: Op]()
    
    var variableValues: Dictionary<String, Double> = [String: Double]()
    
    var description: String {
        get{
            var result = describeStack(opStack)
            var resultStr = result.result
            while !result.remainingOps.isEmpty {
                var aux = describeStack(result.remainingOps)
                resultStr = aux.result+", "+resultStr
                result = aux
            }
            
            return resultStr
        }
    }
    
    init (){
        knownOps["×"] = Op.BinaryOperation("×", *)
        knownOps["÷"] = Op.BinaryOperation("÷") { $1 / $0 }
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["−"] = Op.BinaryOperation("−") { $1 - $0 }
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
        knownOps["cos"] = Op.UnaryOperation("cos", cos)
        knownOps["sin"] = Op.UnaryOperation("sin", sin)
        knownOps["±"] = Op.UnaryOperation("±") { $0 * (-1) }
        variableValues["π"] = M_PI
    }
    
    private func describeStack (ops: [Op]) -> (result: String, remainingOps: [Op]){
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return ("\(operand)", remainingOps)
            case .Variable(let brainVar):
                return ("\(brainVar)", remainingOps)
            case .Constant(let brainCons):
                return ("\(brainCons)", remainingOps)
            case .UnaryOperation(let symbol, _):
                let operandEvaluation = describeStack(remainingOps)
                var operand = operandEvaluation.result
                return ("\(symbol)(\(operand))", operandEvaluation.remainingOps)
            case .BinaryOperation(let symbol, _):
                let op1Evaluation = describeStack(remainingOps)
                var operand1 = op1Evaluation.result
                let op2Evaluation = describeStack(op1Evaluation.remainingOps)
                var operand2 = op2Evaluation.result
                return ("(\(operand2) \(symbol) \(operand1))", op2Evaluation.remainingOps)
            default: break
            }
        }
        return ("?", ops)
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]){
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .Variable(let brainVar):
                return (variableValues[brainVar], remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            default: break
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand:Double) -> Double?{
        opStack.append(Op.Operand(operand))
        return evaluate()
    }

    func pushOperand(symbol: String) -> Double?{
        opStack.append(Op.Variable(symbol))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double?{
        if let operation = knownOps[symbol]{
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func reset(){
        opStack = [Op]()
        variableValues = [String: Double]()
        variableValues["π"] = M_PI
    }
}