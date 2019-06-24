//
//  WantedDetailViewController.swift
//  01_wskpolice
//
//  Created by Admin on 18.06.2019.
//  Copyright © 2019 Rainblower. All rights reserved.
//

import UIKit

class WantedDetailViewController:
    UIViewController, UITextViewDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var btnAdd: UIBarButtonItem!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var txtStatus: UITextField!
    @IBOutlet weak var txtMiddleName: CustomUITextField!
    @IBOutlet weak var txtFirst: UITextField!
    @IBOutlet weak var txtLast: UITextField!
    @IBOutlet weak var txtCount: UILabel!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var txtNick: UITextField!
    
    var imagePicker = UIImagePickerController()
    var isAdd = false
    var wanted = Wanted(
        id: "", status: "", first_name: "", last_name: "", last_location: "",
        nicknames: "", description: "", photo: "", middle_name: "", isSelected: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        


        
        
        
        if isAdd {
            navigationItem.title = "Add New Wanted"
            
            guard let id = Int(wanted.id) else {
                wanted.id = "1"
                return
            }
            
            wanted.photo = ""
            wanted.id = String(id + 1)
        } else {
            txtStatus.text = wanted.status?.trimmingCharacters(in: ["\t"])
            txtFirst.text = wanted.first_name?.trimmingCharacters(in: ["\t"])
            txtNick.text = wanted.nicknames?.trimmingCharacters(in: ["\t"])
            if wanted.middle_name != nil {
                txtMiddleName.text = wanted.middle_name?.trimmingCharacters(in: ["\t"])
            }
            txtLast.text = wanted.last_name?.trimmingCharacters(in: ["\t"])
            txtDescription.text = wanted.description?.trimmingCharacters(in: ["\t"])
            
            guard let photo = wanted.photo else { return }
            if let url = URL(string: photo) {
                do {
                    let data = try Data(contentsOf: url)
                    imageView.image = UIImage(data: data)
                } catch {
                    print(error)
                }
            } else {
                
            }
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    @IBAction func doneClick(_ sender: Any) {
        
        wanted.status = txtStatus.text
        wanted.first_name = txtFirst.text
        wanted.nicknames = txtNick.text
        wanted.middle_name = txtMiddleName.text
        wanted.last_name = txtLast.text
        wanted.description = txtDescription.text
        
        if isAdd {
            performSegue(withIdentifier: "WantedUnwind", sender: self)
        } else {
            performSegue(withIdentifier: "WantedUnwind", sender: self)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        let count = txtDescription.text.count
        
        if count <= 255 {
            txtCount.text = "\(count) / 255"
        } else {
            txtDescription.text.removeLast()
        }
    }
    @IBAction func addImage(_ sender: Any) {
        
        imagePicker.delegate = self
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let photo = UIAlertAction(title: "Photo library", style: .default) { (completed) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let camera = UIAlertAction(title: "Camera", style: .default) { (completed) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        alert.addAction(camera)
        alert.addAction(photo)
        
        present(alert, animated: true)
        
    }
}

extension WantedDetailViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        let url:URL = info[UIImagePickerController.InfoKey.imageURL] as! URL
        
        do {
            imageView.image = try UIImage(data: Data(contentsOf: url))
            wanted.photo = url.absoluteString
        } catch {
            print(error)
        }
    }
}

