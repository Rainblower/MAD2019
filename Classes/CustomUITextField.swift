//
//  CustomUITextField.swift
//  01_wskpolice
//
//  Created by Admin on 19.06.2019.
//  Copyright © 2019 Rainblower. All rights reserved.
//

import Foundation
import UIKit

class CustomUITextField: UITextField {
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       
        self.layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor(red: 25/255, green: 125/255, blue: 137/255, alpha: 1.0).cgColor
        border.frame = CGRect(x: 0, y: frame.size.height - width, width: frame.size.width, height: frame.size.height)
        border.borderWidth = width
        layer.addSublayer(border)
        layer.masksToBounds = true
    }
}
