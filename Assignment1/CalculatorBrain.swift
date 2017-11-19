//
//  CalculatorBrain.swift
//  Assignment1
//
//  Created by Joey-Hou on 2017/11/4.
//  Copyright © 2017 Joey-Hou. All rights reserved.
//


/*1.UI中有许多不同种类的func：
设置enum+设置Dcitionary+设置一个带switch的func来读取字典里的东西


*/
import Foundation

func changeSign(a: Double) -> Double{
    return -a
}

struct CalculatorBrain{
    
    //Accumulator可能是nil的
    private var accumulator: Double?
    
    //enum和optional一样，有很多状态，分别对应不同type
    //定义一些Operation，供dictionary使用
    private enum Operation{
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
        
    }
    
    //存储计算符号的dictionary
    //因为dictionary是从String->Operation，需要重新定义Operation
    private var operations: Dictionary<String, Operation> = [
        "𝝿": Operation.constant(Double.pi),
        "e": Operation.constant(M_E),
        "√": Operation.unaryOperation(sqrt),
        "cos": Operation.unaryOperation(cos),
        "sin": Operation.unaryOperation(sin),
        //"x²": Operation.unaryOperation({ $0 * $0 }),
        "±": Operation.unaryOperation(changeSign),
        "+": Operation.binaryOperation({ $0 + $1 }),
        "-": Operation.binaryOperation({ $0 - $1 }),
        "×": Operation.binaryOperation({ $0 * $1 }),
        "÷": Operation.binaryOperation({ $0 / $1 }),
        "=": Operation.equals
    ]
    
    mutating func performOperation(_ symbol: String) {
        
        //从dictionary里查看symbol对应的Operation
        if let operation = operations[symbol]{
            switch operation{
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if accumulator != nil{
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil{
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
                print("equals")
            }
        }
    }
    
    
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation{
        let function: (Double, Double) ->Double
        let firstOperand: Double
        func perform(with secondOperand: Double)->Double{
            return function(firstOperand, secondOperand)
            //使用两个变量申明的原因
            //perform(with: 5.0)
        }
    }
    
    mutating private func performPendingBinaryOperation(){
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator =  pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    //修改struct的性质决定了修改struct的成员变量时需要申明Mutating
    mutating func setOperand(_ operand: Double){
      accumulator = operand
    }
    
    //Make it read-only
    var result: Double?{
        get{
            //If accumulator==nil, return 0; or return accumulator
            //return accumulator ?? 0
            return accumulator
        }
    }
}
