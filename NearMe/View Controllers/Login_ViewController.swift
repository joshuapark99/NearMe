//
//  Login_ViewController.swift
//  NearMe
//
//  Created by Raymond Zhu on 2/4/20.
//  Copyright © 2020 NearMe. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class Login_ViewController: UIViewController {

    
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements();
    }
    
    func setUpElements(){
        errorLabel.alpha = 0;
        
        //style the elements
        Utilities.styleTextField(Email)
        Utilities.styleTextField(Password)
        Utilities.styleFilledButton(loginButton)
        
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func validateFields() -> String? {
        
        if  Email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || Password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please Fill in all fields."
        }
        
        let validPass = Password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(validPass) == false {
            return "Please make sure your password is at least 8 character, contains a number and a special character"
        } //check password regualr expressions
        
        return nil
    }
    
    func showError( message:String){
        
        errorLabel.text = message
        errorLabel.alpha = 1
        
    }
    
    func transitionToMaps(){
        
        let blah = self.storyboard?.instantiateViewController(identifier: "blah") as? UINavigationController
        
        view.window?.rootViewController = blah
        view.window?.makeKeyAndVisible()
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        let error = validateFields();
        
        if error != nil{
            showError(message: error!)
        }
        
        else{
            let email = Email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = Password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().signIn(withEmail: email, password: password) { (results, erro) in
                if erro != nil{
                    self.errorLabel.text = error!
                    self.errorLabel.alpha = 1
                }
                
                else{
                    
                    self.transitionToMaps()
                    
                }
                
                
            }
            
            
        }
        
        
    }
    

}
