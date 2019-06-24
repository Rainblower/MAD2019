//
//  WantedViewController.swift
//  01_wskpolice
//
//  Created by Admin on 18.06.2019.
//  Copyright © 2019 Rainblower. All rights reserved.
//

import UIKit

class WantedViewController: UITableViewController {
    
    @IBOutlet weak var btnDelete: UIBarButtonItem!
    @IBOutlet weak var btnBucket: UIBarButtonItem!
    
    var wanted: [Wanted] = []
    var selectedWanted = Wanted(
        id: "", status: "", first_name: "", last_name: "", last_location: "",
        nicknames: "", description: "", photo: "", middle_name: "", isSelected: false)
    
    var isDeleting = false
    
    let refresh = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var img = UIImage(named: "bucket")
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 20, height: 20))
        img = renderer.image { _ in
            img!.draw(in: CGRect.init(origin: CGPoint.zero, size: CGSize(width: 20, height: 20)))
        }
        btnBucket.image = img
        
        
        refresh.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        
        tableView.tableFooterView = UIView()
        tableView.addSubview(refresh)
        
        fetchData()
    }
    
    @IBAction func addClick(_ sender: Any) {
        
        if isDeleting {
            let alert = UIAlertController(title: "You cant add new wanted when you deleting", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "NewWanted", sender: self)
        }
        
        
    }
    
    @IBAction func unwindWanted(segue: UIStoryboardSegue) {
        guard segue.identifier == "WantedUnwind" else { return }
        guard let svc = segue.source as? WantedDetailViewController else { return }
        
        if svc.isAdd {
            wanted.append(svc.wanted)
        } else {
            let editId = svc.wanted.id
            guard let id = wanted.firstIndex(where: {$0.id == editId}) else { return }
            let tempWanted = svc.wanted
            wanted.remove(at: id)
            wanted.append(tempWanted)
            
        }

        tableView.reloadData()
    }
    
    @IBAction func addNewWanted(_ sender: Any) {
        performSegue(withIdentifier: "NewWanted", sender: self)
    }
    
    @IBAction func deleteClick(_ sender: Any) {
        
        isDeleting = !isDeleting
        
        tableView.reloadData()
        
        if isDeleting {
            
            let height = tableView.frame.height
            let width = tableView.frame.width

            let button = UIButton(type: .system)
            button.frame = CGRect(
                x: 100 , y: height - 200, width: width - 200, height: 25)
            
            button.backgroundColor = UIColor(red: 25/255, green: 125/255, blue: 137/255, alpha: 1.0)
            button.setTitle("Delete", for: .normal)
            button.tintColor = .white
            button.title(for: .normal)
            button.layer.cornerRadius = 5
            button.addTarget(self, action: #selector(remove), for: .allEvents)
            button.isUserInteractionEnabled = true
            button.tag = 1337

            tableView.addSubview(button)
            tableView.reloadData()
            
        } else {
            let view = tableView.viewWithTag(1337)
            view!.removeFromSuperview()
            self.isDeleting = false
            self.tableView.reloadData()
        }
    }


    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return wanted.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        wanted.sort { (first, second) -> Bool in
            guard let first = Int(first.id) else { return false}
            guard let second = Int(second.id) else { return false}
            
            if first < second {
                return true
            } else {
                return false
            }
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WantedCell
        
        cell.imageView?.layer.cornerRadius = (cell.imageView?.frame.height)! / 2
        cell.btnSelect.isHidden = true
        
        
        
        if cell.isRemember {
            cell.btnCheck(btn: cell.btnSelect)
        }
        
        if cell.isRemember {
            wanted[indexPath.row].isSelected = true
        } else {
            wanted[indexPath.row].isSelected = false
        }
        
        guard var firstName = wanted[indexPath.row].first_name else {return cell}
        guard var lastName = wanted[indexPath.row].last_name else {return cell}
        let middle_name: String? = wanted[indexPath.row].middle_name ?? ""
        
        let url = URL(string: wanted[indexPath.row].photo!)
        
        firstName = firstName.trimmingCharacters(in: ["\t"])
        lastName = lastName.trimmingCharacters(in: ["\t"])
        cell.textLabel?.text = firstName + " " + lastName + " " + middle_name!
        
        
        do {
            if url != nil {
                let data = try Data.init(contentsOf: url!)
                cell.imageView?.image = UIImage(data: data)
                
            } else {
                cell.imageView?.image = UIImage(named: "Userpic")
            }
            
            cell.imageView?.isHidden = false
            UIGraphicsBeginImageContext(CGSize(width: 35, height: 35))
            cell.imageView?.layer.cornerRadius = 35/2
            cell.imageView?.layer.masksToBounds = true
            cell.imageView?.image?.draw(in: CGRect(x: 0, y: 0, width: 35, height: 35))
            cell.imageView?.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
           
            
        } catch {
            print(error)
        }
        if isDeleting {
            cell.imageView?.isHidden = true
        }
        
        if cell.imageView?.isHidden == true {
            cell.btnSelect.isHidden = false
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
   
        let cell = tableView.cellForRow(at: indexPath) as! WantedCell
        
        if isDeleting {
            cell.btnCheck(btn: cell.btnSelect)
            if cell.isRemember {
                wanted[indexPath.row].isSelected = true
            } else {
                wanted[indexPath.row].isSelected = false
            }
        } else {
            selectedWanted = wanted[indexPath.row]
            performSegue(withIdentifier: "EditWanted", sender: self)
        }
    
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "NewWanted" {
            let vc = segue.destination as! WantedDetailViewController
            vc.isAdd = true
            
            guard let lastWanted = wanted.last else { return }
            vc.wanted = lastWanted
        } else {
            let vc = segue.destination as! WantedDetailViewController
            vc.wanted = selectedWanted
        }
    }
}


extension WantedViewController {
    
    
    func fetchData() {
        
        let urlString = "http://mad2019.hakta.pro/api/wanted"
        
        guard let url = URL(string: urlString) else {return}
        
        let urlSession = URLSession.shared
        
        urlSession.dataTask(with: url) { (data, response, error) in
            if let err = error as? URLError, err.code == URLError.Code.notConnectedToInternet {
                let alert = UIAlertController(title: "No internet connection", message: nil, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
            }
            
            guard let data = data else {return}
            
            do {
                let hakta = try JSONDecoder().decode(Hakta<[Wanted]>.self, from: data)
                
                guard let haktaData = hakta.data else {return}
                
                self.wanted = haktaData
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    
                    self.refresh.endRefreshing()
                }
                
            } catch {
                print(error)
            }
            }.resume()
    }
    
    @objc func refreshTable(){
        
        DispatchQueue.main.async {
            self.fetchData()
            
            self.tableView.tableFooterView = UIView()
            self.isDeleting = false
            guard let view = self.tableView.viewWithTag(1337) else { return }
            view.removeFromSuperview()
        }
        
    }
    
    
    @objc func remove() {
        wanted.removeAll(where: {$0.isSelected == true})
        isDeleting = false
        
        tableView.reloadData()
        
        guard let view = self.tableView.viewWithTag(1337) else { return }
        view.removeFromSuperview()
    }
}
