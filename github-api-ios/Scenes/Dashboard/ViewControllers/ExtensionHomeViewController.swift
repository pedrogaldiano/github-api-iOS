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
}
