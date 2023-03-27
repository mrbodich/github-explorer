//
//  RemoteGithubReposClient.swift
//  GithubExplorer
//
//  Created by Bogdan Chornobryvets on 27.03.2023.
//

import Foundation
import Alamofire

class RemoteGithubReposClient: GithubReposClient {
    private let sortBy: String = "stars"
    private let orderBy: String = "desc"
    let headers = HTTPHeaders([
        "Accept" : "application/json"
    ])
    
    private var lastDirector: GithubResponseDirector? = nil
    
    func fetch(after date: Date) async throws -> [GithubRepoModel] {
        lastDirector = nil
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        
        let url = "https://api.github.com/search/repositories"
        let params = [
            "q": "created:>\(dateString)",
            "sort": sortBy,
            "order": orderBy
        ]
        return try await fetch(from: url, params: params)
    }
    
    func fetchNext() async throws -> [GithubRepoModel]? {
        guard let nextUrl = lastDirector?.nextURL else { return nil }
        return try await fetch(from: nextUrl)
    }
    
    private func fetch(from url: String, params: Parameters? = nil) async throws -> [GithubRepoModel] {
        let request = AF.request(url,
                                 method: .get,
                                 parameters: params,
                                 encoding: URLEncoding.default,
                                 headers: headers)
        
        let response = await request.serializingDecodable(GithubReposPage.self, decoder: SnakeCaseJSONDecoder()).response
        guard let data = response.data,
                let linkHeader = response.response?.value(forHTTPHeaderField: "Link") else { throw URLError(.badServerResponse) }
        
        lastDirector = GithubResponseParser().parse(header: linkHeader)
        return try SnakeCaseJSONDecoder().decode(GithubReposPage.self, from: data).items
    }
}
