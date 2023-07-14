//
//  New.swift
//  ThisJustIn
//
//  Created by Eymen Varilci on 13.07.2023.
//

import Foundation
import UIKit.UIImage


// MARK: - Response
struct Response: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [Article]?
}

// MARK: - Article
struct Article: Codable {
    let source: Source?
    let author: String?
    let title, description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String?
}

struct SavedArticle {
    let source: String?
   
    let title, description: String?
    let image : UIImage
    
    init(data: [String: Any]) {
        self.source = data[K.CoreData.source] as! String
        self.title = data[K.CoreData.title] as! String
        self.description = data[K.CoreData.content] as! String
        self.image = data[K.CoreData.image] as! UIImage
    }
    
}
