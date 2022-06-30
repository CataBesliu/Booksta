//
//  Network.swift
//  booksta
//
//  Created by Catalina Besliu on 30.06.2022.
//

import Foundation
import SwiftUI
import Resolver

class BookRecommenderAPI: ObservableObject {
    @Published var book: BookModel? = nil
    @Published var noDataReturned = false
    @State var dataTask: URLSessionDataTask?
    @State var observation: NSKeyValueObservation?
    @State var progress: Double = 0
    let total: Double = 1
    
    
    func getBookRecommendation(userID: String,
                  urlString: String = "https://us-central1-booksta-92688.cloudfunctions.net/app/recommendation/") {
        guard let url = URL(string: "\(urlString)\(userID)") else {
            noDataReturned = true
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        dataTask = URLSession.shared.dataTask(with: urlRequest) {[weak self] (data, response, error) in
            guard let `self` = self else { return }
            //invalidate observation
            self.observation?.invalidate()
            
            if let error = error {
                print("Request error: ", error)
                self.noDataReturned = true
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let decodedBook = try JSONDecoder().decode(DataDecodable  .self, from: data)
                        self.book = BookModel(decodedObject: decodedBook)
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            } else if response.statusCode == 204 {
                self.book = nil
                self.noDataReturned = true
            }
        }
        
        observation = dataTask?.progress.observe(\.fractionCompleted) { [weak self] observationProgress, _ in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                self.progress = observationProgress.fractionCompleted
            }
        }
        
        dataTask?.resume()
    }
}
