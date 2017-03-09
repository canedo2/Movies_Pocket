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
    
    var showingNowPlaying = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIHelper.getNowPlaying(page: 1, updatingCollectionView: collectionView)
        
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
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        showingNowPlaying = false
        if searchText == "" {
            showingNowPlaying = true
            appDelegate?.model.foundItems = []
            APIHelper.getNowPlaying(page: 1, updatingCollectionView: collectionView)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath)
        
        //Get more pages if showing news
        if(indexPath.row == appDelegate!.model.foundItems.count-1 && showingNowPlaying){
            APIHelper.getNowPlaying(page: appDelegate!.model.foundItems.count/20 + 1, updatingCollectionView: collectionView)
        }
        
        return cell
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundView.layoutIfNeeded()
        collectionView.collectionViewLayout.invalidateLayout()
     }
    
}
