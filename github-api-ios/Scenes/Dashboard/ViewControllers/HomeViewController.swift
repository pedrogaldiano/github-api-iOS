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

        var repositoiresCount = 0
        githubRepository.getRepositories()
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { allRepos in self.initializeRepositories(allRepos, repositoriesCount: &repositoiresCount)
                }, onCompleted: {
                    self.createReposityCustomView(self.repositories)
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
                onNext: { allRepos in
                    self.initializeRepositories(allRepos, repositoriesCount: &repositoriesCount)
                }, onCompleted: {
                    self.createReposityCustomView(self.repositories, count: repositoriesCount)
                }).disposed(by: disposeViewBag)
    }

    @IBAction func searchByName(_ sender: UITextField) {
        print(sender.text!)

        for view in repositoriesStackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        githubRepository.getRepositoriesByName(repositoryName: sender.text!)

    }

}
