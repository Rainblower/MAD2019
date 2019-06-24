//
//  ShowDepartViewController.swift
//  01_wskpolice
//
//  Created by Admin on 17.06.2019.
//  Copyright © 2019 Rainblower. All rights reserved.
//

import UIKit

class ShowDepartViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var bossLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var expandBtn: UIButton!
    @IBOutlet weak var textHeight: NSLayoutConstraint!
    
    var tempHeight: CGFloat = 0
    
    var name = "", phone = "", address = "", boss = "", phoneH = "", email = "", descriptionH = "",
    coords = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = name
        addressLabel.text = address
        bossLabel.text = boss
        phoneLabel.text = phoneH
        emailLabel.text = email
        descriptionLabel.text = descriptionH

        expandBtn.layer.borderWidth = 1
        expandBtn.layer.borderColor = UIColor.gray.cgColor
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: nil)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func collapseClick(_ sender: Any) {
        
        
        if textHeight.constant != 0 {
            
            expandBtn.transform = CGAffineTransform(rotationAngle: (90 * .pi) / 2)
            
            tempHeight = textHeight.constant
            textHeight.constant = 0
            
            UIView.animate(withDuration: 0.20) {
                
                self.view.layoutIfNeeded()
            }
        } else {
            
            textHeight.constant = tempHeight
            expandBtn.transform = CGAffineTransform(rotationAngle: 0)
            
            UIView.animate(withDuration: 0.20) {
                
                self.view.layoutIfNeeded()
            }
        }
        
        
    }
    
    @IBAction func showClick(_ sender: Any) {
        performSegue(withIdentifier: "Map", sender: self)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.destination is MapViewController else { return }
        
        guard let vc = segue.destination as? MapViewController else {return}
        
        vc.coords = coords
    }
 

}
