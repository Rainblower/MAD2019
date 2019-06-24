//
//  CustomUITextVIew.swift
//  01_wskpolice
//
//  Created by Admin on 19.06.2019.
//  Copyright © 2019 Rainblower. All rights reserved.
//

import Foundation
import UIKit


class CustomUITextView: UITextView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let border = CALayer()
        let width = CGFloat(2)
        border.borderColor = UIColor(red: 25/255, green: 125/255, blue: 137/255, alpha: 1.0).cgColor
        border.frame = CGRect(x: 0, y: frame.size.height - width, width: frame.size.width, height: frame.size.height)
        border.borderWidth = width
        layer.addSublayer(border)
        layer.masksToBounds = true
        
    }
    
    override func didChangeValue(forKey key: String) {
        
        let border = CALayer()
        let width = CGFloat(2)
        border.borderColor = UIColor(red: 25/255, green: 125/255, blue: 137/255, alpha: 1.0).cgColor
        border.frame = CGRect(x: 0, y: frame.size.height - width, width: frame.size.width, height: frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
       
        
    }
 
}
