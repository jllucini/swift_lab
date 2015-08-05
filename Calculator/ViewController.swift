//
//  ViewController.swift
//  Calculator
//
//  Created by Jose Luis Lucini Reviriego on 30/7/15.
//  Copyright (c) 2015 JLLucini. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        history.text = " "
    }
/*
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
*/
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!

    var userIsTypingNumber = false
    var wasDecimalTyped = false
    var calculatorBrain = CalculatorBrain()
    
    //var operandStack = Array<Double>()

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
            if let result = calculatorBrain.pushOperand("π") {
                displayValue = result
            } else {
                displayValue = 0
            }
        } else {
            if last(display.text!) == "." {
                display.text = display.text! + "0"
            }
            if let result = calculatorBrain.pushOperand(displayValue) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
    }
    
    @IBAction func removeLast(sender: UIButton) {
        let dText = display.text!
        if countElements(dText) > 1 {
            display.text = dropLast(dText)
            if display.text! == "-" {
                display.text = "0"
            }
        } else if countElements(dText) == 1 {
            display.text = "0"
        }
    }
    
    @IBAction func changeSign(sender: UIButton) {
        if userIsTypingNumber {
            displayValue = displayValue * (-1)
        } else {
            operate(sender)
        }
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            history.text = calculatorBrain.description + "="
        }
    }

    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        
        if userIsTypingNumber{
            enter()
        }
        
        if let result = calculatorBrain.performOperation(operation) {
            displayValue = result
        } else {
            displayValue = 0
        }
    }

    @IBAction func pushVariable(sender: UIButton) {
        userIsTypingNumber = false
        wasDecimalTyped = false
        if let result = calculatorBrain.pushOperand("M") {
            displayValue = result
        } else {
            displayValue = 0
        }
    }

    @IBAction func setVariableValue(sender: UIButton) {
        userIsTypingNumber = false
        wasDecimalTyped = false
        calculatorBrain.variableValues["M"] = displayValue
        if let result = calculatorBrain.evaluate() {
            displayValue = result
        } else {
            displayValue = 0
        }
    }
    
    @IBAction func reset(sender: UIButton) {
        userIsTypingNumber = false
        wasDecimalTyped = false
        calculatorBrain.reset()
        history.text = " "
        display.text = "0"
    }
    
}

