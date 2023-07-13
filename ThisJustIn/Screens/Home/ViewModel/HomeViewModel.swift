//
//  HomeViewModel.swift
//  ThisJustIn
//
//  Created by Eymen Varilci on 13.07.2023.
//

import UIKit

protocol HomeViewModelDelegate: AnyObject {
    func fetchArticalsSucceed(artical: Response )
    func fetchArticalsFailed(error: TJIError)
    
}

protocol HomeViewModelProtocol {
    var delegate: HomeViewModelDelegate? {get set}
    func fetchArtical() async throws -> Response
}



class HomeViewModel: HomeViewModelProtocol {
    var delegate: HomeViewModelDelegate?
    func fetchArtical() async throws -> Response {
        let endpoint = "https://newsapi.org/v2/top-headlines?country=us&apiKey=17b7846220c445dd97e7c7a8806a186f"
        guard let url = URL(string: endpoint) else {throw TJIError.invalidURL}
        let ( data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw TJIError.badResponse }
        do {
           let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let artical = try decoder.decode(Response.self, from: data)
            delegate?.fetchArticalsSucceed(artical: artical)
            return artical
        } catch {
            delegate?.fetchArticalsFailed(error: TJIError.invalidData)
            print(error.localizedDescription)
            throw TJIError.invalidData
        
            
        }
    }
    
    
}

