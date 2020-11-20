//
//  SettingsTableController.swift
//  Geometry calculator
//
//  Created by Kerry Zhou on 6/12/20.
//  Copyright © 2020 Kerry Zhou. All rights reserved.
//

import UIKit

// protocol used for sending data back
protocol DataEnteredDelegate: class {
    func userDidEnterInformation(info: String)
}


class SettingsTableController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // update UI
        updateπValue()
        UpdateπSwitch()
        updateDecimalDigits()
        updateDigitsSwitch()
        
        
        // Do any additional setup after loading the view.
    }
    
    
    //π Settings
    @IBOutlet weak var πValue: UILabel!
    @IBOutlet weak var πSwitch: UISwitch!
    @IBOutlet weak var valueSilder: UISlider!

    func updateπValue(){
        if let sliderPosition = UserDefaults.standard.object(forKey: "πSilderValue"){
            valueSilder.value = sliderPosition as! Float
            π = Double(round(pow(10.0, Double(Int(valueSilder.value))) * πSpecific) / pow(10.0, Double(Int(valueSilder.value))))
            πValue.text = String(π)

        }else{//first time
            UserDefaults.standard.set(2, forKey: "πSilderValue")
            updateπValue()
        }
    }
    
    func UpdateπSwitch(){
        if let value = UserDefaults.standard.object(forKey: "πSwitchStatus") {
            valueSilder.isEnabled = value as! Bool
            πSwitch.isOn = value as! Bool
            πValue.isEnabled = value as! Bool
        }else{//first time
            UserDefaults.standard.set(true, forKey: "πSwitchStatus")
            UpdateπSwitch()
        }
    }
    
    @IBAction func πSwitchValueChanged(_ sender: Any) {
        UserDefaults.standard.set(πSwitch.isOn, forKey: "πSwitchStatus")
        UpdateπSwitch()
    }
    
    
    
    @IBAction func πSilderValueChanged(_ sender: Any) {
        UserDefaults.standard.set(Int(round(valueSilder.value)), forKey: "πSilderValue")
        updateπValue()
    }
    
    //Value Settings
    @IBOutlet weak var digitsSwitch: UISwitch!
    @IBOutlet weak var digitsValueLabel: UILabel!
    @IBOutlet weak var digitsSilder: UISlider!
    
    
    @IBAction func digitsSwtichValueChanged(_ sender: Any) {
        UserDefaults.standard.set(digitsSwitch.isOn, forKey: "digitsSwitchStatus")
        updateDigitsSwitch()
    }
    
    func updateDigitsSwitch(){
        if let value = UserDefaults.standard.object(forKey: "digitsSwitchStatus"){
            digitsSwitch.isOn = value as! Bool
            digitsSilder.isEnabled = value as! Bool
            digitsValueLabel.isEnabled = value as! Bool
        }else{
            UserDefaults.standard.set(true, forKey: "digitsSwitchStatus")
            updateDigitsSwitch()
        }
    }
    
    @IBAction func digitsSilderValueChanged(_ sender: Any) {
        UserDefaults.standard.set(Int(round(digitsSilder.value)), forKey: "holdDecimalDigits")
        updateDecimalDigits()
    }
    
    func updateDecimalDigits(){
        if let value = UserDefaults.standard.object(forKey: "holdDecimalDigits"){
            digitsSilder.value = value as! Float
            digitsValueLabel.text = String(Int(digitsSilder.value))
        }else{//first time
            UserDefaults.standard.set(2, forKey: "holdDecimalDigits")
            updateDecimalDigits()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("settingsDone"), object: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
