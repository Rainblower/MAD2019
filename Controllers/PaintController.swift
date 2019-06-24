//
//  PaintController.swift
//  01_wskpolice
//
//  Created by Rainblower on 03/06/2019.
//  Copyright © 2019 Rainblower. All rights reserved.
//

import UIKit



class PaintController: UIViewController {
    var lastPoint = CGPoint.zero
    var red : CGFloat = 0
    var green : CGFloat = 0
    var blue : CGFloat = 0
    var brushWidth : CGFloat = 10.0
    var opacity : CGFloat = 1.0
    var swiped = false
    
    var history : [UIImage] = []
    
    var context: CGContext? = nil
    
    @IBOutlet weak var imageVIew: UIImageView!
    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var thicknessSlider: UISlider!
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var thicknessViewTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var colorViewTopConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var redValue: UILabel!
    @IBOutlet weak var greenValue: UILabel!
    @IBOutlet weak var blueValue: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        redValue.text = NSString(format: "%d", red * 255) as String
        greenValue.text = NSString(format: "%d", green * 255) as String
        blueValue.text = NSString(format: "%d", blue * 255) as String
        
        colorView.layer.cornerRadius = 20
        colorView.layer.backgroundColor = UIColor.init(red: red, green: green, blue: blue, alpha: 1.0).cgColor
        
        thicknessViewTopConstraints.constant = 1000
        colorViewTopConstraints.constant = 1000
        
        thicknessSlider.value = Float(brushWidth / 100)
        redSlider.value = Float(red / 255)
        greenSlider.value = Float(green / 255)
        blueSlider.value = Float(blue / 255)
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        
        if let touch = touches.first{
            lastPoint = touch.location(in: imageVIew)
            print("Last point: \(lastPoint)")
        }
        
        
        if thicknessViewTopConstraints.constant < 1000{
            thicknessViewTopConstraints.constant = 1000
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
        
        if colorViewTopConstraints.constant < 1000{
            colorViewTopConstraints.constant = 1000
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint){
        
        UIGraphicsBeginImageContext(imageVIew.frame.size)
        context = UIGraphicsGetCurrentContext()
        imageVIew.image?.draw(in:CGRect(x: 0, y: 0, width: imageVIew.frame.width, height: imageVIew.frame.height), blendMode: .normal, alpha: 1.0)
        
        context?.move(to: fromPoint)
        context?.addLine(to: toPoint)
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(brushWidth)
        context?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
        context?.setBlendMode(.copy)
        context?.strokePath()
        
        imageVIew.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = true
        if let touch = touches.first{
            let currentPoint = touch.location(in: imageVIew)
            print("Current point: \(currentPoint)")
            drawLineFrom(fromPoint: lastPoint, toPoint: currentPoint)
            lastPoint = currentPoint
        }
        
        print(red)
        print(blue)
        print(green)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !swiped{
            drawLineFrom(fromPoint: lastPoint, toPoint: lastPoint)
        }
        
        history.append(imageVIew.image!)
    }
    
    @IBAction func removeLines(_ sender: Any) {
        red = 255 / 255
        blue = 255 / 255
        green = 255 / 255
    }
    
    
    @IBAction func pickColor(_ sender: Any) {
        
        red = CGFloat(Float(redValue.text!)! / 255)
        blue = CGFloat(Float(blueValue.text!)! / 255)
        green = CGFloat(Float(greenValue.text!)! / 255)
        
        colorViewTopConstraints.constant = 548
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        
        if thicknessViewTopConstraints.constant < 1000{
            thicknessViewTopConstraints.constant = 1000
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    @IBAction func selectThickness(_ sender: Any) {
        
        thicknessViewTopConstraints.constant = 711
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        
        if colorViewTopConstraints.constant < 1000{
            colorViewTopConstraints.constant = 1000
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func thicknessChanged(_ sender: Any) {
        brushWidth = CGFloat(thicknessSlider.value * 100)
    }
    
    @IBAction func redSlider(_ sender: Any) {
        red = colorChange(color: red, slider: redSlider, txtValue: redValue)
    }
    
    @IBAction func greenSlider(_ sender: Any) {
        green = colorChange(color: green, slider: greenSlider, txtValue: greenValue)
    }
    
    @IBAction func blueSlider(_ sender: Any) {
        blue = colorChange(color: blue, slider: blueSlider, txtValue: blueValue)
    }
    
    func colorChange(color: CGFloat, slider: UISlider, txtValue: UILabel) -> CGFloat{
        var col = color
        col = CGFloat(slider.value *  255)
        txtValue.text = String(Int(color * 255))
        col = col / 255
        
        colorView.layer.backgroundColor = UIColor.init(red: red, green: green, blue: blue, alpha: 1.0).cgColor
        
        return col
    }
    
    
    @IBAction func shareButton(_ sender: Any) {
        
        if let image = imageVIew.image {
            let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            
            activity.popoverPresentationController?.sourceView = sender as? UIView
            
            self.present(activity,animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Draw something", message: nil, preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .cancel) { (action) in
                
            }
            alert.addAction(action)
            
            present(alert,animated: true, completion: nil)
        }
    }
    
    @IBAction func undoButton(_ sender: Any) {
        
        if history.count != 0{
            history.removeLast()
        }
        
        if history.count == 0{
            imageVIew.image = UIImage()
        }
        else{
            imageVIew.image = history[history.count-1]
        }
    }
}
