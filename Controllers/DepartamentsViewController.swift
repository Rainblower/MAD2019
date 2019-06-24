//
//  DepartamentsViewController.swift
//  01_wskpolice
//
//  Created by Admin on 17.06.2019.
//  Copyright © 2019 Rainblower. All rights reserved.
//

import UIKit

class DepartamentsViewController: UITableViewController {
    
    var departList: [Departament] = []
    var selectedIndex = 0
    let refresh = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: nil)
        
        refresh.addTarget(self, action: #selector(update), for: .valueChanged)
        
        tableView.refreshControl = refresh
        tableView.tableFooterView = UIView()
    
        fetchData()
    }
    
    @objc func update() {
        
        DispatchQueue.main.async {
            self.fetchData()
        }
    }
    
    func fetchData() {
        
        let urlString = "http://mad2019.hakta.pro/api/department"
        
        guard let url = URL(string: urlString) else {return}
        
        let session = URLSession.shared
        
        session.dataTask(with: url) { (data, response, error) in
            
            if let err = error as? URLError, err.code == URLError.Code.notConnectedToInternet {
                let alert = UIAlertController(title: "No internet connection", message: nil, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)

            }
            
            guard let data = data else {return}
            
            do{
                let hakta = try JSONDecoder().decode(Hakta<[Departament]>.self, from: data)
                self.departList = hakta.data!

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refresh.endRefreshing()
                }
              
                
            } catch {
                print(error)
            }
            
            
        }.resume()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return departList.count
    }
    
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
     
        
        cell.textLabel?.text = departList[indexPath.row].name
        cell.detailTextLabel?.text = departList[indexPath.row].address
     // Configure the cell...
     
     return cell
     }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "DetailDepart", sender: self)
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
        
        guard segue.destination is ShowDepartViewController else {return}
        
        let vc = segue.destination as! ShowDepartViewController
        
        vc.name = departList[selectedIndex].name!
        vc.address = departList[selectedIndex].address!
        vc.boss = departList[selectedIndex].boss!
        vc.descriptionH = departList[selectedIndex].description!
        vc.email = departList[selectedIndex].email!
        vc.phoneH = departList[selectedIndex].phone!
        vc.coords = departList[selectedIndex].coords!
    }
 
    
}
