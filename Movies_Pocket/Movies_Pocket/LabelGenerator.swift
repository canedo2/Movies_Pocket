//
//  LabelGenerator.swift
//  Movies_Pocket
//
//  Created by Diego Manuel Molina Canedo on 16/3/17.
//  Copyright © 2017 Universidad Pontificia de Salamanca. All rights reserved.
//

import Foundation

class LabelGenerator {

    class func createTitleLabel(string: String?) -> UILabel{
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor.white
        if(UIDevice.current.userInterfaceIdiom == .pad){
            label.font = UIFont.boldSystemFont(ofSize: 30)
        }
        else{
            label.font = UIFont.boldSystemFont(ofSize: 20)
        }
        label.textAlignment = .center
        label.text = string ?? ""
        
        return label
    }
    
    class func createTextLabel(string: String?, textAlignment: NSTextAlignment, textColor: UIColor?) -> UILabel{
        let label = UILabel()
        label.numberOfLines = 0
        
        if textColor == nil {
            label.textColor = UIColor(colorLiteralRed: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1)
        }
        else{
            label.textColor = textColor
        }
        if(UIDevice.current.userInterfaceIdiom == .pad){
            label.font = UIFont.systemFont(ofSize: 25)
        }
        else{
            label.font = UIFont.systemFont(ofSize: 16)
        }
        label.textAlignment = textAlignment
        
        label.text = string ?? ""
        
        return label
    }

}
