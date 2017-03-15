//
//  SearchViewController.swift
//  Movies Pocket
//
//  Created by Diego Manuel Molina Canedo on 28/2/17.
//  Copyright © 2017 Universidad Pontificia de Salamanca. All rights reserved.
//

import UIKit
import FTPopOverMenu_Swift

class SearchViewController: CollectionBaseViewController, UISearchBarDelegate {

    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var menuButton: UIButton!
    
    let gradient = CAGradientLayer()
    
    var showingNowPlaying = true
    var menuButtonMoved = false
    var menuOptionNameArray : [String] = ["Favoritos","Novedades","About"]
    var menuOptionImageNameArray : [String] = ["favorite-menu-icon","news","about-us"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        APIHelper.getNowPlaying(page: 1, updatingCollectionView: collectionView)
        gradient.colors = [UIColor.init(red: 0.5, green: 0, blue: 0.1, alpha: 0.2).cgColor, UIColor.init(red: 0.53, green: 0.06, blue: 0.27, alpha: 1.0).cgColor]
        backgroundView.layer.insertSublayer(gradient, at: 0)
        
        if(UIDevice.current.userInterfaceIdiom == .pad){
            let menuConfiguration = FTConfiguration.shared
            menuConfiguration.menuWidth = self.view.frame.width/3
            menuConfiguration.textAlignment = .natural
            menuConfiguration.textFont = UIFont(name: "HelveticaNeue-Light", size: 30.0)!
        }
        else{
            let menuConfiguration = FTConfiguration.shared
            menuConfiguration.menuWidth = self.view.frame.width*2/3
            menuConfiguration.textAlignment = .natural
            menuConfiguration.textFont = UIFont(name: "HelveticaNeue-Light", size: 20.0)!
        }
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tapGR)
    
    }

    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if menuButton.frame.origin.y > (self.view.frame.height - keyboardSize.height) {
                menuButton.frame.origin.y = self.view.frame.height - (keyboardSize.height + menuButton.frame.height + menuButton.frame.height/2 )
                menuButtonMoved = true
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if menuButtonMoved {
                menuButton.frame.origin.y = self.view.frame.height - (menuButton.frame.height + menuButton.frame.height/2 )
                menuButtonMoved = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard var searchString = searchBar.text else{
            showingNowPlaying = true
            return
        }
        showingNowPlaying = false
        appDelegate?.model.foundItems = []
        collectionView.reloadData()
        
        searchString = searchString.replacingOccurrences(of: " ", with: "+")
        APIHelper.getSearch(page: 1, searchString: searchString, collectionView: collectionView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //Get more pages if showing news
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) / scrollView.contentSize.height > 0.95) && showingNowPlaying){
            APIHelper.getNowPlaying(page: appDelegate!.model.foundItems.count/20 + 1, updatingCollectionView: collectionView)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gradient.frame = view.bounds
        
        backgroundView.layoutIfNeeded()
        collectionView.collectionViewLayout.invalidateLayout()
     }
    override public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! MediaCell
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.tapCellImageAction(_:)))
        cell.image.addGestureRecognizer(tapGR)
        return cell
    }
    
    @IBAction func menuButtonAction(_ sender: UIButton) {
        FTPopOverMenu.showForSender(sender: sender, with: menuOptionNameArray, menuImageArray: menuOptionImageNameArray, done: { (selectedIndex) -> () in
            sender.setBackgroundImage(UIImage.init(named: "menu-image-empty"), for: .normal)
            
            switch (selectedIndex){
            case 0:
                self.showingNowPlaying = false
                let mediaArray = Media.createMediaArrayFrom(mediaEntityArray: self.appDelegate?.storedFavoriteMedia ?? [])
                self.appDelegate?.model.foundItems = mediaArray
                self.collectionView.reloadData()
                break;
            case 1:
                self.showingNowPlaying = true
                self.appDelegate?.model.foundItems = []
                self.collectionView.reloadData()
                APIHelper.getNowPlaying(page: 1, updatingCollectionView: self.collectionView)
                break;
            case 2:
                self.performSegue(withIdentifier: "AboutSegue", sender: self)
                break;
            default:break;
            }
        }) {
           sender.setBackgroundImage(UIImage.init(named: "menu-image-empty"), for: .normal)
        }
        
        sender.setBackgroundImage(UIImage.init(named: "menu-image-full"), for: .normal)    }
    
    
    @IBAction func panMenuButtonAction(_ sender: UIPanGestureRecognizer) {
        
        if (sender.view!.center.y + sender.translation(in: view).y) > (sender.view!.frame.height)
        && (sender.view!.center.y + sender.translation(in: view).y) < (view.frame.height - (sender.view!.frame.height)) {
            sender.view!.center.y = sender.view!.center.y + sender.translation(in: view).y
        }
        
        if (sender.view!.center.x + sender.translation(in: view).x) > (sender.view!.frame.width/2)
            && (sender.view!.center.x + sender.translation(in: view).x) < (view.frame.width - (sender.view!.frame.width/2)) {
            sender.view!.center.x = sender.view!.center.x + sender.translation(in: view).x
        }
        sender.setTranslation(CGPoint.zero, in: view)
    }
    
    @IBAction func tapCellImageAction(_ sender: UITapGestureRecognizer) {
        
        let indexPath = collectionView.indexPath(for: sender.view?.superview?.superview as! MediaCell)
        
        let media = appDelegate!.model.foundItems[indexPath!.row]
        appDelegate!.model.selectedMedia = media
        
        let loadingView: UIView
        let activityIndicator: UIActivityIndicatorView
        (loadingView,activityIndicator) = InterfaceHelper.createLoadingView()
        
        view.addSubview(loadingView)
        activityIndicator.startAnimating()
        
        APIHelper.getDetails(media: media,
                             onCompletion: {
                                activityIndicator.stopAnimating()
                                loadingView.removeFromSuperview()
                                let controller = UIApplication.shared.keyWindow?.rootViewController;
                                controller?.performSegue(withIdentifier: "DetailSegue", sender: controller)
        },
                             onError: {
                                activityIndicator.stopAnimating()
                                loadingView.removeFromSuperview()
                                //Show error
                                let alert = InterfaceHelper.createInfoAlert(title: "Error de conexión", text: "La conexión puede ser intermitente o el servidor no estar disponible.")
                                self.present(alert, animated: true, completion: nil)
        })
    }}
