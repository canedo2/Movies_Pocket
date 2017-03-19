//
//  SearchViewController.swift
//  Movies Pocket
//
//  Created by Diego Manuel Molina Canedo on 28/2/17.
//  Copyright © 2017 Universidad Pontificia de Salamanca. All rights reserved.
//

import UIKit
import FTPopOverMenu_Swift

class SearchViewController: CollectionBaseViewController, UISearchBarDelegate, APIHelperSearchDelegate, APIHelperNowPlayingDelegate {

    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var menuButtonWidth: NSLayoutConstraint!
    
    var showingNowPlaying = true
    var menuButtonMoved = false
    var menuOptionNameArray : [String] = ["Favoritos","Novedades","Cines cercanos","About"]
    var menuOptionImageNameArray : [String] = ["favorite-menu-icon","news","map-icon","about-us"]
    var alreadySearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Do any additional setup after loading the view.
        
        //To move the menu button when keyboard appears
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        APIHelper.getNowPlaying(page: 1, updatingCollectionView: collectionView, onCompletion:{}, storageManager: self)
        gradient.colors = [UIColor.init(red: 0.5, green: 0, blue: 0.1, alpha: 0.2).cgColor, UIColor.init(red: 0.53, green: 0.06, blue: 0.27, alpha: 1.0).cgColor]
        backgroundView.layer.insertSublayer(gradient, at: 0)
        
        
        //Menu sizes depending on device
        if(UIDevice.current.userInterfaceIdiom == .pad){
            let menuConfiguration = FTConfiguration.shared
            menuConfiguration.menuWidth = self.view.frame.width/3
            menuConfiguration.textAlignment = .natural
            menuConfiguration.textFont = UIFont(name: "HelveticaNeue-Light", size: 30.0)!
            menuButtonWidth.constant = 80
        }
        else{
            let menuConfiguration = FTConfiguration.shared
            menuConfiguration.menuWidth = self.view.frame.width*2/3
            menuConfiguration.textAlignment = .natural
            menuConfiguration.textFont = UIFont(name: "HelveticaNeue-Light", size: 20.0)!
            menuButtonWidth.constant = 50
        }
        
        //To hide keyboard
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tapGR)
    }

    
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if menuButton.frame.origin.y > (self.view.frame.height - keyboardSize.height - menuButton.frame.height) {
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
    
    func dismissKeyboard(){
        self.view.endEditing(true)
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
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) / scrollView.contentSize.height > 0.95) && showingNowPlaying && !alreadySearching){
            alreadySearching = true
            APIHelper.getNowPlaying(page: appDelegate!.model.foundItems.count/20 + 1, updatingCollectionView: collectionView, onCompletion: {self.alreadySearching = false}, storageManager: self)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
                //Do not allow user to filter by favorite
                if mediaArray.count == 0 {
                   let alert = AlertHelper.createInfoAlert(title: "¡No tienes favoritos!", text: "Usa el icono de la estrella para guardar elementos en tus favoritos.")
                    self.present(alert, animated: true, completion: nil)
                    break
                }
                self.appDelegate?.model.foundItems = mediaArray
                self.collectionView.reloadData()
                break;
            case 1:
                self.showingNowPlaying = true
                self.appDelegate?.model.foundItems = []
                self.collectionView.reloadData()
                APIHelper.getNowPlaying(page: 1, updatingCollectionView: self.collectionView, onCompletion: {},storageManager: self)
                break;
            case 2:
                self.performSegue(withIdentifier: "CinemaSegue", sender: self)
            case 3:
                self.performSegue(withIdentifier: "AboutSegue", sender: self)
                break;
            default:break;
            }
        }) {
           sender.setBackgroundImage(UIImage.init(named: "menu-image-empty"), for: .normal)
        }
        
        sender.setBackgroundImage(UIImage.init(named: "menu-image-full"), for: .normal)    }
    
    //Allows the user to move the menu button
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
        (loadingView,activityIndicator) = AlertHelper.createLoadingView()
        
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
                                let alert = AlertHelper.createInfoAlert(title: "Error de conexión", text: "La conexión puede ser intermitente o el servidor no estar disponible.")
                                self.present(alert, animated: true, completion: nil)
        })
    }
    
    func setMediaPage(mediaArray: [Media]){
        
        var numberOfItems = appDelegate!.model.foundItems.count
        appDelegate?.model.foundItems.append(contentsOf: mediaArray)
        
        var indexPaths:[IndexPath] = []
        while numberOfItems < (appDelegate?.model.foundItems.count)!{
            indexPaths.append(IndexPath(row: numberOfItems, section: 0))
            numberOfItems+=1
        }
        collectionView.insertItems(at:indexPaths)
    }
    
    func setMediaSearch(mediaArray: [Media]) {
        appDelegate?.model.foundItems = mediaArray
        collectionView.reloadData()
        
    }
    
}
