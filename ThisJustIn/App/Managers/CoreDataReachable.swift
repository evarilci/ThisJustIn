//
//  CoreDataReachable.swift
//  ThisJustIn
//
//  Created by Eymen Varilci on 14.07.2023.
//

import UIKit
import CoreData
import Kingfisher

protocol CoreDataReachable where Self: UIViewController {
    
}


extension CoreDataReachable {
    
    func saveArticleToBookmarks(source: String, title: String, content: String, url: String, image: String, completion: @escaping(String) -> Void) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: K.CoreData.Entity)
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let existingPokemons = try context.fetch(fetchRequest)
            if let _ = existingPokemons.first {
                 completion("article Exists")
                return
            }
            let imageView = UIImageView()
            imageView.kf.setImage(with: URL(string: image))
            let article = NSEntityDescription.insertNewObject(forEntityName: K.CoreData.Entity, into: context)
            let data = imageView.image!.jpegData(compressionQuality: 1)
            article.setValue(title, forKey: K.CoreData.title)
            article.setValue(content, forKey: K.CoreData.content)
            article.setValue(source, forKey: K.CoreData.source)
            article.setValue(data, forKey: K.CoreData.image)
            try context.save()
            completion("article added to bookmarks")
            print("core data saved")
        } catch {
            print("Core data save failed")
        
        }
    }
    
    func fetchArticle() throws -> [SavedArticle] {
        var arr = [SavedArticle]()
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: K.CoreData.Entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        
        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                let title = result.value(forKey: K.CoreData.title) as! String
                let content = result.value(forKey: K.CoreData.content) as! String
                let source = result.value(forKey: K.CoreData.source) as! String
                let data = result.value(forKey: K.CoreData.image) as! Data
                guard let image = UIImage(data: data) else {throw TJIError.imageCorrupted}
                let dict : [String : Any] = [K.CoreData.title : title, K.CoreData.content : content, K.CoreData.source : source, K.CoreData.image: image]
                let article = SavedArticle(data: dict)
                arr.append(article)
                
            }
        } catch TJIError.coreFetchFailed {
            print("Core data fetch failed")
        }
        return arr
    }
    
}
