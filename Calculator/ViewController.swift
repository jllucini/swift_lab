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
        
        if last(display.text!) == "." {
            display.text = display.text! + "0"
        }
        
        operandStack.append(displayValue)
        history.text = history.text! + " \(displayValue)"
        println("operandStack = \(operandStack)")
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
            //userIsTypingNumber = false
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        
        if userIsTypingNumber{
            enter()
        }
        
        switch operation {
        case "×": performOperation ( { (op1: Double, op2: Double) in op1 * op2 }, opr: "x")
            // short form: performOperation { $0 * $1}
        case "÷": performOperation ( { (op1: Double, op2: Double) in
            if op1 != 0 {
                return op2 / op1
            } else {
                self.history.text! = self.history.text! + " wrong division by 0 "
                return 0
            } }, opr: "÷")
        case "+": performOperation ( { (op1: Double, op2: Double) in op1 + op2 }, opr: "+")
        case "−": performOperation ( { (op1: Double, op2: Double) in op2 - op1 }, opr: "−")
        case "√":   performOperation ( { (op1: Double) in
            if (op1 >= 0){
                return sqrt(op1)
            } else {
                self.history.text! = self.history.text! + " wrong root value (negative) "
                return 0
            } }, opr: "√")
        case "cos": performOperation ( { (op1: Double) in cos(op1) }, opr: "cos")
        case "sin": performOperation ( { (op1: Double) in sin(op1) }, opr: "sin")
        case "±": performOperation ( { (op1: Double) in op1 * (-1) }, opr: "±")
        default: break
        }
    }
    
    func performOperation(operation: (Double, Double) -> Double, opr: String){
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast()  )
            history.text = history.text! + " \(opr) ="
            enter()
        }
    }

    @IBAction func reset(sender: UIButton) {
        userIsTypingNumber = false
        wasDecimalTyped = false
        operandStack.removeAll()
        history.text = " "
        display.text = "0"
    }
    
    func performOperation(operation: (Double) -> Double, opr: String){
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            history.text = history.text! + " \(opr) ="
            enter()
        }
    }
}

