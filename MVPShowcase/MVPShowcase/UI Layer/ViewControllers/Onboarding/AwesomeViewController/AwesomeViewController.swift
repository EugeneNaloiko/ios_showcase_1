//
//  AwesomeViewController.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class AwesomeViewController: BaseViewController {
    
    weak var loginRouter: LoginRouterProtocol!
    
    private let awesomeContentView: AwesomeContentView = {
        let view = AwesomeContentView()
        view.setData(titleText: L.string("AWESOME"),
                     descriptionText: L.string("THANK_YOU_FOR_COMPLETING_THE_QUESTIONS_NOW_ITS_TIME_TO_WORK"))
        return view
    }()
    
    private let btnNext: BaseButton = {
        let btn = BaseButton(style: .orange)
        btn.setTitle(L.string("COOL_LETS_GO"), for: UIControl.State.normal)
        return btn
    }()
    
    private let userDataModel: UserInfoModel
    
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
    }
    
    private func addingViews() {
        self.view.addSubview(self.awesomeContentView)
        self.view.addSubview(self.btnNext)
    }
    
    private func setupConstraints() {
        self.awesomeContentView.translatesAutoresizingMaskIntoConstraints = false
        self.btnNext.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.btnNext.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            self.btnNext.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.btnNext.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            
            self.awesomeContentView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0),
            self.awesomeContentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            self.awesomeContentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40)
        ])
        
    }
    
    private func subscribeClosures() {
        self.btnNext.didTapClosure = { [weak self] in
            DispatchQueue.main.async { [weak self] in
                guard let sSelf = self else { return }
                sSelf.btnNext.startIndicator()
                StorageDataManager.shared.userDataModel = sSelf.userDataModel
                sSelf.loginRouter.loginRouterDidFinish()
            }
        }
    }
    
}
