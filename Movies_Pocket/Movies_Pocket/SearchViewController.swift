//
//  SearchViewController.swift
//  Movies Pocket
//
//  Created by Diego Manuel Molina Canedo on 28/2/17.
//  Copyright © 2017 Universidad Pontificia de Salamanca. All rights reserved.
//

import UIKit

class SearchViewController: CollectionBaseViewController, UISearchBarDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var backgroundView: UIView!
    let gradient = CAGradientLayer()
    
    var showingNowPlaying = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        APIHelper.getNowPlaying(page: 1, updatingCollectionView: collectionView)
        gradient.colors = [UIColor.init(red: 0.5, green: 0, blue: 0.1, alpha: 0.2).cgColor, UIColor.init(red: 0.53, green: 0.06, blue: 0.27, alpha: 1.0).cgColor]
        backgroundView.layer.insertSublayer(gradient, at: 0)
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard var searchString = searchBar.text else{
            return
        }
        appDelegate?.model.foundItems = []
        collectionView.reloadData()
        
        searchString = searchString.replacingOccurrences(of: " ", with: "+")
        APIHelper.getSearch(page: 1, searchString: searchString, collectionView: collectionView)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath)
        
        //Get more pages if showing news
        if(indexPath.row == appDelegate!.model.foundItems.count-1 && showingNowPlaying){
            APIHelper.getNowPlaying(page: appDelegate!.model.foundItems.count/20 + 1, updatingCollectionView: collectionView)
        }
        
        return cell
    }
    
    /*func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //Get more pages if showing news
        APIHelper.getNowPlaying(page: appDelegate!.model.foundItems.count/20 + 1, updatingCollectionView: collectionView)
    }*/
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gradient.frame = view.bounds
        
        backgroundView.layoutIfNeeded()
        collectionView.collectionViewLayout.invalidateLayout()
     }
    
}
