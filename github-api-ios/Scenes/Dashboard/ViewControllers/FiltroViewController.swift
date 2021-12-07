//
//  FiltroViewController.swift
//  github-api-ios
//
//  Created by VICTOR FELIPPE MAGDESIAN on 06/12/21.
//

import UIKit

class FiltroViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        let buttons: [UIButton] = [
//            starFilter,
//            followFilter,
//            dateFilter,
//            ascendingFilter,
//            descendingFilter
//        ]

//        starFilter.addTarget(
//            self,
//            action: #selector(tappedButton),
//            for: .touchUpInside
//        )

//        for button in buttons {
//            button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
//
//            button.addTarget(
//                self,
//                action: #selector(tappedButton),
//                for: .touchUpInside
//            )
//
//            button.isHighlighted = false
//        }

    }

    @IBAction func goToMainButton(_ sender: UIButton) {
        print("Aperto o X")
    }

    @IBAction func limparFiltroButton(_ sender: UIButton) {
        print("Aperto o LIMPAR")
    }

    @objc func tappedButton(_ sender: UIButton) {
        if sender.backgroundColor == .none {
            sender.backgroundColor = .black
            sender.layer.cornerRadius = 4
            sender.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
            sender.setTitleColor(.white, for: .normal)
            return
        }

        sender.backgroundColor = .none
        sender.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        sender.titleLabel?.textColor = .black
        sender.setTitleColor(.black, for: .normal)
    }

}
