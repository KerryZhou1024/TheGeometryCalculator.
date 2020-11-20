//
//  AppInformationViewController.swift
//  Geometry calculator
//
//  Created by Kerry Zhou on 9/30/20.
//  Copyright © 2020 Kerry Zhou. All rights reserved.
//

import UIKit

class AppInformationViewController: UIViewController {

    @IBOutlet weak var appVersionTV: UITextView!
    @IBOutlet weak var appInfoTV: UITextView!
    @IBOutlet weak var appLogoSourceTV: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let attributedString = NSMutableAttributedString(string: "App Logo Source: flaticon.com")
               attributedString.addAttribute(.link, value: "https://www.flaticon.com/free-icon/triangular_280067", range: NSRange(location: 17, length: 12))

               appLogoSourceTV.attributedText = attributedString
        
        
//        appInfoTV.isScrollEnabled = false
        appInfoTV.isUserInteractionEnabled = false
        appLogoSourceTV.isScrollEnabled = false
        appLogoSourceTV.isEditable = false
        appVersionTV.isUserInteractionEnabled = false
        // Do any additional setup after loading the view.
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
