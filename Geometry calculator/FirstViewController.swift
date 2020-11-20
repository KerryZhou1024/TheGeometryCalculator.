//
//  FirstViewController.swift
//  Geometry calculator
//
//  Created by Kerry Zhou on 6/4/20.
//  Copyright © 2020 Kerry Zhou. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let sections = ["2D", "3D"]
    let items = [
        ["Square", "Rectangle","Triangle","Circle"],
        ["Cube", "Sphere", "Cylinder"]
    ]
    var currentFigureName:String = ""
    
    //tableView settings
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        view.tintColor = UIColor.white
//        let header = view as! UITableViewHeaderFooterView
//        header.textLabel?.textColor = UIColor.brown
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.section][indexPath.row]
        cell.imageView?.image = UIImage(named: items[indexPath.section][indexPath.row])
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail"{
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.figureName = currentFigureName
        }
        
    }
    
    func tableView( _ tableView: UITableView, didSelectRowAt indexPath:IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        currentFigureName = items[indexPath.section][indexPath.row]
        performSegue(withIdentifier: "ShowDetail", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

