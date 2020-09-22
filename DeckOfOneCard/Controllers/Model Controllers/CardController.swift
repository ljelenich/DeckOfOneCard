//
//  CardController.swift
//  DeckOfOneCard
//
//  Created by LAURA JELENICH on 9/22/20.
//

import Foundation
import UIKit.UIImage

class CardController {
    
    static let baseURL = URL(string: "https://deckofcardsapi.com/api/deck/new/draw")
    
    static func fetchCard(completion: @escaping (Result <Card, CardError>) -> Void) {
        guard let url = baseURL else {return completion(.failure(.invalidURL))}
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            guard let data = data else {return completion(.failure(.noData))}
            
            do {
                let topLevelObject = try JSONDecoder().decode(TopLevelObject.self, from: data)
                guard let card = topLevelObject.cards.first else {return completion(.failure(.noData))}
                return completion(.success(card))
            } catch {
                completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
    
    static func fetchImage(for card: Card, completion: @escaping (Result<UIImage, CardError>) -> Void) {
        let imageURL = card.image
        URLSession.shared.dataTask(with: imageURL) { (data, _, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            guard let data = data else {return completion(.failure(.noData))}
            guard let image = UIImage(data: data) else {return}
            return completion(.success(image))
        }.resume()
    }
}
