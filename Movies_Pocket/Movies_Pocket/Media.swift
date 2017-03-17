//
//  Media.swift
//  Movies Pocket
//
//  Created by Diego Manuel Molina Canedo on 28/2/17.
//  Copyright © 2017 Universidad Pontificia de Salamanca. All rights reserved.
//

import Foundation

class Media {
    
    let id:Int
    let title: String
    let poster_path: String
    let overview: String
    let vote_average: Double
    let media_type : String
    var details: [String:AnyObject]
    
    init(id: Int,
        title: String,
        poster_path: String,
        overview: String,
        vote_average: Double,
        media_type : String,
        details: [String:AnyObject]){
        self.id = id
        self.title = title
        self.poster_path = poster_path
        self.overview = overview
        self.vote_average = vote_average
        self.media_type = media_type
        self.details = details
    }
    
    //COMPATIBILITY WITH CORE-DATA ENTITIES
    class func createMediaFrom(mediaEntity entity: MediaEntity) -> (Media){
        let media = Media(id: Int(entity.id), title: entity.title!, poster_path: entity.poster_path!, overview: entity.overview!, vote_average: entity.vote_average, media_type: entity.media_type!, details: [:])
        return media
    }
    
    class func createMediaArrayFrom(mediaEntityArray: [MediaEntity]) -> ([Media]){
        var mediaArray:[Media] = []
        for entity in mediaEntityArray {
            mediaArray.append(Media.createMediaFrom(mediaEntity: entity))
        }
        return mediaArray
    }
    //-------------------------------------
}
