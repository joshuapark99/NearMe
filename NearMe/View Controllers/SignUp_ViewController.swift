//
//  SignUp_ViewController.swift
//  NearMe
//
//  Created by Raymond Zhu on 2/4/20.
//  Copyright © 2020 NearMe. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUp_ViewController: UIViewController {

    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // Do any additional setup after loading the view.
        setUpElements()

    }
    
    func setUpElements() {
        errorLabel.alpha = 0 //hide error label
        //style buttons
        Utilities.styleTextField(firstName)
        Utilities.styleTextField(lastName)
        Utilities.styleTextField(Email)
        Utilities.styleTextField(Password)
        
        Utilities.styleFilledButton(signUpButton)
        
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
        
        if firstName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || Email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || Password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please Fill in all fields."
        }
        
        let validPass = Password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(validPass) == false {
            return "Please make sure your password is at least 8 character, contains a number and a special character"
        } //check password regualr expressions
        
        return nil
    }
    
    
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        let error = validateFields();
        
        if error != nil{
            showError(message: error!)
        }
        
        else{
            let firstname = firstName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastname = lastName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = Email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = Password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            Auth.auth().createUser(withEmail: email, password: password) { (results, erro) in //results has the uid
                
                if erro != nil{
                    erro?.localizedDescription
                    self.showError(message: "Error Creating User")
                }
                
                else{
                    
                    let db = Firestore.firestore()
                    db.collection("Users").addDocument(data: ["First_Name": firstname, "Last_name": lastname, "uid": results!.user.uid]) {(error) in
                        
                        if error != nil{
                            self.showError(message: "User data not valid")
                        }
                    }
                    
                    self.transitionToMaps()
                    
                }
                
            }
            
            
        }
        
        
        
    }
    func showError( message:String){
        
        errorLabel.text = message
        errorLabel.alpha = 1
        
    }
    
    func transitionToMaps(){
        
        let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? Home_ViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    

}
