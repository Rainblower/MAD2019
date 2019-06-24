//
//  WantedCell.swift
//  01_wskpolice
//
//  Created by Admin on 18.06.2019.
//  Copyright © 2019 Rainblower. All rights reserved.
//

import Foundation
import UIKit

class WantedCell: UITableViewCell {
    
    var isRemember = false
  
    @IBOutlet weak var btnSelect: UIButton!{
        didSet{
            self.btnSelect.layer.cornerRadius = 5
            self.btnSelect.layer.borderWidth = 2
            self.btnSelect.layer.borderColor = UIColor.lightGray.cgColor
            self.btnSelect.isHidden = true
            self.btnSelect.isUserInteractionEnabled = false
        }
    }
    

    
    func btnCheck(btn: UIButton) {
        if(isRemember == false)
        {
            btn.setTitle("✓", for: .normal)
            isRemember = !isRemember
        }
        else
        {
            isRemember = !isRemember
            btn.setTitle("", for: .normal)
        }
    }
}
