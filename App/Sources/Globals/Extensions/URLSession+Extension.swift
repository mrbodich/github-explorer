//
//  URLSession+Extension.swift
//  GithubExplorer
//
//  Created by Bogdan Chornobryvets on 26.03.2023.
//

import Foundation

extension URLSession {
    
    //The Sendable analog of data(for:delegate:) method, that allows to use it in isolated context
    @Sendable
    func isolatedData(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        let result = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<(Data, URLResponse), any Error>) in
            let request = self.dataTask(with: urlRequest) { data, response, error in
                switch (data, response, error) {
                case let (.some(data), .some(response), _): continuation.resume(returning: (data, response))
                case let (_, _, .some(error)): continuation.resume(throwing: error)
                default: continuation.resume(throwing: URLError(.badServerResponse))
                }
            }
            request.resume()
        }
        return result
    }
}
