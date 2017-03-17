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
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var favoriteButton: FavoriteButton!
    @IBOutlet weak var ratingView: MBCircularProgressBarView!
    @IBOutlet weak var stackView: UIStackView!
    
    let gradient = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        gradient.frame = view.bounds
        gradient.colors = [UIColor.init(red: 0.5, green: 0, blue: 0.1, alpha: 0.2).cgColor, UIColor.init(red: 0.53, green: 0.06, blue: 0.27, alpha: 1.0).cgColor]
        backgroundView.layer.insertSublayer(gradient, at: 0)
        
        self.media = appDelegate!.model.selectedMedia!
        
        configureStaticContent()
        
        fillStackView()
        
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
    
    func configureStaticContent(){
        titleView.text = media?.title
        self.ratingView.value = 0.0
        APIHelper.getImage(imageView: imageView, imageString: media!.poster_path/*, onCompletion:{}, onError: {}*/)
    
    }
    
    func fillStackView(){
        
        stackView.spacing = 8.0
        
        //OVERVIEW - TITLE
        let overviewTitleLabel = LabelGenerator.createTitleLabel(string: "Sinopsis")
        stackView.addArrangedSubview(overviewTitleLabel)
        
        //OVERVIEW - TEXT
        let overviewTextLabel: UILabel
        if media?.overview == "" {
            overviewTextLabel = LabelGenerator.createTextLabel(string: "No hay sinopsis disponible", textAlignment: .center, textColor: nil)
        }
        else{
            overviewTextLabel = LabelGenerator.createTextLabel(string: media?.overview, textAlignment: .justified, textColor: nil)
        }
        stackView.addArrangedSubview(overviewTextLabel)
        
        //DURATION
        let runtimeLabel: UILabel
        if (media?.media_type == "movie"){
            let duration = media?.details["runtime"] as? Int ?? 0
            runtimeLabel = LabelGenerator.createTitleLabel(string: "\(duration)min")
            runtimeLabel.textColor = UIColor.yellow
            runtimeLabel.font = UIFont.italicSystemFont(ofSize: 20)
        }
        else if(media?.media_type == "tv"){
            let duration = media?.details["episode_run_time"] as? [Int] ?? [0]
            var total = 0
            for value in duration {
                total += value
            }
            let count = total / duration.count
            runtimeLabel = LabelGenerator.createTitleLabel(string: "\(count)min/capítulo (\(media?.details["number_of_episodes"] as! Int))")
            runtimeLabel.textColor = UIColor.yellow
            runtimeLabel.font = UIFont.italicSystemFont(ofSize: 20)
        }
        else{
            runtimeLabel = LabelGenerator.createTitleLabel(string: "No hay información sobre la duración")
            runtimeLabel.textColor = UIColor.yellow
            runtimeLabel.font = UIFont.italicSystemFont(ofSize: 20)
        }
        stackView.addArrangedSubview(runtimeLabel)
        
        //GENRES - TITLE
        let genresTitleLabel = LabelGenerator.createTitleLabel(string: "Géneros")
        stackView.addArrangedSubview(genresTitleLabel)
        
        
        //GENRES - TEXT
        let genres = media?.details["genres"]
        
        let genresTextLabel = LabelGenerator.createTextLabel(string: "", textAlignment: .center, textColor: nil)
        
        if (genres?.count)! > 1 {
            for genre in (genres as? NSArray ?? []){
                let genreItem = genre as! [String:Any]
                let genreName = genreItem["name"] as! String
                genresTextLabel.text?.append(genreName)
                genresTextLabel.text?.append(" ")
            }
        }
        else{
            genresTextLabel.text?.append("No hay géneros disponibles")
            
        }
        stackView.addArrangedSubview(genresTextLabel)
        
        //COMPANIES - TITLE
        let companiesTitleLabel = LabelGenerator.createTitleLabel(string: "Productoras")
        stackView.addArrangedSubview(companiesTitleLabel)
        
        //COMPANIES - TEXT
        let companies = media!.details["production_companies"]
        
        let companiesTextLabel = LabelGenerator.createTextLabel(string: "", textAlignment: .center, textColor: nil)
        if (companies?.count)! > 1{
            var count = companies!.count - 1
            for company in (companies as? NSArray ?? []){
                let companyItem = company as! [String:Any]
                let companyName = companyItem["name"] as! String
                
                companiesTextLabel.text?.append(companyName)
                
                count-=count;
                if (count != 0){
                    companiesTextLabel.text?.append("\n")
                }
            }
        }
        else{
            companiesTextLabel.text?.append("No hay productoras disponibles")
        }
        stackView.addArrangedSubview(companiesTextLabel)
        
        //MORE INFO - TITLE
        let moreInfoTitleLabel = LabelGenerator.createTitleLabel(string: "Más información")
        stackView.addArrangedSubview(moreInfoTitleLabel)
        
        //MORE INFO - TEXT
        let moreInfoTextLabel = LabelGenerator.createTextLabel(string: "", textAlignment: .center, textColor: nil)
        
        if(media?.media_type == "movie"){
            if let date = media?.details["release_date"] as? String {
                moreInfoTextLabel.text?.append("Fecha de lanzamiento: \(date)")
            }
        }
        else{
            if let date = media?.details["first_air_date"] as? String {
                moreInfoTextLabel.text?.append("Fecha del primer episodio: \(date)")
            }
            if let lastDate = media?.details["last_air_date"] as? String {
                moreInfoTextLabel.text?.append("\nFecha del último episodio: \(lastDate)")
            }
            if let seasonsNumber = media?.details["number_of_seasons"] as? Int {
                moreInfoTextLabel.text?.append("\nNúmero de temporadas: \(seasonsNumber)")
            }
        }
        stackView.addArrangedSubview(moreInfoTextLabel)
    }
    
}
