//
//  BaseViewController.swift
//  Movies_Pocket
//
//  Created by Diego Manuel Molina Canedo on 1/3/17.
//  Copyright © 2017 Universidad Pontificia de Salamanca. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var appDelegate: AppDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
