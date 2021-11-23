//
//  EmailWasSentViewController.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class EmailWasSentViewController: BaseViewController {
    
    weak var loginRouter: LoginRouterProtocol!
    
    private let contentView: EmailWasSentContentView = {
        let view = EmailWasSentContentView()
        view.setData(titleText: L.string("WE_SENT_YOU_A_MAIL"),
                     descriptionText: L.string("AN_EMAIL_HAS_BEEN_SUCCESSFULY_SENT_TO_YOUR_EMAIL_ADDRESS"))
        return view
    }()
    
    private let btnNext: BaseButton = {
        let btn = BaseButton(style: .orange)
        btn.setTitle(L.string("COOL_LETS_GO"), for: UIControl.State.normal)
        btn.isHidden = true
        return btn
    }()
    
    init(loginRouter: LoginRouterProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.loginRouter = loginRouter
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.addingViews()
        self.setupConstraints()
        self.subscribeClosures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func setupUI() {
        self.view.backgroundColor = .tfWhite
    }
    
    private func addingViews() {
        self.view.addSubview(self.contentView)
        self.view.addSubview(self.btnNext)
    }
    
    private func setupConstraints() {
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.btnNext.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            self.btnNext.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            self.btnNext.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.btnNext.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            
            self.contentView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            self.contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            self.contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40)
        ])
        
    }
    
    private func subscribeClosures() {
        self.contentView.btnEmailTappedClosure = { [weak self] in
            if let emailUrl = self?.createEmailUrl() {
                UIApplication.shared.open(emailUrl)
            }
        }
        
//        self.btnNext.didTapClosure = { [weak self] in
//            
//        }
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
