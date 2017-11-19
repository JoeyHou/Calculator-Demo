//
//  ViewController.swift
//  Assignment1
//
//  Created by Joey-Hou on 2017/10/29.
//  Copyright © 2017年 Joey-Hou. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    //Keep track of the existence of dot so far
    var dotExists = false
    
    //CalculatorBrain Object
    //Model需要是private的因为里面存有运算方法
    private var brain = CalculatorBrain()
    
    var userIsInTheMiddleOfTyping = false
    
    var displayValue: Double {
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }
    
    //var operandStarck = Array<Double>()
    
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        //print(digit!)
        if userIsInTheMiddleOfTyping{
            let textCurrentlyInDisplay = display.text!
            if digit == "."{
                if !dotExists{
                    display.text = textCurrentlyInDisplay + digit
                    dotExists = true
                }
            } else {
                display.text = textCurrentlyInDisplay + digit
            }
        } else {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        
        //把用户在label里面输入的数字传递给CalculatorBrain，设置为accumulator
        if userIsInTheMiddleOfTyping{
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        //
        if let mathematicalSymbol = sender.currentTitle{
            brain.performOperation(mathematicalSymbol)
        }
        //如果result不是nil的话，把displayValue更改为计算的结果
        if let result = brain.result{
            displayValue = result
        }
    }
    
    @IBAction func clear(_ sender: Any) {
        userIsInTheMiddleOfTyping = false
        displayValue = 0
        brain.setOperand(0)
        //operandStarck.append(displayValue)
    }
}

