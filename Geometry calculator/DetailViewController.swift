//
//  DetailViewController.swift
//  Geometry calculator
//
//  Created by Kerry Zhou on 6/4/20.
//  Copyright © 2020 Kerry Zhou. All rights reserved.
//

import UIKit



class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    

    @IBOutlet weak var imageView: UIImageView!
    
    var figureName:String = "" //declare figure name, use to receive which figure user is using
    
    @IBOutlet weak var detailTitle: UINavigationItem! //set title
    
    // var for check all completes
    var isAllSet = true
    
    //tableViewSettings
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return figures[figureName]!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! DetailTextInputTableViewCell
        
        cell.configure(placeholder: "Value", labelText: figures[figureName]![indexPath.row], row: indexPath.row)
        
        cell.inCellTextField.addTarget(self, action: #selector(editDidEnd), for:UIControl.Event.editingDidEnd)
        
        cell.inCellTextField.tag = indexPath.row
        
        return cell
    }
        
    @IBAction func resetTable(_ sender: Any) {
        resetTableView()
    }
    

    
    func resetTableView(){
        values = []
        CalculationCenter().createNumbersForValues(figureName: figureName)
        for n in 0..<figures[figureName]!.count{
            if let cell =  table.cellForRow(at: IndexPath(row:n, section: 0)) as? DetailTextInputTableViewCell{
                cell.inCellTextField.text = nil
                cell.inCellTextField.isEnabled = true
            }
        }
    }
    @IBOutlet weak var tableviewConstraintsBottom: NSLayoutConstraint!
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: figureName)
        detailTitle.title = figureName
        table.allowsSelection = false
        resetTableView()
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(DetailViewController.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(DetailViewController.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        updateTableviewLocation()
        // Do any additional setup after loading the view.
    }
    
    
    func updateTableviewLocation(){
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let bottomPadding = window?.safeAreaInsets.bottom
            self.tableviewConstraintsBottom.constant = 44.0 + bottomPadding!
        }else{
            self.tableviewConstraintsBottom.constant = 44.0
        }
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let userInfo = notification.userInfo as? Dictionary<String,AnyObject>{
            let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey]
            let keyBoardRect = frame?.cgRectValue
            if let keyBoardHeight = keyBoardRect?.height {
                self.tableviewConstraintsBottom.constant = keyBoardHeight
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.layoutIfNeeded()
                })
            }

        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
//        if #available(iOS 11.0, *) {
//            let window = UIApplication.shared.keyWindow
//            let bottomPadding = window?.safeAreaInsets.bottom
//            self.tableviewConstraintsBottom.constant = 44.0 + bottomPadding!
//        }
        updateTableviewLocation()
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        <#code#>
//    }
    
    //MARK - edit
//    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
//        print("cool")
//        DispatchQueue.main.async {
//            self.table.scrollToRow(at: indexPath, at: .top, animated: true)
//        }
//    }
    

    
    @IBOutlet weak var table: UITableView!

    @IBAction func doneButtonTabbed(_ sender: Any) {
        self.view.endEditing(true)
    }
    


    
    
    @objc func editDidEnd(sender: AnyObject){
        //start calculation
        let textfield = sender as! UITextField
        values[textfield.tag] = (textfield.text! as NSString).doubleValue
        
        if values[textfield.tag]! == 0.0{//in case user tap textfleid without input any values(no to trigger alters)
            values[textfield.tag] = nil
        }
        
        CalculationCenter().startCalculation(figureName: figureName)
        


        
        //if all textFields are all compeleted, then lock the textfields, set alerts, or in some case add "π" after each numbers
        if updateAllSetTable(){
            for (n, _) in values.enumerated(){
                //lock textfields
                if let cell =  table.cellForRow(at: IndexPath(row:n, section: 0)) as? DetailTextInputTableViewCell{
                    cell.inCellTextField.isEnabled = false
                }

            }
            //if not using π's value
            if !useπValue && figuresNeedToUseπ[figureName] != nil{
                for (n, _) in values.enumerated(){
                    if figuresNeedToUseπ[figureName]![n]{
                        let cell =  table.cellForRow(at: IndexPath(row:n, section: 0)) as! DetailTextInputTableViewCell
                        cell.inCellTextField.text! += "π"
                    }
                }
            }
        }
    }
    
    func updateAllSetTable() -> Bool{
        //Initailize a Bool that shows whether the all values are compeleted
        isAllSet = true
        
        //after values are updated, update textfields in cells
        print("Updated value: \(values)")
        for (n, value) in values.enumerated(){
//            let cell = table.dequeueReusableCell(withIdentifier: "Cell", for: IndexPath(row:n, section: 0)) as! DetailTextInputTableViewCell2
            if let cell =  table.cellForRow(at: IndexPath(row:n, section: 0)) as? DetailTextInputTableViewCell{
                if value != nil{ //if user did input value
                    
                    //check whether value is valid as a positive number
                    if value! > 0.0{
                        cell.inCellTextField.text = CalculationCenter().processDecimalAnswer(value: value!)
                    }else{
                        //show alters
                        showAlters(title: "Values do not exist as positive numbers", message: "Try to input other numbers")
                    }

                }else{
                    isAllSet = false
                }
            }
        }
        return isAllSet
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(settingsDone), name: NSNotification.Name("settingsDone"), object: nil)
    }
    
    @objc func settingsDone(){
        //MARK: - need to fix updating the value: if need, please rewrite the code. 
    }
    
    func showAlters(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Reset", style: UIAlertAction.Style.cancel, handler: {(ACTION) in self.resetTable(self)}))
        self.present(alert, animated: true)
    }


    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let copy = UIContextualAction(style: .normal, title: "Copy"){_,_,_ in
            if let cell =  self.table.cellForRow(at: indexPath) as? DetailTextInputTableViewCell{
                if cell.inCellTextField.text != ""{
                    UIPasteboard.general.string = cell.inCellTextField.text!
                    let alert = UIAlertController(title: "Copied", message: "You have copied \(figures[self.figureName]![indexPath.row])'s value!", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    self.table.reloadData()
                }else{
                    let alert = UIAlertController(title: "Can't copy", message: "There are no value for \"\(figures[self.figureName]![indexPath.row])\"", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
        copy.backgroundColor = UIColor.gray
            
        let swipe = UISwipeActionsConfiguration(actions: [copy])
        return swipe
    }
    


    

    
    
    
    
    
//    func updateCellIfPossible(){
//        for i in 0 ..< figures[figureName]!.count{
//            if let cell = tableView(table, cellForRowAt: IndexPath(row: i, section: 0)) as? DetailTextInputTableViewCell{
//                if values[i] != nil{
//                    cell.inCellTextField.text = String(processDecimalAnswer(value: values[i]!))
//                }
//            }
//        }
//    }
    
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let cell = tableView(table, cellForRowAt: IndexPath(row: 3, section: 0)) as! DetailTextInputTableViewCell
//        editDidEnd(sender: cell.inCellTextField)
//    }
    /*
    // MARK: - Note about what to do next
    
     6-16
     write more info page
     draw pictures for software
     learn how to submit this to app store
     
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

