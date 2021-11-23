//
//  UIUtils.swift
//
//  Created by Eugene Naloiko on 17.06.2021.
//

import UIKit

class UIUtils {
    
    static func displayNetworkErrorBanner(btnTryAgainTappedCompletion: (() -> Void)?) {
        DispatchQueue.main.async {
            let titleText = L.string("OOOPS")
            let descriptionText = L.string("IT_SEEMS_SOMETHING_WENT_WRONG_PLEASE_CHECKYOUR_INTERNET_CONNECTION_AND_TRY_AGAIN")
            
            let networkErrorBanner = NetworkErrorWithRetryButtonView()
            networkErrorBanner.setData(titleText: titleText,
                                       descriptionText: descriptionText)
            
            networkErrorBanner.didTapTryAgainClosure = {
                networkErrorBanner.removeFromSuperview()
                btnTryAgainTappedCompletion?()
            }
            
            guard let keyWindow = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return }
            
            keyWindow.addSubview(networkErrorBanner)
            
            networkErrorBanner.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                networkErrorBanner.topAnchor.constraint(equalTo: keyWindow.topAnchor),
                networkErrorBanner.leadingAnchor.constraint(equalTo: keyWindow.leadingAnchor),
                networkErrorBanner.trailingAnchor.constraint(equalTo: keyWindow.trailingAnchor),
                networkErrorBanner.bottomAnchor.constraint(equalTo: keyWindow.bottomAnchor)
            ])
        }
    }
    
    static func displayPopUpWithButtons(on viewController: UIViewController, titleText: String, descriptionText: String, dataModel: [WaveDataModel], btnTappedCompletion: ((_ btnIndex: Int) -> Void)?) {
        DispatchQueue.main.async {
            let vc = PopUpChooseActionViewController(dataModel: dataModel)
            vc.setData(titleText: titleText, descriptionText: descriptionText)
            vc.didSelectButtonClosure = { tag in
                btnTappedCompletion?(tag)
            }
            viewController.present(vc, animated: true, completion: nil)
        }
    }
    
    static func showOkAlert(on viewController: UIViewController, titleText: String, descriptionText: String? = nil, titleForButton: String = L.string("OKAY_STRING"), buttonTintColor: UIColor? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: titleText, message: descriptionText, preferredStyle: .alert)
        
        let buttonAction = UIAlertAction(title: titleForButton, style: UIAlertAction.Style.cancel, handler: handler)
        
        alert.addAction(buttonAction)
        
        if let tint = buttonTintColor {
            buttonAction.setValue(tint, forKey: "titleTextColor")
        } else {
            buttonAction.setValue(UIColor.tfOrangish, forKey: "titleTextColor")
        }
        
        viewController.present(alert, animated: true)
    }
    
    static func presentAlertWithTwoButtonsOn(viewController: UIViewController, title: String?, message: String?, titleForRightButton: String, titleForLeftButton: String, leftButtonTintColor: UIColor? = nil, rightButtonTintColor: UIColor? = nil, rightButtonConfirmAction: ((UIAlertAction) -> Void)?, leftButtonConfirmAction: ((UIAlertAction) -> Void)? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let titleFont = [NSAttributedString.Key.font: UIFont.sfProDisplayFont(.medium, size: 18),
                         NSAttributedString.Key.foregroundColor: UIColor.tfBlack]
        let messageFont = [NSAttributedString.Key.font: UIFont.sfProDisplayFont(.regular, size: 15),
                           NSAttributedString.Key.foregroundColor: UIColor.tfLessDarker]
        
        let titleAttrString = NSMutableAttributedString(string: title ?? "", attributes: titleFont)
        let messageAttrString = NSMutableAttributedString(string: message ?? "", attributes: messageFont)
        
        alertController.setValue(titleAttrString, forKey: "attributedTitle")
        alertController.setValue(messageAttrString, forKey: "attributedMessage")
        
        
        let leftButtonAction = UIAlertAction(title: titleForLeftButton, style: UIAlertAction.Style.cancel, handler: leftButtonConfirmAction)
        let rightButtonAction = UIAlertAction(title: titleForRightButton, style: .default, handler: rightButtonConfirmAction)
        
        
        if let tint = leftButtonTintColor {
            leftButtonAction.setValue(tint, forKey: "titleTextColor")
        } else {
            leftButtonAction.setValue(UIColor.tfOrangish, forKey: "titleTextColor")
        }
        
        if let tint = rightButtonTintColor {
            rightButtonAction.setValue(tint, forKey: "titleTextColor")
        } else {
            rightButtonAction.setValue(UIColor.tfOrangish, forKey: "titleTextColor")
        }
        
        alertController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.tfWhite
        
        alertController.addAction(leftButtonAction)
        alertController.addAction(rightButtonAction)
        alertController.preferredAction = rightButtonAction
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    static func displaySkipTodayPopUp(imageName: String, titleText: String, messageText: String, buttonContinueTitle: String, buttonCancelTitle: String, btnContinueTappedCompletion: (() -> Void)?, btnCancelTappedCompletion: (() -> Void)?) {
        DispatchQueue.main.async {
            let skipTodayPopUp = SkipTodayPopUpViewController(style: .dark)
            
            guard let keyWindow = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return }
            
            // addSubview
            UIView.transition(with: keyWindow, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                keyWindow.addSubview(skipTodayPopUp.view)
            }, completion: nil)
            
            skipTodayPopUp.setData(imageName: imageName,
                                   titleText: titleText,
                                   descriptionText: messageText,
                                   buttonContinueTitle: buttonContinueTitle,
                                   buttonCancelTitle: buttonCancelTitle)
            
            skipTodayPopUp.btnContinueTappedClosure = {
                // removeFromSuperview
                UIView.transition(with: keyWindow, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                    skipTodayPopUp.view.removeFromSuperview()
                }, completion: { _ in
                    btnContinueTappedCompletion?()
                })
            }
            
            skipTodayPopUp.btnCancelTappedClosure = {
                // removeFromSuperview
                UIView.transition(with: keyWindow, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                    skipTodayPopUp.view.removeFromSuperview()
                }, completion: { _ in
                    btnCancelTappedCompletion?()
                })
            }
            
            skipTodayPopUp.view.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                skipTodayPopUp.view.topAnchor.constraint(equalTo: keyWindow.topAnchor),
                skipTodayPopUp.view.leadingAnchor.constraint(equalTo: keyWindow.leadingAnchor),
                skipTodayPopUp.view.trailingAnchor.constraint(equalTo: keyWindow.trailingAnchor),
                skipTodayPopUp.view.bottomAnchor.constraint(equalTo: keyWindow.bottomAnchor)
            ])
        }
    }

}
