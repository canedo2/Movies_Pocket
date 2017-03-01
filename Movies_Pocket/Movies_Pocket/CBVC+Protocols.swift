//
//  MPC+CollectionProtocols.swift
//  Movies Pocket
//
//  Created by Diego Manuel Molina Canedo on 21/2/17.
//  Copyright © 2017 Universidad Pontificia de Salamanca. All rights reserved.
//

import Foundation
import UIKit

extension CollectionBaseViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return  appDelegate!.model.foundItems.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as! MediaCell
        
        cell.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        
        let item = appDelegate!.model.foundItems[indexPath.row]
        
        APIHelper.getImage(image: cell.image,
                           imageString: item.poster_path)
        
        cell.title.text = item.title
        cell.overview.text = item.overview
        //To keep the scroll up
        cell.overview.scrollRangeToVisible(NSRange(location: 0, length: 0))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //PORTRAIT
        let cv = collectionView
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        
        var size: CGSize
        if(collectionView.frame.height > collectionView.frame.width){
            size = CGSize(width: cv.frame.width-(layout.minimumInteritemSpacing+layout.sectionInset.right+layout.sectionInset.left),
                          height: cv.frame.height/3)
        }
            //LANDSCAPE
        else{
            size = CGSize(width:cv.frame.width-(layout.minimumInteritemSpacing+layout.sectionInset.right+layout.sectionInset.left) ,
                          height: cv.frame.height - (layout.sectionInset.top + layout.sectionInset.bottom))
        }
        return size
    }
}

class MediaCell: UICollectionViewCell{
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var overview: UITextView!
    
    @IBAction func moreAction(_ sender: Any) {
        print("See more")
    }
    
}
