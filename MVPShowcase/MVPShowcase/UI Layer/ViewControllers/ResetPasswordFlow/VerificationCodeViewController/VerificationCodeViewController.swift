//
//  VerificationCodeViewController.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class VerificationCodeViewController: BaseViewController {
    
    var presenter: VerificationCodePresenterProtocol!
    
    private let contentView: VerificationCodeContentView = {
        let view = VerificationCodeContentView()
        return view
    }()
    
    private let btnResend: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(UIColor.tfOrangish, for: .normal)
        btn.titleLabel?.font = UIFont.sfProFont(.semibold, size: 14)
        btn.setTitle(L.string("RESEND_STRING"), for: .normal)
        return btn
    }()
    
    private lazy var didntGetTheCodeView: UIView = {
        let view = UIView()
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor.tfGray
        lbl.font = UIFont.sfProFont(.regular, size: 14)
        lbl.text = L.string("DIDNT_GET_THE_CODE")
        
        view.addSubview(lbl)
        view.addSubview(btnResend)
        
        NSLayoutConstraint.activate([
            lbl.topAnchor.constraint(equalTo: view.topAnchor, constant: 3),
            lbl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lbl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -3),
            
            btnResend.centerYAnchor.constraint(equalTo: lbl.centerYAnchor),
            btnResend.leadingAnchor.constraint(equalTo: lbl.trailingAnchor, constant: 5),
            btnResend.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        return view
    }()
    
    
    private var bottomFieldY: CGFloat?
    private var viewHeight = UIScreen.main.bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.viewDidLoad()
        self.setupUI()
        self.addingViews()
        self.setupConstraints()
        self.subscribeClosures()
        self.addGestureHideKeyboard()
        self.setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: { [weak self] in
            self?.contentView.showKeyboard()
        })
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setupNavigationBar() {
        self.setNavigationBarBackArrowButton()
        if let navTitle = self.presenter.navigationTitle {
            self.setNavigationTitle(title: navTitle)
        }
    }
    
    private func setupUI() {
        extendedLayoutIncludesOpaqueBars = true
        self.view.backgroundColor = .tfWhite
        
        self.contentView.setData(title:  self.presenter.titleText,
                                 subTitle: self.presenter.descriptionText)
    }
    
    private func addingViews() {
        self.view.addSubview(self.contentView)
        self.view.addSubview(self.didntGetTheCodeView)
    }
    
    private func setupConstraints() {
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.didntGetTheCodeView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            self.contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24),
            self.contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24),
            
            didntGetTheCodeView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 25),
            didntGetTheCodeView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
        
    }
    
    private func subscribeClosures() {
        
        self.contentView.codeChangedClosure = { [weak self] code in
            self?.presenter.validateCode(code: code)
        }
        
        self.contentView.btnOpenEmailAppTappedClosure = { [weak self] in
            if let emailUrl = self?.createEmailUrl() {
                UIApplication.shared.open(emailUrl)
            }
        }
        
        //MARK: Keyboard will Show logic
        self.keyboardWillShowClosure = { [weak self] keyboardFrame in
            guard let sSelf = self else { return }
            
            let keyboardOffset: CGFloat = 5
            sSelf.viewHeight = sSelf.view.bounds.height
            guard sSelf.bottomFieldY != nil else { return }
            let bottomFieldYWithOffset = sSelf.bottomFieldY! + keyboardOffset
            
            let keyboardY = sSelf.viewHeight - keyboardFrame.size.height
            let offsetWhenKeyboardAppeared = bottomFieldYWithOffset - keyboardY
            
            if bottomFieldYWithOffset > keyboardY {
                sSelf.view.frame = CGRect(x: 0, y: -offsetWhenKeyboardAppeared, width: sSelf.view.bounds.width, height: sSelf.view.bounds.height)
            }
        }
        
        //MARK: Keyboard will Hide logic
        self.keyboardWillHideClosure = { [weak self] in
            guard let sSelf = self else { return }
            var viewFrameOriginY: CGFloat = 0
            if sSelf.navigationController?.navigationBar.isTranslucent == false {
                viewFrameOriginY = sSelf.navigationController?.navigationBar.frame.maxY ?? 0
            }
            sSelf.view.frame = CGRect(x: 0, y: viewFrameOriginY, width: sSelf.view.bounds.width, height: sSelf.viewHeight)
        }
        
    }
    
    private func createEmailUrl() -> URL? {
        
        let gmailUrl = URL(string: "googlegmail://")
        let outlookUrl = URL(string: "ms-outlook://")
        let yahooMail = URL(string: "ymail://")
        let sparkUrl = URL(string: "readdle-spark://")
        let defaultUrl = URL(string: "message://")
        
        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
        }
        
        return defaultUrl
    }
    
}

extension VerificationCodeViewController: VerificationCodeVCProtocol {
    
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    func cleanupEnteredCode() {
        DispatchQueue.main.async { [weak self] in
            self?.contentView.cleanupEnteredCode()
        }
    }
    
    func popVC() {
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            sSelf.navigationController?.popViewController(animated: true)
        }
    }
    
}

