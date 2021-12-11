//
//  MainViewController.swift
//  github-api-ios
//
//  Created by VICTOR PEREIRA MOURA on 06/12/21.
//

import UIKit
import RxSwift

class HomeViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var searchButton: UIButton!
    @IBOutlet var filterTextField: UITextField!
    @IBOutlet var activityIndicatorView: UIView!
    @IBOutlet var filterCountLabel: UILabel!
    @IBOutlet var filtrosHomeStackView: UIStackView!

    @IBOutlet var repositoriesStackView: UIStackView!
    @IBOutlet var scrollView: UIScrollView!

    var coordinator: DashboardCoordinator?
    var selectedFilters = [UIView]()
    var moreData = false
    var reloadData = false

    let githubRepository = GithubRepository()
    let disposeViewBag = DisposeBag()

    var repositories = [RepositoryHome]()

    var paginationCount = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        githubRepository.getRepositories()
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { (allRepos: Repositories) in
                    allRepos.repositories.forEach {

                        let repositoryHome = RepositoryHome(
                            repositoryName: $0.repositoryName,
                            ownerName: $0.ownerName,
                            stargazersCount: $0.stargazersCount,
                            watchersCount: $0.watchersCount,
                            updatedAt: $0.updatedAt,
                            forksCount: $0.forksCount
                        )
                        self.repositories.append(repositoryHome)
                    }
                }, onCompleted: {
                    for values in (0..<self.repositories.count) {

                        let repositoryView = RepositorioCustomView()

                        repositoryView.imageIcon.image = UIImage(named: "baixo_risco")
                        repositoryView.repositoryName.text = self.repositories[values].repositoryName
                        repositoryView.forksCount.text = String(self.repositories[values].forksCount)
                        repositoryView.stargazingCount.text = String(self.repositories[values].stargazersCount)
                        repositoryView.followersCount.text = String(self.repositories[values].watchersCount)

                        if  self.repositories[values].getLastUpdatedDay() == 0 {
                            repositoryView.lastCommitDataInDays.text = "Today"
                        } else {
                            repositoryView.lastCommitDataInDays.text = String(
                                self.repositories[values].getLastUpdatedDay())
                        }

                        repositoryView.ownerName = self.repositories[values].ownerName

                        if values.isMultiple(of: 2) {
                            self.invertBackgroundRepository(repositoryView)
                        }

                        repositoryView.translatesAutoresizingMaskIntoConstraints = false
                        self.repositoriesStackView.addArrangedSubview(repositoryView)

                        NSLayoutConstraint.activate([
                            repositoryView.heightAnchor.constraint(equalToConstant: 155),
                            repositoryView.widthAnchor.constraint(equalTo: self.repositoriesStackView.widthAnchor)
                        ])
                        repositoryView.addTarget(self, action: #selector(self.goToDetails), for: .touchUpInside)
                    }
                }).disposed(by: disposeViewBag)

        activityIndicatorView.isHidden = true

        if let buttonFilters = coordinator?.filters {
            filterCountLabel.text = String(buttonFilters.count)
            buttonFilters.forEach {
                $0.addTarget(self, action: #selector(removeFilter), for: .touchUpInside)

                filtrosHomeStackView.addArrangedSubview($0)
                filtrosHomeStackView.setCustomSpacing(8, after: $0)
            }
        }

        filterTextField.delegate = self
        scrollView.delegate = self

    }

    @IBAction func goToFilter(_ sender: Any) {
        coordinator?.filtro()
    }

    @objc func goToDetails(_ sender: RepositorioCustomView) {
        coordinator?.details(sender)
    }

    @IBAction func focusFilterTextField(_ sender: Any) {
        filterTextField.becomeFirstResponder()
    }

    @IBAction func clearFilters(_ sender: Any) {
        coordinator?.filters.removeAll()
        filtrosHomeStackView.subviews.forEach {$0.removeFromSuperview()}
        filterCountLabel.text = "0"
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.height {
            if !moreData {
                getMoreRepositories()
            }
        } else if offsetY < 0 {
            if !reloadData {
                refreshData()
            }
        }
    }

    func refreshData() {
        reloadData = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.reloadData = false

        })
    }

    func getMoreRepositories() {
        moreData = true
        paginationCount += 1
        var repositoriesCount = 0

        githubRepository.getRepositories(page: paginationCount)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { (allRepos: Repositories) in
                    repositoriesCount = allRepos.repositories.count
                    allRepos.repositories.forEach {

                        let repositoryHome = RepositoryHome(
                            repositoryName: $0.repositoryName,
                            ownerName: $0.ownerName,
                            stargazersCount: $0.stargazersCount,
                            watchersCount: $0.watchersCount,
                            updatedAt: $0.updatedAt,
                            forksCount: $0.forksCount
                        )

                        self.repositories.append(repositoryHome)

                    }
                }, onCompleted: {
                    for values in (self.repositories.count - repositoriesCount..<self.repositories.count) {

                        let repositoryView = RepositorioCustomView()

                        repositoryView.imageIcon.image = UIImage(named: "baixo_risco")
                        repositoryView.repositoryName.text = self.repositories[values].repositoryName
                        repositoryView.forksCount.text = String(self.repositories[values].forksCount)
                        repositoryView.stargazingCount.text = String(self.repositories[values].stargazersCount)
                        repositoryView.followersCount.text = String(self.repositories[values].watchersCount)
                        repositoryView.lastCommitDataInDays.text = String(self.repositories[values].getLastUpdatedDay())

                        if values.isMultiple(of: 2) {
                            self.invertBackgroundRepository(repositoryView)
                        }

                        repositoryView.translatesAutoresizingMaskIntoConstraints = false

                        self.repositoriesStackView.addArrangedSubview(repositoryView)

                        NSLayoutConstraint.activate([
                            repositoryView.heightAnchor.constraint(equalToConstant: 155),
                            repositoryView.widthAnchor.constraint(equalTo: self.repositoriesStackView.widthAnchor)
                        ])

                        repositoryView.addTarget(
                            self,
                            action: #selector(self.goToDetails),
                            for: .touchUpInside
                        )
                        self.moreData = false
                    }
                }).disposed(by: disposeViewBag)
    }
}
