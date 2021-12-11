//
//  GithubAPI.swift
//  github-api-ios
//
//  Created by ARYEL SANDER DOS SANTOS on 08/12/21.
//

import Foundation
import RxSwift

class GithubRepository {
    private let networkService = NetworkService()
    private let baseURLString = "https://api.github.com"

    func getRepositories(_ order: Repositories.OrderBy = .descending, page: Int = 1) -> Observable<Repositories> {
        return networkService.execute(url: URL(string: baseURLString +
       "/search/repositories?q=sort=stars&order=desc&per_page=100&page=\(page)")!)
    }

    func getBranches(ownerName: String, repositoryName: String) -> Observable<[Branch]> {
        let urlString = baseURLString + "/repos/\(ownerName)/\(repositoryName)/branches"
        return networkService.execute(url: URL(string: urlString)!)
    }
    func getCommits(ownerName: String, repositoryName: String) -> Observable<[Commit]> {
        let urlString = baseURLString + "/repos/\(ownerName)/\(repositoryName)/commits"
        return networkService.execute(url: URL(string: urlString)!)
    }
    func getContributors(ownerName: String, repositoryName: String) -> Observable<[Contributor]> {
        let urlString = baseURLString + "/repos/\(ownerName)/\(repositoryName)/contributors"
        return networkService.execute(url: URL(string: urlString)!)
    }
    func getReleases(ownerName: String, repositoryName: String) -> Observable<[Release]> {
        let urlString = baseURLString + "/repos/\(ownerName)/\(repositoryName)/contributors"
        return networkService.execute(url: URL(string: urlString)!)
    }
}
