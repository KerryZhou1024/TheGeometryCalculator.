//
//  polynomial.swift
//  Geometry calculator
//
//  Created by Kerry Zhou on 6/8/20.
//  Copyright © 2020 Kerry Zhou. All rights reserved.
//

import Foundation

/// Complex Number
struct ComplexNumber {
    var real: Double
    var imaginary: Double
    
    public init(_ real: Double, _ imaginary: Double) {
        self.real = real
        self.imaginary = imaginary
    }
    
    public init(_ real: Double) {
        self.real = real
        self.imaginary = 0
    }
    
    var isReal: Bool {
        if imaginary == 0 { return true }
        return false
    }
}


extension ComplexNumber {
    static func zero() -> Self {
        return ComplexNumber(0, 0)
    }
}

extension ComplexNumber: CustomStringConvertible {
    var description: String {
        return "(Real: \(real), Imaginary: \(imaginary)"
    }
}


    /// # Linear Equation Solver
    ///  Returns the solution to the equation ax + b = 0
    func linearSolve(a: Double, b: Double) -> [ComplexNumber] {
        if a == 0 {
            return []
        }
        
        return [ComplexNumber(-b/a)]
    }
    
    
    /// # Quadratic Equation Solver
    /// Returns the roots of the equation ax^2 + bx + c = 0
    ///
    ///
    /// Procedure:
    ///
    ///     1. calculate discriminant `d = b^2 -4*a*c`
    ///         i. if d > 0 , equation has two distinct real roots exist.
    ///         ii. if d = 0, equation has two repeated real roots.
    ///         iii. if d < 0 equation has two complex roots.
    ///
    ///
    func quadraticSolve(a: Double, b: Double, c: Double, threshold: Double = 0.0001) -> [ComplexNumber] {
        if a == 0 { return linearSolve(a: b, b: c) }
        
        var roots = [ComplexNumber]()
        
        var d = pow(b, 2) - 4*a*c // discriminant
        
        // Check if discriminate is within the 0 threshold
        if -threshold < d && d < threshold { d = 0 }
        
        if d > 0 {
            
            let x_1 = ComplexNumber((-b + sqrt(d))/(2*a))
            let x_2 = ComplexNumber((-b - sqrt(d))/(2*a))
            roots = [x_1, x_2]
            
        } else if d == 0 {
            
            let x = ComplexNumber(-b/(2*a))
            roots = [x, x]
            
        } else if d < 0 {
            
            let x_1 = ComplexNumber(-b/(2*a), sqrt(-d)/(2*a))
            let x_2 = ComplexNumber(-b/(2*a), -sqrt(-d)/(2*a))
            roots = [x_1, x_2]
            
        }
        
        return roots
    }
    
    
    /// # Cubic Equation Solver
    ///
    /// Solves the cubic equation of the form `ax^3 + bx^2 + cx + d = 0` - **eq: 1**
    /// Should follow some variation of the following algorithm
    /// - important:  a, b, c, d should all be real numbers.
    /// - reference: [Cubic Equation](https://en.wikipedia.org/wiki/Cubic_equation)
    ///
    ///     Procedure:
    ///
    ///
    ///     1.  Divide both sides of equation by a.
    ///
    ///         i.  In the case that a == 0 fallback onto the `quadraticSolve`.
    ///         ii.  other wise move on to step 2. The equation should now look as follows x^3 + (b/a)x^2 + (c/a)x + d/a = 0.
    ///
    ///     2.  Calculate the discriminant D
    ///
    ///         i.  Let `a_1 = b/a `,  `a_2 = c/a` , and `a_3 = d/a`.
    ///         ii.  Let `q = (3*a_2 - a_1^2)/9` and `r = (9*a_1*a_2 - 27*a_3 - 2*a_1^3)/54`
    ///         iii.  Let ` s = cbrt(r + sqrt(q^3+r^2))` and `t = cbrt(r - sqrt(q^3+r^2))`
    ///         iiii.  Then `D = q^3 + f^2`
    ///
    ///         a.   If `D > 0` , one real root with 2 complex conjugate roots.
    ///         b.   if `D = 0` , all roots are real and atleast 2 are repeated.
    ///         c.   If `D < 0`, all roots are real and unequal.
    ///
    ///
    ///     2A.  D > 0`,  where `cbrt` and `sqrt`  are the cuberoot and squareroot respectively.
    ///
    ///         1.  The only real solution: `x_1 = ComplexNumber(s + t - (1/3)*a_1)`
    ///         2.  First complex  solution :  `x_2 = ComplexNumber(-(1/2)*(s+t) - (1/3)*a_1,  (1/2)*sqrt(3)*(s - t))`
    ///         3.  Second complex  solution:  `x_3 = ComplexNumber(-(1/2)*(s+t) - (1/3)*a_1, -(1/2)*sqrt(3)*(s - t))`
    ///
    ///     2B.  For `D = 0`  and `D < 0 ` Trigonometry can be used Let `theta  = acos(r/sqrt(-pow(q, 3)))`
    ///
    ///         1.`x_1 = ComplexNumber(2*sqrt(-q)*cos((1/3)*theta) - (1/3)*a_1)`
    ///         2.`x_2 = ComplexNumber(2*sqrt(-q)*cos((1/3)*theta + 2*Double.pi/3) - (1/3)*a_1)`
    ///         3.`x_3 = ComplexNumber(2*sqrt(-q)*cos((1/3)*theta + 4*Double.pi/3) - (1/3)*a_1)`
    ///
    ///
    ///
    ///
    ///
    func cubicSolve(a: Double, b: Double, c: Double, d: Double, threshold: Double = 0.0001) -> [ComplexNumber] {
        // if not a cubic fall back to quadratic
        if a == 0 { return quadraticSolve(a: b, b: c, c: d) }
        
        var roots = [ComplexNumber]()
        
        let a_1 = b/a
        let a_2 = c/a
        let a_3 = d/a
        
        let q = (3*a_2 - pow(a_1, 2))/9
        let r = (9*a_1*a_2 - 27*a_3 - 2*pow(a_1, 3))/54
        
        let s = cbrt(r + sqrt(pow(q, 3)+pow(r, 2)))
        let t = cbrt(r - sqrt(pow(q, 3)+pow(r, 2)))
        
        var d = pow(q, 3) + pow(r, 2) // discriminant
        
        // Check if d is within the zero threshold
        if -threshold < d && d < threshold { d = 0 }
        
        if d > 0 {
            
            let x_1 = ComplexNumber(s + t - (1/3)*a_1)
            let x_2 = ComplexNumber(-(1/2)*(s+t) - (1/3)*a_1,  (1/2)*sqrt(3)*(s - t))
            let x_3 = ComplexNumber(-(1/2)*(s+t) - (1/3)*a_1,  -(1/2)*sqrt(3)*(s - t))
            roots = [x_1, x_2, x_3]
            
        } else if d <= 0 {
            
            let theta = acos(r/sqrt(-pow(q, 3)))
            let x_1 = ComplexNumber(2*sqrt(-q)*cos((1/3)*theta) - (1/3)*a_1)
            let x_2 = ComplexNumber(2*sqrt(-q)*cos((1/3)*theta + 2*Double.pi/3) - (1/3)*a_1)
            let x_3 = ComplexNumber(2*sqrt(-q)*cos((1/3)*theta + 4*Double.pi/3) - (1/3)*a_1)
            roots = [x_1, x_2, x_3]
            
        }
        
        return roots
    }
    

