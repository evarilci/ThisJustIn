//
//  SearchViewModel.swift
//  ThisJustIn
//
//  Created by Eymen Varilci on 15.07.2023.
//

import Foundation

protocol SearchViewModelDelegate: AnyObject {
    func reloadTableView()
    func fetchArticlesFailed(error: TJIError)
    func isSearching(bool: Bool)
}

protocol SearchViewModelProtocol {
    var delegate: SearchViewModelDelegate? { get set }
    var articles: [Article] { get set }
    var filteredArticles: [Article] { get set }
    var isFiltering: Bool { get }
    func viewDidLoad()
    func getArticles(category: String) async throws
    func filterArticles(with keyword: String)
    func cancelFiltering()
    func getArticle(at index: Int) -> Article
    func getArticleCount() -> Int
    func getArticleURL(at index: Int) -> URL?
}


class SearchViewModel: SearchViewModelProtocol {
    var delegate: SearchViewModelDelegate?
    var articles = [Article]()
    var filteredArticles = [Article]()
    var isFiltering = false
    
    func viewDidLoad()  {
        Task {
            do {
                try await getArticles(category: "general")
            } catch TJIError.invalidURL {
                print("Invalid URL")
            } catch TJIError.badResponse {
                print("Bad Response")
            } catch TJIError.invalidData {
                print("Invalid Data")
            } catch {
                print("Unknown Error")
            }
        }
    }
    
    func getArticles(category: String) async throws {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "newsapi.org"
        components.path = "/v2/top-headlines"
        components.queryItems = [
            URLQueryItem(name: "apiKey", value: "17b7846220c445dd97e7c7a8806a186f"),
            URLQueryItem(name: "category", value: category),
            URLQueryItem(name: "country", value: "us")
        ]
        
        guard let url = components.url else {throw TJIError.invalidURL}
        let ( data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw TJIError.badResponse }
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let article = try decoder.decode(Response.self, from: data)
            guard let articles = article.articles else {throw TJIError.invalidData}
            self.articles = articles
            delegate?.reloadTableView()
        } catch {
            delegate?.fetchArticlesFailed(error: TJIError.invalidData)
            print(error.localizedDescription)
            throw TJIError.invalidData
        }
    }
    
    func filterArticles(with keyword: String) {
        filteredArticles = articles.filter { $0.title!.lowercased().contains(keyword.lowercased()) }
        isFiltering = true
        delegate?.isSearching(bool: true)
        
        delegate?.reloadTableView()
    }
    
    func cancelFiltering() {
        isFiltering = false
        delegate?.isSearching(bool: false)
        delegate?.reloadTableView()
    }
    
    
    func getArticle(at index: Int) -> Article {
        return isFiltering ? filteredArticles[index] : articles[index]
    }
    
    func getArticleCount() -> Int {
        //  print(filteredArticles.count ,"-filtered   articles-", articles.count)
        return isFiltering ? filteredArticles.count : articles.count
    }
    
    func getArticleURL(at index: Int) -> URL? {
        return URL(string: getArticle(at: index).url!)
    }
}

