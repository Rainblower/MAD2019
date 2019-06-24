//
//  ViewController.swift
//  ws
//
//  Created by Rainblower on 28/05/2019.
//  Copyright © 2019 Rainblower. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtLogin: UITextField!
    @IBOutlet weak var btnRemember: UIButton!{
        didSet{
            btnRemember.layer.cornerRadius = 5
            btnRemember.layer.borderWidth = 2
            btnRemember.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnGuest: UIButton!
    @IBOutlet weak var firstCapcha: UILabel!
    @IBOutlet weak var secondCapcha: UILabel!
    @IBOutlet weak var thirdCapcha: UILabel!
    @IBOutlet weak var capchaImage: UIImageView!
    @IBOutlet weak var capchaView: UIView!
    @IBOutlet weak var txtCapcha: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnOk: UIButton!
    
    
    @IBOutlet weak var capchaConstrainTop: NSLayoutConstraint!
    @IBOutlet weak var capchaTextConstrainTop: NSLayoutConstraint!
    
    @IBOutlet weak var logoTopConstrain: NSLayoutConstraint!
    
    let numbers = ["1","2","3","4","5","6","7","8","9","0"]
    let letters = ["a","b","c","d","f","h","g","z","x"]
    let symbs = ["!","@","#","$","%","^","&","*","("]
    let arrays = [1,2,3]
    var isRemember = false
    var isUser = false
    var isSuccess = false
    var arrayArray: Array<UILabel> = []
    var errorCount = 0
    
    let userDefaults = UserDefaults.standard
    
    var capcha = ""
    
    override func viewDidLoad() {
        super.viewDidAppear(true)
        // Do any additional setup after loading the view.
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        
        
        
        txtPassword.delegate = self
        txtLogin.delegate = self
        txtCapcha.delegate = self
        
        isRemember = userDefaults.bool(forKey: "isRemember")
        
        if isRemember {
            btnRemember.setTitle("✓", for: .normal)
            txtLogin.text = userDefaults.string(forKey: "userLogin")
            txtPassword.text = userDefaults.string(forKey: "userPassword")
            
        }
        
        // Create toolbar in keyboard
        let toolbar:UIToolbar = UIToolbar(
            frame: CGRect(
                x: 0,
                y: 0,
                width: self.view.frame.size.width,
                height: 35))
        
        // Create flex space in toolbar
        let flexSpace =  UIBarButtonItem(
            barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
            target: nil,
            action: nil)
        
        // Create button in toolbar
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonItem.SystemItem.cancel,
            target: self,
            action: #selector(self.CancelClick))
        
        // Add flex space and button in toolbar
        toolbar.setItems([flexSpace,doneButton], animated: false)
        
        
        txtLogin.inputAccessoryView = toolbar
        txtPassword.inputAccessoryView = toolbar
        txtCapcha.inputAccessoryView = toolbar
        
        arrayArray = [firstCapcha!,secondCapcha!,thirdCapcha]
        
        capchaView.isHidden = true
        capchaImage.isHidden = true
        txtCapcha.isHidden = true
        btnOk.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    
    // Update capcha value
    @IBAction func CapchaClick(_ sender: Any) {
        Randomize()
    }
    
    @IBAction func CapchaEnter(_ sender: Any) {
        self.logoTopConstrain.constant = -200
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseOut
            , animations: ({
                self.view.layoutIfNeeded()
            }), completion: nil
        )
        
    }
    
    @IBAction func CapchaEnd(_ sender: Any) {
        self.logoTopConstrain.constant = 0
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseOut
            , animations: ({
                self.view.layoutIfNeeded()
            }), completion: nil
        )
    }
    
    // Remember me click
    @IBAction func OnClick(_ sender: Any) {
        
        if(isRemember == false)
        {
            btnRemember.setTitle("✓", for: .normal)
            isRemember = !isRemember
        }
        else
        {
            isRemember = !isRemember
            btnRemember.setTitle("", for: .normal)
        }
    }
    
    @IBAction func SignInClick(_ sender: Any) {
        
        guard let pass = txtPassword.text, pass.count > 0 else {return}
        guard let login = txtLogin.text, login.count > 0 else {return}
        
        isUser = true
        fetchData(login: login,pass: pass)
    }
    
    @IBAction func GuestClick(_ sender: Any) {
        // Move capcha
        capchaConstrainTop.constant = -100
        capchaTextConstrainTop.constant = -60
        
        btnGuest.isHidden = true
        btnSignIn.isHidden = true
        
        capchaView.isHidden = false
        capchaImage.isHidden = false
        btnOk.isHidden = false
        txtCapcha.isHidden = false
        
        Randomize()
    }
    
    @IBAction func OkClick(_ sender: Any) {
        
        btnGuest.isHidden = false
        btnSignIn.isHidden = false
        
        capchaView.isHidden = true
        capchaImage.isHidden = true
        btnOk.isHidden = true
        txtCapcha.isHidden = true
        self.view.endEditing(true)

        
//        performSegue(withIdentifier: "Menu", sender: self)
        if txtCapcha.text == capcha {
            
            if isUser && errorCount >= 2 && isSuccess {
                
                errorCount = 0
                isUser = false
                performSegue(withIdentifier: "MenuUser", sender: self)
                return
            } else if !isUser {
                
                errorCount = 0
                isUser = false
                performSegue(withIdentifier: "Menu", sender: self)
                return
            } else {
                
                let okAction = UIAlertAction(title: "OK", style: .cancel)
                
                let alert = UIAlertController(title: "User not found with this login and password", message: nil, preferredStyle: .alert)
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true)
                return
            }
            
        } else {
            
            isUser = false
            
            let okAction = UIAlertAction(title: "OK", style: .cancel)
            
            let alert = UIAlertController(title: "Capcha is not correct", message: nil, preferredStyle: .alert)
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true)
        }
    }
    
    // Genereate new capcha
    func Randomize(){
        capcha = ""
        
        for label in arrayArray{
            let arraySelect = Int.random(in: 1...3)
            
            switch arraySelect{
            case 1:
                let txt = numbers.randomElement()!
                label.text = txt
                label.transform = CGAffineTransform
                    .init(rotationAngle: CGFloat(Int.random(in: 1...2)))
                capcha += txt
            case 2:
                let txt = letters.randomElement()!
                label.text = txt
                label.transform = CGAffineTransform
                    .init(rotationAngle: CGFloat(Int.random(in: 1...2)))
                capcha += txt
            case 3:
                let txt = symbs.randomElement()!
                label.text = txt
                label.transform = CGAffineTransform
                    .init(rotationAngle: CGFloat(Int.random(in: 1...2)))
                capcha += txt
            default:
                print("error")
            }
        }
        print(capcha)
    }
    
    func fetchData(login: String, pass: String){
        
        let urlString = "http://mad2019.hakta.pro/api/login/?login=\(login)&password=\(pass)"
        
        guard let url = URL(string: urlString) else {return}
        
        let session = URLSession.shared
        
        session.dataTask(with: url) { (data, response, error) in
            
            if let err = error as? URLError, err.code  == URLError.Code.notConnectedToInternet
            {
                let alert = UIAlertController(title: "No internet connection", message: nil, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
            }
            
            guard let data = data else {return}
            
            do{
                
                let hakta = try JSONDecoder().decode(Hakta<User>.self, from: data)
                
                DispatchQueue.main.async {
                  
                    if self.errorCount >= 2 {
                        self.GuestClick(self)
                        if hakta.success{
                            self.isSuccess = true
                        }
                        return
                    }
                    
                    if hakta.success {
                        
                        self.isSuccess = true
                        
                        
                        
                        if self.isRemember{
                            self.userDefaults.set(self.isRemember, forKey: "isRemember")
                            self.userDefaults.set(login, forKey: "userLogin")
                            self.userDefaults.set(pass, forKey: "userPassword")
                        } else {
                            self.userDefaults.set(self.isRemember, forKey: "isRemember")
                            self.userDefaults.set("", forKey: "userLogin")
                            self.userDefaults.set("", forKey: "userPassword")
                        }
                        
                        self.errorCount = 0
                        self.performSegue(withIdentifier: "MenuUser", sender: self)
                        
                    } else {
                        
                        self.isSuccess = false

                        self.errorCount += 1
                        self.isUser = true
                        
                        guard let haktaError = hakta.error else {return}
                        let alert = UIAlertController(title: haktaError, message: nil, preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            } catch {
               
                //                                guard let httpResponse = response as? HTTPURLResponse else {return}
                //                                print(httpResponse.statusCode)
                
                
                
            }
            
            
            }.resume()
        
    }
    
    // If keyboard open and touch screen, keyboard closed
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Enter return in keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    @objc func CancelClick(){
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MenuUser" {
            
            let vc = segue.destination as? MainMenuController
            
            vc?.isUser = true
            
            
        }
    }
    
}

