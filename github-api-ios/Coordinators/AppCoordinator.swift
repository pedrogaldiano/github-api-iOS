import Foundation
import UIKit

class AppCoordinator: Coordinator {
    let window: UIWindow?

    var vc = FiltroViewController()

    var navController: UINavigationController = {
        let nav = UINavigationController()
        nav.pushViewController(HomeViewController(), animated: true)
        nav.setNavigationBarHidden(true, animated: false)
        return nav
    }()

    init(window: UIWindow?) {
        self.window = window

    }

    override func start() {
        guard let window = window else { return }

        home()
        window.rootViewController = navController
        window.makeKeyAndVisible()
    }

    override func finish() { }

    func home() {
        let child = DashboardCoordinator(navigationController: navController)
        child.parentCoordinator = self
        addChildCoordinator(child)
        child.start()
    }
}
