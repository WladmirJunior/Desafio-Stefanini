//
//  GallerySearchService.swift
//  Desafio Stefanini
//
//  Created by Wladmir Edmar Silva Junior on 17/04/21.
//

import Foundation
import UIKit

class GallerySearchService {

    public enum Constants {
        static let authUrl = "https://api.imgur.com/oauth2/token"
        static let serachGalleryBaseUrl = "https://api.imgur.com/3/gallery/search"

        static let contentTypeHeader = "Content-Type"
        static let authorizationHeader = "Authorization"

        static let contentTypeValue = "application/json"
        static let authorizationValue = "Client-ID 0e28aa10e09ced4"
    }

    public func authenticate() {
        guard let url = URL(string: Constants.authUrl) else {
            return
        }

        let parameters = [
            "refresh_token": "b1d03b2a376fd4d1024b38530709c15323bfa61a",
            "client_id": "0e28aa10e09ced4",
            "client_secret": "b811cfa71bdeda66abc1ac16cb56d8caeb7a27d4",
            "grant_type": "refresh_token"
        ]

        guard let jsonToData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) else {
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = jsonToData
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            print(String(data: data, encoding: .utf8)!)
        }

        task.resume()
    }

    public func getImages(search: String, page: Int, completion: @escaping (GalleryResponse) -> Void) {
        guard let url = URL(string: "\(Constants.serachGalleryBaseUrl)/\(page)?q=\(search)&q_size_px=small&q_type=jpg") else {
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.addValue(Constants.contentTypeValue, forHTTPHeaderField: Constants.contentTypeHeader)
        urlRequest.addValue(Constants.authorizationValue, forHTTPHeaderField: Constants.authorizationHeader)

        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            guard let galeryResponse = try? JSONDecoder().decode(GalleryResponse.self, from: data) else {
                return
            }
            completion(galeryResponse)
        }
        task.resume()
    }

    public func downloadImage(with link: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: link) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            completion(UIImage(data: data))
        }
        task.resume()
    }
}
