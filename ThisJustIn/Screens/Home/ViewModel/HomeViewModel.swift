//
//  HomeViewModel.swift
//  ThisJustIn
//
//  Created by Eymen Varilci on 13.07.2023.
//

import UIKit

protocol HomeViewModelDelegate: AnyObject {
    func fetchArticlesSucceed(article: Response )
    func fetchArticlesFailed(error: TJIError)
}

protocol HomeViewModelProtocol {
    var delegate: HomeViewModelDelegate? {get set}
    func viewDidLoad()
    func fetchArticle() async throws -> Response
    func numberOfRows() -> Int
    func articleFor(row at: Int) -> Article
    
}
final class HomeViewModel: HomeViewModelProtocol {
    
    
    
    var delegate: HomeViewModelDelegate?
    private var response: Response?
    
    func fetchArticle() async throws -> Response {
        
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "newsapi.org"
        components.path = "/v2/top-headlines"
        components.queryItems = [
            URLQueryItem(name: "apiKey", value: "17b7846220c445dd97e7c7a8806a186f"),
            URLQueryItem(name: "country", value: "us"),
        ]
        
        guard let url = components.url else {throw TJIError.invalidURL}
        
        let ( data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw TJIError.badResponse }
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let article = try decoder.decode(Response.self, from: data)
            self.response = article
            delegate?.fetchArticlesSucceed(article: article)
            
            return article
        } catch {
            delegate?.fetchArticlesFailed(error: TJIError.invalidData)
            print(error.localizedDescription)
            throw TJIError.invalidData
        }
    }
    func viewDidLoad() {
        Task {
            let _ = try await fetchArticle()
        }
        
    }
    
    func numberOfRows() -> Int {
        guard let articles = response?.articles else {return 0}
        return articles.count
    }
    
    func articleFor(row at: Int) -> Article {
        guard let articles = response?.articles else {return Article(source: nil, author: nil, title: nil, description: nil, url: nil, urlToImage: nil, publishedAt: nil, content: nil)}
        return articles[at]
    }
    
}

