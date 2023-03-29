//
//  GithubReposTests.swift
//  GithubExplorerTests
//
//  Created by Bogdan Chornobryvets on 25.03.2023.
//

import XCTest
@testable import GithubExplorer
@testable import Alamofire

final class GithubReposTests: XCTestCase {

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }
    
    func testRemoteGithubReposClient() async throws {
        //given
        let client = RemoteGithubReposClient()
        let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: Date())
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .gmt
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        //when
        let date = try XCTUnwrap(twoDaysAgo)
        let repos = try await client.fetch(after: date)
        let reposDates: [Date] = repos.compactMap {
            dateFormatter.date(from: $0.createdAt)
        }
        
        //then
        XCTAssert(repos.count > 0)
        XCTAssertEqual(reposDates.count, repos.count)
        XCTAssert(reposDates.allSatisfy {
            let reposComponents = Calendar.current.dateComponents([.year, .month, .day], from: $0)
            let targetComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
            guard let rYear = reposComponents.year, let rMonth = reposComponents.month, let rDay = reposComponents.day,
                  let tYear = targetComponents.year, let tMonth = targetComponents.month, let tDay = targetComponents.day else { return false }
            
            return rYear >= tYear && rMonth >= tMonth && rDay >= tDay
        }, "Fetched repos contain created before the target date")
    }
    
    func testGithubResponseParser() throws {
        //given
        let parser = GithubResponseParser()
        let header = """
<https://api.github.com/search/repositories?q=created%3A2023-02-24&sort=stars&order=desc&page=1>; rel="prev", <https://api.github.com/search/repositories?q=created%3A2023-02-24&sort=stars&order=desc&page=3>; rel="next", <https://api.github.com/search/repositories?q=created%3A2023-02-24&sort=stars&order=desc&page=34>; rel="last", <https://api.github.com/search/repositories?q=created%3A2023-02-24&sort=stars&order=desc&page=1>; rel="first"
"""
        let sampleDirector = GithubResponseDirector(prevURL: "https://api.github.com/search/repositories?q=created%3A2023-02-24&sort=stars&order=desc&page=1",
                                                    nextURL: "https://api.github.com/search/repositories?q=created%3A2023-02-24&sort=stars&order=desc&page=3",
                                                    lastURL: "https://api.github.com/search/repositories?q=created%3A2023-02-24&sort=stars&order=desc&page=34",
                                                    firstURL: "https://api.github.com/search/repositories?q=created%3A2023-02-24&sort=stars&order=desc&page=1")
        
        //when
        let director = parser.parse(header: header)
        
        //then
        XCTAssertEqual(director.prevURL, sampleDirector.prevURL)
        XCTAssertEqual(director.nextURL, sampleDirector.nextURL)
        XCTAssertEqual(director.lastURL, sampleDirector.lastURL)
        XCTAssertEqual(director.firstURL, sampleDirector.firstURL)
        
    }
    
}
