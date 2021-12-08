//
//  HomeViewController.swift
//  github-api-ios
//
//  Created by VICTOR FELIPPE MAGDESIAN on 07/12/21.
//

import UIKit

class HomeViewController: UIViewController {

    var coordinator: DashboardCoordinator?

    lazy var botaoTeste: UIButton = {
        let btn = UIButton(frame: CGRect(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2, width: 100, height: 100))
        btn.setTitle("GOOOOOOO", for: .normal)
        btn.backgroundColor = .black
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(onTap), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(botaoTeste)
        view.backgroundColor = .systemRed
    }

    @objc func onTap(_ sender: UIButton) {
        coordinator?.filtro()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
