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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.media = appDelegate!.model.selectedMedia!
        backgroundView.layer.insertSublayer(gradient, at: 0)
        
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
        print(media!.media_type)
        if (media?.media_type == "movie"){
            let duration = media?.details["runtime"] as? Int ?? 0
            if( duration != 0){
                runtimeLabel = LabelGenerator.createTextLabel(string: "\(duration)min", textAlignment: .center, textColor: UIColor.yellow)
            }
            else{
                runtimeLabel = LabelGenerator.createTextLabel(string: "No hay información sobre su duración", textAlignment: .center, textColor: UIColor.yellow)
            }
        }
        else if(media?.media_type == "tv"){
            let duration = media?.details["episode_run_time"] as? [Int] ?? [0]
            var total = 0
            for value in duration {
                total += value
            }
            print(total)
            print(duration.count)
            if(duration.count != 0 ){
                let count = total / duration.count
                runtimeLabel = LabelGenerator.createTextLabel(string: "\(count)min/capítulo (\(media?.details["number_of_episodes"] as! Int))", textAlignment: .center, textColor: UIColor.yellow)
            }
            else {
                runtimeLabel = LabelGenerator.createTextLabel(string: "No hay información sobre la duración de los capítulos", textAlignment: .center, textColor: UIColor.yellow)
            }
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
                genresTextLabel.text?.append(genreName.uppercased())
                genresTextLabel.text?.append(" ")
                genresTextLabel.textColor = UIColor(colorLiteralRed: 1, green: 153.0/255.0, blue: 204.0/255.0, alpha: 1)
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
                if (count != 0){
                    companiesTextLabel.text?.append("\n")
                }
                count-=1;
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
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let nsdate = dateFormatter.date(from: date)
                dateFormatter.dateFormat = "dd/MM/yyyy"
                moreInfoTextLabel.text?.append("Fecha de lanzamiento: \(dateFormatter.string(from: nsdate!))")
            }
        }
        else{
            if let date = media?.details["first_air_date"] as? String {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let nsdate = dateFormatter.date(from: date)
                dateFormatter.dateFormat = "dd/MM/yyyy"
                moreInfoTextLabel.text?.append("Fecha del primer episodio: \(dateFormatter.string(from: nsdate!))")
            }
            if let lastDate = media?.details["last_air_date"] as? String {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let nsdate = dateFormatter.date(from: lastDate)
                dateFormatter.dateFormat = "dd/MM/yyyy"
                moreInfoTextLabel.text?.append("\nFecha del último episodio: \(dateFormatter.string(from: nsdate!))")
            }
            if let seasonsNumber = media?.details["number_of_seasons"] as? Int {
                moreInfoTextLabel.text?.append("\nNúmero de temporadas: \(seasonsNumber)")
            }
        }
        stackView.addArrangedSubview(moreInfoTextLabel)
    }
    
}
