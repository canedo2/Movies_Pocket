//
//  InterfaceHelper.swift
//  Movies_Pocket
//
//  Created by Diego Manuel Molina Canedo on 7/3/17.
//  Copyright © 2017 Universidad Pontificia de Salamanca. All rights reserved.
//

import Foundation
import UIKit

class AlertHelper {
    
    class func createLoadingView() -> (UIView,UIActivityIndicatorView){
        
        let loadingView = UIView(frame: UIScreen.main.bounds)
        loadingView.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.5)
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.center = loadingView.center
        loadingView.addSubview(activityIndicator)
        
        return(loadingView,activityIndicator)
    }
    
    class func createInfoAlert(title: String, text: String) -> UIAlertController{
    
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let action = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
        alert.addAction(action)
        return alert
    
    }
    
    class func createImageLoadingView(image: UIImageView) -> (UIView,UIActivityIndicatorView){
        
        let loadingView = UIView(frame: image.bounds)
        loadingView.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.5)
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.center = loadingView.center
        loadingView.addSubview(activityIndicator)
        
        return(loadingView,activityIndicator)
    }
    
    
}
