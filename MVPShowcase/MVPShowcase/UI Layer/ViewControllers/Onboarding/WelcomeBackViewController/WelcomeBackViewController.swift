//
//  WelcomeBackViewController.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class WelcomeBackViewController: BaseViewController {
    
    weak var loginRouter: LoginRouterProtocol!
    
    private let headerView = OnboardingHeaderViewWithLogo()
    private let welcomeBackContentView = WelcomeBackContentView()
    private let userDataModel: UserInfoModel
    
    private let btnNext: BaseButton = {
        let btn = BaseButton(style: .orange)
        btn.setTitle(L.string("COOL_LETS_GO"), for: UIControl.State.normal)
        return btn
    }()
    
    init(loginRouter: LoginRouterProtocol, userDataModel: UserInfoModel) {
        self.userDataModel = userDataModel
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
        var titleText = L.string("WELCOME_BACK")
        if let firstName = self.userDataModel.profile?.firstName {
            titleText = "\(L.string("WELCOME_BACK")), \n\(firstName)"
        }
        self.welcomeBackContentView.setData(imageName: "img_welcome_back", titleText: titleText, descriptionText: L.string("THANK_YOU_FOR_JOINING_OUR_MOBILE_EXPERIENCE"))
    }
    
    private func addingViews() {
        self.view.addSubview(self.headerView)
        self.view.addSubview(self.welcomeBackContentView)
        self.view.addSubview(self.btnNext)
    }
    
    private func setupConstraints() {
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        self.welcomeBackContentView.translatesAutoresizingMaskIntoConstraints = false
        self.btnNext.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30),
            self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            self.btnNext.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            self.btnNext.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.btnNext.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            
            self.welcomeBackContentView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: 0),
            self.welcomeBackContentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.welcomeBackContentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            self.welcomeBackContentView.bottomAnchor.constraint(lessThanOrEqualTo: self.btnNext.topAnchor, constant: -40),
        ])
        
    }
    
    private func subscribeClosures() {
        self.btnNext.didTapClosure = { [weak self] in
            guard let sSelf = self else { return }
            sSelf.loginRouter.showChooseCountryScreen(userDataModel: sSelf.userDataModel)
        }
    }
    
}
