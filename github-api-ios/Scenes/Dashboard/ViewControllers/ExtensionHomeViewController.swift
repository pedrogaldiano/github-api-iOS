import Foundation
import UIKit

extension HomeViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activityIndicatorView.isHidden = false
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        activityIndicatorView.isHidden = false
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        filterTextField.endEditing(true)
        super.touchesBegan(touches, with: event)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        activityIndicatorView.isHidden = true
    }
}

extension HomeViewController {
    @objc func removeFilter(_ sender: UIButton) {
        sender.isSelected = false

        guard let indexButton = coordinator?.filters.firstIndex(of: sender) else {
            return
        }

        coordinator?.filters.remove(at: indexButton)
        guard let countFilters = coordinator?.filters.count else { return }
        filterCountLabel.text = String(countFilters)

        UIView.animate(withDuration: 0.4, delay: 0, options: []) {
            sender.transform = CGAffineTransform(translationX: 0, y: 20)
            sender.alpha = 0
        } completion: { _ in
            sender.removeFromSuperview()
        }
    }

    func invertBackgroundRepository(_ repositoryView: RepositorioCustomView) {
        repositoryView.topView.backgroundColor = .white

        repositoryView.bottomView.backgroundColor = UIColor(
            red: CGFloat(126)/CGFloat(255),
            green: CGFloat(126)/CGFloat(255),
            blue: CGFloat(126)/CGFloat(255),
            alpha: 1
        )

        repositoryView.totalStarsLabel.textColor = .black
        repositoryView.repositoryName.textColor = .black
        repositoryView.stargazingCount.textColor = .black
    }

    func createReposityCustomView(_ repositories: [RepositoryHome], count: Int? = nil) {
        let counter: Int
        if count != nil {
                counter = count!
        } else {
            counter = self.repositories.count
        }

        for values in (0..<counter) {

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
    }

    func initializeRepositories(_ allRepos: Repositories, repositoriesCount: inout Int) {
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
    }
}
