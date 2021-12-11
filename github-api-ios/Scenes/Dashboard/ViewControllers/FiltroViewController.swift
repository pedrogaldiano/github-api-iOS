//
//  FiltroViewController.swift
//  github-api-ios
//
//  Created by VICTOR FELIPPE MAGDESIAN on 06/12/21.
//

import UIKit

class FiltroViewController: UIViewController {

    var coordinator: DashboardCoordinator?

    @IBOutlet var starFilter: UIButton!
    @IBOutlet var followFilter: UIButton!
    @IBOutlet var dateFilter: UIButton!
    @IBOutlet var ascendingFilter: UIButton!
    @IBOutlet var descendingFilter: UIButton!

    @IBOutlet var applyFilter: UIButton!

    var selectedButtons: [UIButton] = []

    override func viewDidLoad() {

        super.viewDidLoad()

        let buttons: [UIButton] = [
            starFilter,
            followFilter,
            dateFilter,
            ascendingFilter,
            descendingFilter
        ]

        applyFilter.layer.cornerRadius = 4

        for button in buttons {
            setUpButton(button)
            selectButtonIfOptionSelected(button)
        }
    }

    @IBAction func goToHome(_ sender: Any) {
        self.coordinator?.start()
    }

    @IBAction func limparFiltroButton(_ sender: UIButton) {
        if selectedButtons.isEmpty {
            return
        }

        selectedButtons.forEach {
            $0.backgroundColor = .none
            $0.setImage(nil, for: .normal)
            $0.setTitleColor(.black, for: .selected)
            $0.isSelected = false
            selectedButtons.remove(at: selectedButtons.firstIndex(of: $0)!)
        }
    }

    @objc func tappedButton(_ sender: UIButton) {
        let titleLabel = sender.titleLabel?.text

        let existingAscendingButton = selectedButtons.first(
            where: { button in button.titleLabel?.text == "CRESCENTE" }
        )

        let existingDescendingButton = selectedButtons.first(
            where: { button in button.titleLabel?.text == "DECRESCENTE" }
        )

        if titleLabel == "DECRESCENTE" && existingAscendingButton != nil {
            setButtonUnSelected(existingAscendingButton!)
        } else if titleLabel == "CRESCENTE" && existingDescendingButton != nil {
            setButtonUnSelected(existingDescendingButton!)
        }

        if sender.isSelected {
            setButtonUnSelected(sender)
        } else {
            setButtonSelected(sender)
        }
    }

    @IBAction func applyButton(_ sender: UIButton) {

        selectedButtons.forEach {
            $0.backgroundColor = .none
            $0.setImage(UIImage(named: "Fechar-Black"), for: .normal)
            $0.semanticContentAttribute = .forceRightToLeft
            $0.setTitleColor(.black, for: .selected)
            $0.isSelected = false
            $0.removeTarget(self, action: nil, for: .touchUpInside)
        }
        coordinator?.filters.removeAll()
        coordinator?.storeFilters(filters: selectedButtons)
        coordinator?.sendBackToHome()
    }
}
