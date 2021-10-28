import UIKit
import MBProgressHUD
import MaterialComponents.MaterialSnackbar
import AsyncDisplayKit

var isAlertPresented: Bool = false

//MARK: - System components
extension UIViewController {
    var tabBarHeight: CGFloat {
        self.tabBarController?.tabBar.frame.height ?? 0
    }
    
    var navigationBarHeight: CGFloat {
        self.navigationController?.navigationBar.frame.height ?? 0
    }
    
    func setupNavigationBarAppearance() {
        if #available(iOS 13.0, *) {
            let barAppearance = UINavigationBarAppearance()
            barAppearance.backgroundColor = .primary
            barAppearance.titleTextAttributes = [.font: UIFont.muliSemiBold20, .foregroundColor: UIColor.white]
            barAppearance.shadowImage = UIImage()
            barAppearance.shadowColor = .clear
            self.navigationController?.navigationBar.standardAppearance = barAppearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = barAppearance
        } else {
            let navigationBarAppereance = UINavigationBar.appearance()
            navigationBarAppereance.tintColor = .white
            navigationBarAppereance.barTintColor = .primary
            navigationBarAppereance.shadowImage = UIImage()
            navigationBarAppereance.titleTextAttributes = [
                .foregroundColor: UIColor.white,
                .font: UIFont.muliSemiBold20
            ]
        }
        
        UINavigationBar.appearance().isTranslucent = false
        
        let barButtonItemAppearance = UIBarButtonItem.appearance()
        barButtonItemAppearance.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        barButtonItemAppearance.tintColor = .white
    }
}

//MARK: - Alerts
extension UIViewController {    
    func showErrorAlert(message: String, completion: (() -> ())? = nil) {
        if isAlertPresented { return }
        let alert = UIAlertController(title: "Error".localized(), message: message.localized(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok".localized(), style: .default, handler: { (action) in
            completion?()
            isAlertPresented = false
        }))
        self.present(alert, animated: true, completion: nil)
        isAlertPresented = true
    }
    
    func showChooseAlert(title: String, message: String, cancel: String, option: String, completion: @escaping () -> (), cancelCompletion: (() -> ())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: cancel, style: .cancel, handler: { (action) in
            cancelCompletion?()
        }))
        alert.addAction(UIAlertAction(title: option, style: .default, handler: { (action) in
            completion()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showActionSheet(with title: String? = nil, message: String? = nil, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel".localized(), style: .cancel)
        
        alert.addAction(cancel)
        for action in actions {
            alert.addAction(action)
        }
        
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - Loader
extension UIViewController {
    func showActivityLoader() {
        let loader = MBProgressHUD.showAdded(to: self.view, animated: true)
        loader.animationType = .fade
        loader.mode = MBProgressHUDMode.indeterminate
        loader.backgroundColor = .clear
        loader.contentColor = .primary
        loader.tintColor = .primary
    }

    func removeActivityLoader() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
}

//MARK: - Snackbar
extension UIViewController {
    func showSnackbar(_ text: String, _ completion: (() -> Void)? = nil) {
        let message = MDCSnackbarMessage()
        message.attributedText = NSAttributedString(text, color: .white, font: .muliRegular15)
        message.completionHandler = { _ in completion?() }
        message.duration = 2

        let manager = MDCSnackbarManager()
        manager.setBottomOffset(20)
        manager.show(message)
    }
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
