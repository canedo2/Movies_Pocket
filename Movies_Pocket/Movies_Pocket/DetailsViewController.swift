//
//  DetailsViewController.swift
//  Movies_Pocket
//
//  Created by Diego Manuel Molina Canedo on 6/3/17.
//  Copyright © 2017 Universidad Pontificia de Salamanca. All rights reserved.
//

import UIKit

class DetailsViewController: BaseViewController {
    var media: Media?
    var previousCollectionView: UICollectionView?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var runtimeView: UILabel!
    @IBOutlet weak var overviewView: UILabel!
    @IBOutlet weak var genresView: UILabel!
    @IBOutlet weak var companiesView: UILabel!
    @IBOutlet weak var moreInfo: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var favoriteButton: FavoriteButton!
    @IBOutlet weak var ratingView: MBCircularProgressBarView!
    
    let gradient = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        gradient.frame = view.bounds
        gradient.colors = [UIColor.init(red: 0.5, green: 0, blue: 0.1, alpha: 0.2).cgColor, UIColor.init(red: 0.53, green: 0.06, blue: 0.27, alpha: 1.0).cgColor]
        backgroundView.layer.insertSublayer(gradient, at: 0)
        
        self.media = appDelegate!.model.selectedMedia!
        
        self.ratingView.value = 0.0
        
        APIHelper.getImage(image: imageView, imageString: media!.poster_path, onCompletion:{}, onError: {})
        titleView.text = media?.title
        
        if (media?.media_type == "movie"){
            let duration = media?.details["runtime"] as? Int ?? 0
            runtimeView.text = "\(duration)min"
        }
        else{
            let duration = media?.details["episode_run_time"] as? [Int] ?? [0]
            var total = 0
            for value in duration {
                total += value
            }
            
            let count = total / duration.count
            runtimeView.text = "\(count)min/capítulo (\(media?.details["number_of_episodes"] as! Int))"
        }
        
        if media?.overview == "" {
            overviewView.text = "No hay sinopsis disponible"
        }
        else{
            overviewView.text = media?.overview
        }
        
        let genres = media?.details["genres"]
        
        genresView.text = ""
        
        for genre in (genres as? NSArray ?? []){
            let genreItem = genre as! [String:Any]
            let genreName = genreItem["name"] as! String
            genresView.text?.append(genreName)
            genresView.text?.append(" ")
        }
        
        let companies = media!.details["production_companies"]
        
        companiesView.text = ""
        var count = companies!.count - 1
        for company in (companies as? NSArray ?? []){
            let companyItem = company as! [String:Any]
            let companyName = companyItem["name"] as! String
            
            companiesView.text?.append(companyName)
            
            count-=count;
            if (count != 0){
                companiesView.text?.append("\n")
            }
            
        }
        
        moreInfo.text = ""
        if(media?.media_type == "movie"){
            if let date = media?.details["release_date"] as? String {
                moreInfo.text?.append("Fecha de lanzamiento: \(date)")
            }
        }
        else{
            if let date = media?.details["first_air_date"] as? String {
                moreInfo.text?.append("Fecha del primer episodio: \(date)")
            }
            if let lastDate = media?.details["last_air_date"] as? String {
                moreInfo.text?.append("\nFecha del último episodio: \(lastDate)")
            }
            if let seasonsNumber = media?.details["number_of_seasons"] as? Int {
                moreInfo.text?.append("\nNúmero de temporadas: \(seasonsNumber)")
            }
        }
        
        favoriteButton.setFavorite(state: false)
        for favoriteMedia in (appDelegate?.storedFavoriteMedia)!{
            if favoriteMedia.id.toIntMax() == media?.id.toIntMax() {
                favoriteButton.setFavorite(state: true)
                break;
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backAction(_ sender: Any) {
        previousCollectionView?.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradient.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 2.0) {
            self.ratingView.value = CGFloat(self.media!.vote_average * 10)
        }
    }
    
    @IBAction func favoriteButtonAction(_ sender: FavoriteButton) {
        
        if sender.favorite {
            sender.setFavorite(state: false)
            CoreDataHelper.removeMedia(media: media!)
        }
        else{
            sender.setFavorite(state: true)
            CoreDataHelper.saveMedia(media: media!)
        }
    }
    
}
