//
//  NewRobotController.swift
//  ws
//
//  Created by Admin on 01/06/2019.
//  Copyright © 2019 Rainblower. All rights reserved.
//

import UIKit
import RealmSwift

class NewRobotController: UIViewController {
    
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var middleImage: UIImageView!
    @IBOutlet weak var botomImage: UIImageView!
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var btnMiddleLeft: UIButton!
    @IBOutlet weak var btnTopLeft: UIButton!
    @IBOutlet weak var btnBottomLeft: UIButton!
    @IBOutlet weak var btnTopRight: UIButton!
    @IBOutlet weak var btnMiddleRight: UIButton!
    @IBOutlet weak var btnBottomRight: UIButton!
    
    @IBOutlet weak var btnSave: UIButton!
    
    var topImages : [String] = []
    var middleImages : [String] = []
    var bottomImages : [String] = []
    
    var topCount = 0
    var middleCount = 0
    var bottomCount = 0
    
    var getTop = ""
    var getMiddle = ""
    var getBottom = ""
    var getPath = ""
    var getTopCount = ""
    var getMiddleCount = ""
    var getBottomCount = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Round buttons
        btnMiddleLeft.layer.cornerRadius = 24
        btnTopLeft.layer.cornerRadius = 24
        btnBottomLeft.layer.cornerRadius = 24
        btnMiddleRight.layer.cornerRadius = 24
        btnTopRight.layer.cornerRadius = 24
        btnBottomRight.layer.cornerRadius = 24
        btnSave.layer.cornerRadius = 5
        
        
        
        if getTop != ""{
            topImage.image = UIImage(named: getTop)
            middleImage.image = UIImage(named: getMiddle)
            botomImage.image = UIImage(named: getBottom)
            topCount = Int(getTopCount)!
            middleCount = Int(getMiddleCount)!
            bottomCount = Int(getBottomCount)!
            
            if topCount == 0{
                btnTopRight.isHidden = true
            }
            
            if middleCount == 0{
                btnMiddleRight.isHidden = true
            }
            
            if bottomCount == 0{
                btnBottomRight.isHidden = true
            }
        }
        else{
            btnTopRight.isHidden = true
            btnBottomRight.isHidden = true
            btnMiddleRight.isHidden = true
        }
        
        
        let docsPath = Bundle.main.resourcePath!
        let fileManager = FileManager.default
        
        do {
            // Get all files from project
            let docsArray = try fileManager.contentsOfDirectory(atPath: docsPath)
            // Filter files
            topImages = docsArray.filter{file in file.contains("top.png")}
            middleImages = docsArray.filter{file in file.contains("middle.png")}
            bottomImages = docsArray.filter{file in file.contains("bottom.png")}
            
            // Sort files a-z
            topImages.sort{$0 < $1}
            middleImages.sort{$0 < $1}
            bottomImages.sort{$0 < $1}
        } catch {
            print(error)
        }
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    
    @IBAction func TopLeftSwipe(_ sender: Any) {
        if topCount < topImages.count-1{
            
            topCount+=1
            ImageScroll(isRight: false, btnView: topImage, btnLeft: btnTopLeft, btnRight: btnTopRight, count: topCount, array: topImages)
        }
    }
    
    @IBAction func MiddleLeftSwipe(_ sender: Any) {
        if middleCount < middleImages.count-1{
            
            middleCount+=1
            ImageScroll(isRight: false, btnView: middleImage, btnLeft: btnMiddleLeft, btnRight: btnMiddleRight, count: middleCount, array: middleImages)
        }
    }
    
    @IBAction func BottomLeftSwipe(_ sender: Any) {
        if bottomCount < bottomImages.count-1{
            bottomCount+=1
            
            ImageScroll(isRight: false, btnView: botomImage, btnLeft: btnBottomLeft, btnRight: btnBottomRight, count: bottomCount, array: bottomImages)
        }
    }
    
    @IBAction func TopRightSwipe(_ sender: Any) {
        if topCount > 0{
            
            topCount-=1
            ImageScroll(isRight: true, btnView: topImage, btnLeft: btnTopLeft, btnRight: btnTopRight, count: topCount, array: topImages)
        }
    }
    
    @IBAction func MiddleRightSwipe(_ sender: Any) {
        if middleCount > 0{
            
            middleCount-=1
            ImageScroll(isRight: true, btnView: middleImage, btnLeft: btnMiddleLeft, btnRight: btnMiddleRight, count: middleCount, array: middleImages)
        }
    }
    
    @IBAction func BottomRightSwipe(_ sender: Any) {
        if bottomCount > 0{
            
            bottomCount-=1
            ImageScroll(isRight: true, btnView:botomImage, btnLeft: btnBottomLeft, btnRight: btnBottomRight, count: bottomCount, array: bottomImages)
        }
    }
    
    func ImageScroll(isRight: Bool, btnView: UIImageView, btnLeft: UIButton, btnRight: UIButton, count: Int, array: [String]){
        
        Animation(isRight: isRight,view: btnView, count: count, array: array)
        
        if isRight == true{
            
            if count == 0 {
                btnRight.isHidden = true
            }
            
            if count < array.count-1{
                btnLeft.isHidden = false
            }
            
        }else{
            
            if count > 0 {
                btnRight.isHidden = false
            }
            
            if count == array.count-1{
                btnLeft.isHidden = true
            }
            
        }
    }
    
    
    func Animation(isRight:Bool, view: UIImageView, count: Int, array:[String] ){
        if isRight{
            UIView.transition(with: view,
                              duration: 0.25,
                              options: .curveEaseOut,
                              animations: {
                                view.center.x += 400},
                              completion: {(completed) in
                                UIView.transition(with: view,
                                                  duration: 0.1,
                                                  options: .curveEaseOut,
                                                  animations: {
                                                    view.isHidden = true
                                                    view.center.x -= 800},
                                                  completion: {(completed) in
                                                    UIView.transition(with: view,
                                                                      duration: 0.25,
                                                                      options: .curveEaseOut,
                                                                      animations: {
                                                                        view.isHidden = false
                                                                        view.center.x += 400
                                                                        view.image = UIImage.init(named: array[count])},
                                                                      completion: nil)
                                })
            })
            
        }
        else{
            UIView.transition(with: view,
                              duration: 0.25,
                              options: .curveEaseOut,
                              animations: {
                                view.center.x -= 400},
                              completion: {(completed) in
                                UIView.transition(with: view,
                                                  duration: 0.1,
                                                  options: .curveEaseOut,
                                                  animations: {
                                                    view.isHidden = true
                                                    view.center.x += 800},
                                                  completion: {(completed) in
                                                    UIView.transition(with: view,
                                                                      duration: 0.25,
                                                                      options: .curveEaseOut,
                                                                      animations: {
                                                                        view.isHidden = false
                                                                        view.center.x -= 400
                                                                        view.image = UIImage.init(named: array[count])},
                                                                      completion: nil)
                                })
            })
        }
    }
    
    
    @IBAction func Share(_ sender: Any) {
        
        let activityVC = UIActivityViewController(activityItems: [BuildImage()], applicationActivities: nil)
        
        //        activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.mail, UIActivity.ActivityType.markupAsPDF, UIActivity.ActivityType.message , UIActivity.ActivityType.saveToCameraRoll, UIActivity.ActivityType.postToFlickr]
        
        activityVC.popoverPresentationController?.sourceView = sender as? UIView
        self.present(activityVC, animated: true, completion: nil)
        
    }
    
    func BuildImage() -> UIImage {
        
        let size = CGSize(width: 412, height: 384)
        UIGraphicsBeginImageContext(size)
        
        let firstSize = CGRect(x: 0, y: 0, width: size.width, height: 128)
        topImage.image?.draw(in: firstSize)
        let secondSize = CGRect(x: 0, y: 128, width: size.width, height: 128)
        middleImage.image?.draw(in: secondSize)
        let thirdSize = CGRect(x: 0, y: 256, width: size.width, height: 128)
        botomImage.image?.draw(in: thirdSize)
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    @IBAction func SaveClick(_ sender: Any) {
        
        do{
            
            let fileManager = FileManager.default
            
            let directory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create: true).appendingPathComponent("robots", isDirectory: true)
            
            // Check existence folder
            if !fileManager.fileExists(atPath: directory.absoluteString){
                // Create folder
                let localFileManager = FileManager.default
                try! localFileManager.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
            }
            
            // Create path for new folder
            let fileName = String(Date().timeIntervalSince1970) + "-?" + topImages[topCount] + "?" + middleImages[middleCount] + "?" + bottomImages[bottomCount] + "?" + String(topCount) + "?" + String(middleCount) + "?" + String(bottomCount) + "?" + ".jpg"
            
            let filePath = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("robots/" + fileName)
            
            if getPath != ""{
                try fileManager.removeItem(at: URL(string: getPath)!)
            }
            
            // Convert and compress UIImage to data(Jpeg)
            let imageData = BuildImage().jpegData(compressionQuality: 0.75)
            // Try write file in local directory
            try imageData?.write(to: filePath)
            
            navigationController?.popViewController(animated: true)
        }
        catch{
            print(error.localizedDescription)
        }
    }
}
