//
//  triangleSolver.swift
//  Geometry calculator
//
//  Created by Kerry Zhou on 6/24/20.
//  Copyright © 2020 Kerry Zhou. All rights reserved.
//

import Foundation


//"Triangle":["a", "b", "c", "∠A", "∠B", "∠C", "height", "Perimeter", "Area"]
class triangleSolver{
    func sin(degrees: Double) -> Double {
        return __sinpi(degrees/180.0)
    }
    
    func cos(degrees: Double) -> Double {
        return __cospi(degrees/180.0)
    }
    
    func findThirdAngle(d1:Double, d2:Double) -> Double{
        return 180.0 - d1 - d2
    }
    
    
    
    func SSS(a:Double, b:Double, c:Double) -> Array<Double>{
        var answers:[Double] = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
        answers[0] = a
        answers[1] = b
        answers[2] = c
        for n in 0..<3{ //loop through, use Law of Cosines to calculate three angles
            let cosineValue = (pow(answers[(n) % 3], 2.0) + pow(answers[(n + 1) % 3], 2.0) - pow(answers[(n + 2) % 3], 2.0)) / (2.0 * answers[(n) % 3] * answers[(n + 1) % 3])
            answers[(n + 2) % 3 + 3] = acos(cosineValue) * 180 / Double.pi
        }
        answers[7] = answers[0] + answers[1] + answers[2]
        answers[8] = sqrt((answers[7]/2) * (answers[7]/2 - answers[0]) * (answers[7]/2 - answers[1]) * (answers[7]/2 - answers[2]))
        answers[6] = (2.0 * answers[8]) / answers[0]
        return answers
    }
    
    func AAAS(input:Array<Double?>) -> Array<Double>{
        var answers = input

        for n in 0..<3{
            print("*")
            if answers[n] != nil{
                print(n)
                answers[(n + 2) % 3] = answers[n]! * sin(degrees: answers[(n + 2) % 3 + 3]!) / sin(degrees: answers[n + 3]!)
                print(answers)
                answers[(n + 1) % 3] = answers[n]! * sin(degrees: answers[(n + 1) % 3 + 3]!) / sin(degrees: answers[n + 3]!)
                break
            }
        }
        
        
        print("after:  \(answers)")
        return SSS(a: answers[0]!, b: answers[1]!, c: answers[2]!)
    }
    
    
    func SAS(input:Array<Double?>, center:Int) -> Array<Double>{
        var answers = input
        //answers[(center + 1) % 3]
        let t0 = pow(answers[(center + 1) % 3]!, 2.0) + pow(answers[(center + 2) % 3]!, 2.0)
        let t1 = (2.0 * answers[(center + 1) % 3]! * answers[(center + 2) % 3]! * __cospi(answers[center + 3]!/180.0))
        
        answers[center] = sqrt(t0 - t1)
        
        
        return SSS(a: answers[0]!, b: answers[1]!, c: answers[2]!)
    }
    
}
