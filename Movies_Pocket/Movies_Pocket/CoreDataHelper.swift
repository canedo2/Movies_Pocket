//
//  CoreDataHelper.swift
//  Movies_Pocket
//
//  Created by Diego Manuel Molina Canedo on 13/3/17.
//  Copyright © 2017 Universidad Pontificia de Salamanca. All rights reserved.
//

import Foundation
import CoreData

class CoreDataHelper {
    
    class func saveMedia(media: Media) {
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let coreDataStack = appDelegate.coreDataStack
        let managedContext = coreDataStack.context
        
        let entity =  NSEntityDescription.entity(forEntityName: "MediaEntity",
                                                 in:managedContext)
        
        let mediaEntity = NSManagedObject(entity: entity!,
                                          insertInto: managedContext)
        
        mediaEntity.setValue(media.id, forKey: "id")
        mediaEntity.setValue(media.media_type, forKey: "media_type")
        mediaEntity.setValue(media.overview, forKey: "overview")
        mediaEntity.setValue(media.poster_path, forKey: "poster_path")
        mediaEntity.setValue(media.vote_average, forKey: "vote_average")
        
        do {
            try managedContext.save()
            
            appDelegate.storedFavoriteMedia.append(mediaEntity as! MediaEntity)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    
    class func removeMedia(media: Media) {
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let coreDataStack = appDelegate.coreDataStack
        let managedContext = coreDataStack.context
        
        var index = 0
        for mediaEntity in appDelegate.storedFavoriteMedia{
            
            if(media.id.toIntMax() == mediaEntity.id.toIntMax()){
                managedContext.delete(mediaEntity)
                break;
            }
            index += 1
        }
        
        do {
            try managedContext.save()
            appDelegate.storedFavoriteMedia.remove(at: index)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    class func loadMedia(){
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let coreDataStack = appDelegate.coreDataStack
        let managedContext = coreDataStack.context
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MediaEntity")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            appDelegate.storedFavoriteMedia = results as! [MediaEntity]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }
}
