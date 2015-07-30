//
//  ViewController.swift
//  Calculator
//
//  Created by Jose Luis Lucini Reviriego on 30/7/15.
//  Copyright (c) 2015 JLLucini. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

/*
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
*/
    
    @IBOutlet weak var display: UILabel!

    var userIsTypingNumber = false
    var wasDecimalTyped = false
    
    var operandStack = Array<Double>()

    @IBAction func AddDecimal(sender: UIButton) {
        if !wasDecimalTyped {
            wasDecimalTyped = true
            appendDigit(sender)
        }
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsTypingNumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsTypingNumber = true
        }
    }

    @IBAction func enter() {
        userIsTypingNumber = false
        wasDecimalTyped = false
        
        if display.text == "π" {
            displayValue = M_PI
        }
        
        operandStack.append(displayValue)
        println("operandStack = \(operandStack)")
    }
    
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsTypingNumber = false
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        
        if userIsTypingNumber{
            enter()
        }
        
        switch operation {
        case "×": performOperation { $0 * $1 }
        case "÷": performOperation { $1 / $0 }
        case "+": performOperation { $0 + $1 }
        case "−": performOperation { $1 - $0 }
        case "√": performOperation { sqrt($0) }
        case "cos": performOperation { cos($0) }
        case "sin": performOperation { sin($0) }
        default: break
        }
    }
    
    func performOperation(operation: (Double, Double) -> Double){
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast()  )
            enter()
        }
    }

    func performOperation(operation: (Double) -> Double){
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
}

