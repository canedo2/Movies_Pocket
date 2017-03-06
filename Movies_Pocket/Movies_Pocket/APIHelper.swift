//
//  APIHelper.swift
//  TMDPrueba
//
//  Created by Diego Manuel Molina Canedo on 16/2/17.
//  Copyright © 2017 Universidad Pontificia de Salamanca. All rights reserved.
//

import Foundation
import UIKit

class APIHelper {
    
    /*API STRINGS*/
    static let urlImagesString = "https://image.tmdb.org/t/p/w500"
    static let urlNowPlayingString = "https://api.themoviedb.org/3/movie/now_playing?api_key=e8f58c65a7f1442fb4df99e10ae45604&language=es-ES&page="
    static let urlSearch = "https://api.themoviedb.org/3/search/multi?api_key=e8f58c65a7f1442fb4df99e10ae45604&language=es-ES&include_adult=false"
    static let urlMovieDetails = "https://api.themoviedb.org/3/movie/"
    
    /*GET /SEARCH REQUEST */
    class func getSearch(page: Int, searchString: String, collectionView: UICollectionView?){
        let url = urlSearch.appending("&query=\(searchString)&page=\(page)")
        
        let session = URLSession(configuration: .default)
        let urlRequest = URLRequest(url: URL(string: url)!)
    
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else{
                print ("Error in dataTask: search: \(error)")
                return
            }
            guard let responseData = data else{
                print("Error in dataTask: Did not recieve data")
                return
            }
            
            let results = convertResultsToJSON(data: responseData)
            let items = convertToItemsArray(array: results! as! [[String:AnyObject]])
            let media = items as? [Media] ?? []
            DispatchQueue.main.async {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.model.foundItems = media
                collectionView?.reloadData()
                print("Data retrieved")
            }
        }
        dataTask.resume()
    }
    
    /*GET /MOVIE/NOW_PLAYING REQUEST */
    class func getNowPlaying(page: Int,reloadingCollectionView cv: UICollectionView?){
        let url = urlNowPlayingString.appending("\(page)");
        
        let session = URLSession(configuration: .default)
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else{
                print ("Error in dataTask: getNowPlaying: \(error)")
                return
            }
            guard let responseData = data else{
                print("Error in dataTask: Did not recieve data")
                return
            }
            guard let results = convertResultsToJSON(data: responseData) else{
                print("Error in dataTask: converToJSON")
                return
            }
            
            let items = convertToItemsArray(array: results as! [[String:AnyObject]])
            let media = items as? [Media] ?? []
            
            DispatchQueue.main.async {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.model.foundItems.append(contentsOf: media)
                cv?.reloadData()
                print("Data retrieved")
            }
        }
        dataTask.resume()
        
    }
    
    /* GET IMAGE FROM URL AND ADD IT TO UIImageView */
    class func getImage(image: UIImageView, imageString: String){
        let url = urlImagesString.appending(imageString)
        
        let session = URLSession(configuration: .default)
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        let dataTask = session.dataTask(with: urlRequest) { (data, responseData, error) in
            guard error == nil else {
                print("\(error) -> Error in dataTask: Popular movies")
                return
            }
            
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            guard let imageToShow = UIImage.init(data: responseData) else{
                print("Error: Couldn't generate the UIIMage")
                DispatchQueue.main.async {
                    image.image = UIImage(named: "1")
                }
                return
            }
            
            DispatchQueue.main.async {
                //print("Image printed")
                image.image = imageToShow
            }
        }
        dataTask.resume()
     }
    
    class func getDetails(media: Media, onCompletion: @escaping (Void) -> Void, onError: @escaping (Void) -> Void){
        
        print(media.media_type)
        switch(media.media_type){
        case "movie":
            let url = urlMovieDetails.appending("\(media.id)?api_key=e8f58c65a7f1442fb4df99e10ae45604&language=es-ES");
        
            let session = URLSession(configuration: .default)
            let urlRequest = URLRequest(url: URL(string: url)!)
            
            let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
                guard error == nil else{
                    print ("Error in dataTask: getNowPlaying: \(error)")
                    onError()
                    return
                }
                guard let responseData = data else{
                    print("Error in dataTask: Did not recieve data")
                    onError()
                    return
                }
                guard let results = convertToJSON(data: responseData) else{
                    print("Error in dataTask: converToJSON")
                    onError()
                    return
                }
                media.details = results
                
                DispatchQueue.main.async {
                    onCompletion()
                    //print("Data retrieved")
                }
            }
            dataTask.resume()
            break;
        default:
            break;
        }
        
    }
    
    /* CONVERTS FROM DATA TO DICTIONARY*/
    class func convertToJSON(data:Data) -> [String:AnyObject]?{
        let result:[String:AnyObject]?
        do{
            guard let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else {
                print("Error in dataTask: Couldn't to convert data to JSON")
                return nil
            }
            result = jsonData
        }
        catch{
            print("Error in dataTask: Exception (Data to JSON)")
            return nil
        }
        return result
    }
    
    /* CONVERTS FROM DATA TO DICTIONARY AND GET THE ITEM WITH KEY=RESULT*/
    class func  convertResultsToJSON(data: Data) -> AnyObject?{
        let results: AnyObject?
        do {
            guard let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else {
                print("Error in dataTask: Couldn't to convert data to JSON")
                return nil
            }
            results =  jsonData["results"]
        } catch  {
            print("Error in dataTask: Exception (Data to JSON)")
            return nil
        }
        return results
    }
    
    
    /* CONVERTS FROM DICTIONARY TO ITEM */
    class  func convertToItem(dictionary: [String:AnyObject]) -> Any?{
        
        var item : Any?
        // NOW PLAYING MOVIES REQUEST RETURNS NO "media_type"
        if dictionary["media_type"] == nil{
            item = Media(id: dictionary["id"] as? Int ?? 0,
                         title: dictionary["title"] as? String ?? "Sin título",
                         poster_path: dictionary["poster_path"] as? String ?? "",
                         overview: dictionary["overview"] as? String ?? "Sin sinopsis",
                         vote_average: dictionary["vote_average"] as? Double ?? 0.0,
                         media_type: dictionary["media_type"] as? String ?? "movie",
                         details: [:])
        }
        else if(dictionary["media_type"] as! String == "movie"){
            item = Media(id: dictionary["id"] as? Int ?? 0,
                        title: dictionary["title"] as? String ?? "Sin título",
                        poster_path: dictionary["poster_path"] as? String ?? "",
                        overview: dictionary["overview"] as? String ?? "Sin sinopsis",
                        vote_average: dictionary["vote_average"] as? Double ?? 0.0,
                        media_type: dictionary["media_type"] as? String ?? "No type",
                        details: [:])
        }
        else if(dictionary["media_type"] as! String == "tv"){
            item = Media(id: dictionary["id"] as? Int ?? 0,
                            title: dictionary["name"] as? String ?? "Sin título",
                            poster_path: dictionary["poster_path"] as? String ?? "",
                            overview: dictionary["overview"] as? String ?? "Sin sinopsis",
                            vote_average: dictionary["vote_average"] as? Double ?? 0.0,
                            media_type: dictionary["media_type"] as? String ?? "No type",
                            details: [:])
        }
        
        //ELSE PERSON NOT IMPLEMENTED
        
        return item
    }
    
    /*CONVERTS FROM DICTIONARY TO ITEMS USING THE FUNCTION ABOVE*/
    
    class func convertToItemsArray(array: [[String:AnyObject]]) -> [Any]{
        var items = [Any]()
        for i in array{
            guard let item = convertToItem(dictionary: i) else{
                print("Error convertToItemsArray")
                return items
            }
            items.append(item)
        }
        return items
    }
    
    
}
