//
//  DetailsViewController.swift
//  Movies_Pocket
//
//  Created by Diego Manuel Molina Canedo on 6/3/17.
//  Copyright © 2017 Universidad Pontificia de Salamanca. All rights reserved.
//

import UIKit

class DetailsViewController: BaseViewController {
    var media: Media? = nil
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var runtimeView: UILabel!
    @IBOutlet weak var overviewView: UILabel!
    @IBOutlet weak var genresView: UILabel!
    @IBOutlet weak var companiesView: UILabel!
    @IBOutlet weak var voteAverageView: UILabel!
    @IBOutlet weak var moreInfo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.media = appDelegate!.model.selectedMedia!
        
        APIHelper.getImage(image: imageView, imageString: media!.poster_path, onCompletion:{}, onError: {})
        titleView.text = media?.title
        voteAverageView.text = "\(media!.vote_average) / 10"
        
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
