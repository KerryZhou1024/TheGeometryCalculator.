//
//  DetailTextInputTableViewCell.swift
//  Geometry calculator
//
//  Created by Kerry Zhou on 6/5/20.
//  Copyright © 2020 Kerry Zhou. All rights reserved.
//

import Foundation
import UIKit

public class DetailTextInputTableViewCell: UITableViewCell {

    @IBOutlet weak var inCellTextField: UITextField!
    @IBOutlet weak var inCellLabel: UILabel!
    
    var indexRow:Int!
    var figure:String!
    
    func configure(placeholder: String, labelText: String?, row:Int) {
        inCellTextField.placeholder = placeholder
        inCellLabel.text = labelText
 
        inCellTextField.accessibilityLabel = placeholder
        inCellLabel.accessibilityLabel = labelText
        inCellLabel.accessibilityValue = labelText
        inCellTextField.keyboardType = .decimalPad
        
        if values[row] != nil{
            inCellTextField.text = String(CalculationCenter().processDecimalAnswer(value: values[row]!))
        }
    }
    
    
    @IBAction func textFieldTouchUpInside(_ sender: Any) {
        
    }
    
    func setValues(){
        if let text = inCellTextField.text{
            if let value = Double(text){
                values[indexRow] = value
                print(values)
            }else{
//                needToAlertUserInDetailVC = true
                inCellTextField.text = ""
            }
        }else{
            print("no input")
        }

    }
    
}
