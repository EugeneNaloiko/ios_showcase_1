//
//  BaseViewController.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

class BaseViewController: UIViewController {
    
    var keyboardWillShowClosure: ((_ keyboardFrame: CGRect) -> Void)?
    var keyboardWillHideClosure: (() -> Void)?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        
        #if DEBUG
        print("Was deinit -----> \(String(describing: type(of: self)))")
        #endif
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.keyboardObserversSubscribe()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: Set custom back button with arrow
    func setNavigationBarBackArrowButton(withTintColor: UIColor? = nil, action: Selector? = nil) {
        var image: UIImage?
        if let tint = withTintColor {
            image = UIImage(named: "img_back_arrow_small")?.withRenderingMode(.alwaysTemplate).tint(with: tint)
        } else {
            image = UIImage(named: "img_back_arrow_small")?.withRenderingMode(.alwaysOriginal)
        }
        
        var btnBack: UIBarButtonItem?
        
        if let customAction = action {
            btnBack = UIBarButtonItem(image: image,
                                      style: .plain,
                                      target: self,
                                      action: customAction)
        } else {
            btnBack = UIBarButtonItem(image: image,
                                          style: .plain,
                                          target: self,
                                          action: #selector(actionBack(_:)))
        }
        
        
//        btnBack.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = btnBack
    }
    
    @objc private func actionBack(_ sender: UIBarButtonItem) {
//        self.navigationController?.popViewController(animated: true)
        self.motionDismissViewController()
    }
    
    func setNavigationTitle(title: String, color: UIColor? = nil) {
        let lbl = UILabel()
        lbl.text = title
        lbl.font = UIFont.sfProFont(.bold, size: 16)
        if let color = color {
            lbl.textColor = color
        } else {
            lbl.textColor = UIColor.tfBlack
        }
        lbl.sizeToFit()
        navigationItem.titleView = lbl
    }
    
}

//MARK: Keyboard notifications
extension BaseViewController {
    
    func keyboardObserversSubscribe() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func addGestureHideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc fileprivate func dismissKeyboard(_ sender: UIViewController) {
        view.endEditing(true)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return}
        let keyboardFrame = keyboardSize.cgRectValue
        
        let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve: UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        if keyboardFrame.origin.y >= UIScreen.main.bounds.size.height {
            //MARK: Keyboard will hide
            self.keyboardWillHideClosure?()
        } else {
            //MARK: Keyboard will show with height keyboardFrame?.size.height
            self.keyboardWillShowClosure?(keyboardFrame)
        }
        
        UIView.animate(withDuration: duration,
                       delay: TimeInterval(0),
                       options: animationCurve,
                       animations: {
                        self.view.layoutIfNeeded()
        },
                       completion: nil)
    }
    
}
