//
//  MainMenuController.swift
//  ws
//
//  Created by Rainblower on 30/05/2019.
//  Copyright © 2019 Rainblower. All rights reserved.
//

import UIKit

class MainMenuController: UIViewController{
    @IBOutlet weak var topTable: UITableView!
    @IBOutlet weak var bottomTable: UITableView!
    
    // Menu buttons with Name, Image, Navigation
    var topMenu: [[String : Any]] = [
        ["Name" : "Departaments", "Image":"depIcon", "Nav" : "Departaments"],
        ["Name" : "Wanted", "Image":"wantedIcon", "Nav" : "Wanted"],
        ["Name" : "PhotoRobot", "Image":"robotIcon", "Nav" : "Robot"],
        ["Name" : "Paint", "Image":"paintIcon", "Nav" : "Paint"]]
    
    var bottomMenu: [[String : Any]] = [
        ["Name" : "About Us", "Image":"aboutIcon", "Nav" : "AboutUs"]]
    
    // Count for alert
    var count = 0
    
    var isUser = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Empty space in table footer
        topTable.tableFooterView = UIView()
        bottomTable.tableFooterView = UIView()
        
        if isUser {
            topMenu.insert(
                ["Name" : "Criminal Cases", "Image" : "criminalIcon", "Nav" : "CriminalCases"], at: 0)
            topMenu.insert(
                ["Name" : "Detectives", "Image" : "detectivesIcon", "Nav" : "Detectives"], at: 3)
            bottomMenu.append(
                ["Name" : "Logout", "Image" : "logoutIcon", "Nav" : "Logout"])
            navigationItem.setHidesBackButton(true, animated: true)
        }
        
        // Style for navigatiobar
        let nav = self.navigationController?.navigationBar
        nav?.barTintColor =  UIColor(red: 25/255, green: 125/255, blue: 137/255, alpha: 1.0  )
        nav?.barStyle = .black
        nav?.backIndicatorImage = UIImage(named: "back-arrow")
        nav?.backIndicatorTransitionMaskImage = UIImage(named: "back-arrow")
        nav?.tintColor = UIColor.white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
    }

    
    @objc func goBack(){
        navigationController?.popViewController(animated: true)
    }
    
    // Event work after view loaded
    override func viewDidAppear(_ animated: Bool) {
        
        if count == 0 && !isUser{
            
            let alert = UIAlertController(
                title: "Alert", message: "You login like a guest.", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Ok", style: .cancel) { (UIAlertAction) in
                
            }
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
            
            count+=1
        }
    }
}

extension MainMenuController: UITableViewDelegate, UITableViewDataSource, UIAdaptivePresentationControllerDelegate {
    // Count of tableview's cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == topTable{
            return topMenu.count
        } else {
            return bottomMenu.count
        }
    }
    //
    
    // Generate tableview cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cellArray = topMenu
        
        if tableView == bottomTable {cellArray = bottomMenu}
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        cell.textLabel?.text = cellArray[indexPath.row]["Name"] as? String
        cell.imageView?.image = UIImage(named: cellArray[indexPath.row]["Image"] as! String)
        
        cell.layoutMargins = UIEdgeInsets.zero
        cell.separatorInset = UIEdgeInsets.zero
        
        return cell
    }
    
    // Click on tableview cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var cellArray = topMenu
        
        if tableView == bottomTable {cellArray = bottomMenu}
        
        tableView.deselectRow(at: indexPath, animated: true)
        let nav = (cellArray[indexPath.row]["Nav"] as? String)
        
        if nav == "Logout"{
            goBack()
            return
        }
        
        if nav != ""{
            performSegue(withIdentifier: nav!, sender: self)
            
        }
        
    }
}
