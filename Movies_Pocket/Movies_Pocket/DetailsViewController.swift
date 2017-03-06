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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.media = appDelegate!.model.selectedMedia!
        
        APIHelper.getImage(image: imageView, imageString: media!.poster_path)
        titleView.text = media?.title
        voteAverageView.text = "\(media!.vote_average) / 10"
        
        let duration = media?.details["runtime"] as? Int ?? 0
        runtimeView.text = "\(duration)min"
        
        overviewView.text = media?.overview
        
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
        
        for company in (companies as? NSArray ?? []){
            let companyItem = company as! [String:Any]
            let companyName = companyItem["name"] as! String
            
            companiesView.text?.append(companyName)
            companiesView.text?.append("\n")
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

}
