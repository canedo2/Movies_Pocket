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
    let gradient = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        gradient.frame = view.bounds
        gradient.colors = [UIColor.init(red: 0.5, green: 0, blue: 0.1, alpha: 0.2).cgColor, UIColor.init(red: 0.53, green: 0.06, blue: 0.27, alpha: 1.0).cgColor]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradient.frame = view.bounds
    }
}
