//
//  ViewController.swift
//  NearMe
//
//  Created by Near Me on 2/4/20.
//  Copyright © 2020 NearMe. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var SignUp: UIButton!
    @IBOutlet weak var LogIn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpElements()
    }
    
    func setUpElements () {
        
        Utilities.styleFilledButton(SignUp)
        Utilities.styleFilledButton(LogIn)

        
    }


}

