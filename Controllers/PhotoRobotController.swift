//
//  PhotoRobotController.swift
//  ws
//
//  Created by Rainblower on 31/05/2019.
//  Copyright © 2019 Rainblower. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift

class PhotoRobotController: UIViewController{
    
    // View for take image from camera of gallary
    var imagePicker = UIImagePickerController()
    // Initialize filemanager
    let fileManager = FileManager.default
    var files : [URL] = []
    var docDir : URL? = nil
    var images : [CustomImage] = []
    
    var selectedCell : PhotoCell? = nil
    
    @IBOutlet weak var collectioView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditPhoto(gesture:)))
        tap.delaysTouchesEnded = true
        tap.delegate = self
        
        let lpgr : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(DeleltePhoto(gesture:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delegate = self
        lpgr.delaysTouchesEnded = true
        collectioView.addGestureRecognizer(lpgr)
        collectioView.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        collectioView.reloadData()
    }
    
    @objc func EditPhoto(gesture: UILongPressGestureRecognizer)
    {
        
        let point = gesture.location(in: collectioView)
        
        if let indexPath : IndexPath = (collectioView.indexPathForItem(at: point)){
            guard let selected = collectioView.cellForItem(at: indexPath) as? PhotoCell else { return }
            selectedCell = selected
            performSegue(withIdentifier: "Edit", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is NewRobotController
        {
            if selectedCell != nil
            {
                let vc = segue.destination as? NewRobotController
                
                vc?.getTop = selectedCell!.topImage.text!
                vc?.getMiddle = selectedCell!.middleImage.text!
                vc?.getBottom = selectedCell!.bottomImage.text!
                vc?.getPath = selectedCell!.txt.text!
                vc?.getTopCount = selectedCell!.topCount.text!
                vc?.getMiddleCount = selectedCell!.middleCount.text!
                vc?.getBottomCount = selectedCell!.bottomCount.text!
                
                selectedCell = nil
            }
        }
    }
    
    @objc func DeleltePhoto(gesture: UILongPressGestureRecognizer) {
        
        let point = gesture.location(in: collectioView)
        
        if let indexPath : IndexPath = (collectioView.indexPathForItem(at: point)){
            
            let cell = collectioView.cellForItem(at: indexPath) as! PhotoCell
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut
                , animations: ({
                    cell.alpha = 0.0
                }), completion: {(completed) in
                    let alert = UIAlertController(title: "You realy want delete image?", message: nil, preferredStyle: .alert)
                    
                    let actionYes = UIAlertAction(title: "Yes", style: .cancel) { (click) in
                        
                        do{
                            try self.fileManager.removeItem(at: URL(string: cell.txt.text!)!)
                        }
                        catch{
                            print(error)
                        }
                        
                        self.UpdateData()
                        self.collectioView.reloadData()
                        
                    }
                    
                    let actionNo = UIAlertAction(title: "No", style: .default, handler: {(click) in cell.alpha = 1.0})
                    
                    alert.addAction(actionYes)
                    alert.addAction(actionNo)
                    
                    self.present(alert, animated: true, completion: nil)})
        }
    }
    
    // Click on add button
    @IBAction func AddClick(_ sender: Any) {
        
        imagePicker.delegate = self
        
        // Action for camera
        let actionCamera = UIAlertAction(title: "Camera", style: .default) { (UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true, completion: nil)
                
            }
        }
        
        // Action for gallary
        let actionGallary = UIAlertAction(title: "Gallary", style: .default) { (UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                self.imagePicker.sourceType = .photoLibrary
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        
        // Action for close sheet
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
        }
        
        imagePicker.allowsEditing = false
        
        let alert = UIAlertController(title: "Choose image", message: nil, preferredStyle: .actionSheet)
        alert.dismiss(animated: true, completion: nil)
        alert.addAction(actionCamera)
        alert.addAction(actionGallary)
        alert.addAction(actionCancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    func UpdateData(){
        do{
            // Get url for robots/
            docDir = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("robots/")
            // Get all files from robots
            files = try fileManager.contentsOfDirectory(at: docDir!, includingPropertiesForKeys: nil)   
        }
        catch{
            print(error)
        }
    }
}


extension PhotoRobotController:  UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource ,UIImagePickerControllerDelegate ,UIGestureRecognizerDelegate{
    
    // Filled collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        UpdateData()
        // Sort files array a-z
        
        files.sort{$0.self.lastPathComponent < $1.self.lastPathComponent}
        //           let images = files.filter{image in image.absoluteString.contains("robot")}
        let url = files[indexPath.row].absoluteURL
        do{
            let splitName = files[indexPath.row].lastPathComponent.split(separator: "?")
            
            cell.img.image = UIImage(data:  try Data(contentsOf: url))
            cell.txt.text = files[indexPath.row].absoluteString
            cell.topImage.text = String(splitName[1])
            cell.middleImage.text = String(splitName[2])
            cell.bottomImage.text = String(splitName[3])
            cell.topCount.text = String(splitName[4])
            cell.middleCount.text = String(splitName[5])
            cell.bottomCount.text = String(splitName[6])
            
        }catch{
            
            print(error)
        }
        return cell
    }
    
    // User selet image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Close View
        self.dismiss(animated: true) {
        }
        
        // Info to UIImage
        guard let chosenImage = info[.originalImage] as? UIImage else { return }
        //            var fileURL: URL? = nil
        // Convert Image to data
        //            let data = chosenImage.pngData()
        do{
            // Create path for new folder
            let directory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create: true).appendingPathComponent("robots", isDirectory: true)
            
            // Check existence folder
            if !fileManager.fileExists(atPath: directory.absoluteString){
                // Create folder
                let localFileManager = FileManager.default
                try! localFileManager.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
            }
            
            // Create path for new folder
            let filePath = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("robots/robot-" + String(Date().timeIntervalSince1970) + ".jpg")
            
            // Convert and compress UIImage to data(Jpeg)
            let imageData = chosenImage.jpegData(compressionQuality: 0.75)
            // Try write file in local directory
            try imageData?.write(to: filePath)
            
            // Get all files from document directory
            //                let files = try fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
            
            //                // Create realm object
            //                let image = CustomImage()
            //                // Wirite image url in realm object
            //                image.imageURL = try String(contentsOf: fileURL!)
            //                // Initialize realm
            //                let realm = try! Realm()
            //
            //                //
            //                try! realm.write {
            //                    realm.add(image)
            //                }
            
        }
        catch{
            print(error)
        }
        
        self.collectioView.reloadData()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        UpdateData()
        return  files.count
    }
}
