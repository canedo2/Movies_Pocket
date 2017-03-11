//
//  FavoriteButton.swift
//  Movies_Pocket
//
//  Created by Diego Manuel Molina Canedo on 11/3/17.
//  Copyright © 2017 Universidad Pontificia de Salamanca. All rights reserved.
//

import UIKit

class FavoriteButton: UIButton {

    var favorite = false
    
    func setFavorite (state: Bool){
        favorite = state
        if state {
            self.setImage(UIImage(named: "Favorite"), for: .normal)
        }
        else{
            self.setImage(UIImage(named: "AddFavorite"), for: .normal)
        }
    }
}
