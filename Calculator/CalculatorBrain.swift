//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Jose Luis Lucini Reviriego on 2/8/15.
//  Copyright (c) 2015 JLLucini. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    enum Op {
        case Operand(Double)
        case UnaryOperation (String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
    }
    
    var opStack = [Op]()
    
}