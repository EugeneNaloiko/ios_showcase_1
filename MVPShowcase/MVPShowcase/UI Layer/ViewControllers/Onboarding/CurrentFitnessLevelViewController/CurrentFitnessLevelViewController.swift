//
//  CurrentFitnessLevelViewController.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class CurrentFitnessLevelViewController: BaseViewController {
    
//    weak var loginRouter: LoginRouterProtocol!
    
    var presenter: CurrentFitnessLevelPresenterProtocol!
    
    private let headerView = OnboardingHeaderViewWithLogo()
    private let contentView = CurrentFitnessLevelContentView()
    
    private let btnNext: BaseButton = {
        let btn = BaseButton(style: .orange)
        btn.setTitle(L.string("CONTINUE_STRING"), for: UIControl.State.normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupNavigationBar()
        self.addingViews()
        self.setupConstraints()
        self.subscribeClosures()
        self.updateButtonState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setupNavigationBar() {
        self.setNavigationBarBackArrowButton()
        if let navTitle = self.presenter.navigationTitle {
            self.setNavigationTitle(title: navTitle)
        }
        
        if self.presenter.isNavigationBarTransparent {
            self.navigationController?.navigationBar.setNavigationBarTransparent()
        }
    }
    
    private func setupUI() {
        self.view.backgroundColor = .tfWhite
        self.btnNext.setTitle(self.presenter.nextButtonTitle, for: UIControl.State.normal)
        if self.presenter.isLogoHidden {
            self.headerView.setLogoHidden()
        }
            
        self.headerView.setData(titleText: self.presenter.titleText,
                                descriptionText: self.presenter.descriptionText)
        self.prefillInitialData()
    }
    
    private func prefillInitialData() {
        self.contentView.setInitialState(finessLevel: self.presenter.getCurrentFitnessLevel())
    }
    
//    private func setupUI() {
//        self.view.backgroundColor = .tfWhite
//        self.headerView.setData(titleText: L.string("WHATS_YOUR_CURRENT_FITNESS_LEVEL"), descriptionText: L.string("WE_WILL_CUSTOMIZE_YOUR_EXPERIENCE_BASED_ON_YOUR_SELECTIONS"))
//        self.contentView.setInitialState(finessLevel: self.userDataModel.profile?.currentFitnessLevel)
//    }
    
    private func addingViews() {
        self.view.addSubview(self.headerView)
        self.view.addSubview(self.contentView)
        self.view.addSubview(self.btnNext)
    }
    
    private func setupConstraints() {
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.btnNext.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: -10),
            self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            self.btnNext.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            self.btnNext.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.btnNext.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            
            self.contentView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: 20),
            self.contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25),
            self.contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25),
            self.contentView.bottomAnchor.constraint(lessThanOrEqualTo: self.btnNext.topAnchor, constant: -40),
        ])
        
    }
    
    private func subscribeClosures() {
        
        self.contentView.selectionChangedClosure = { [weak self] newSelection in
            self?.presenter.setSelectedFitnessLevel(fitnessLevel: newSelection)
            self?.updateButtonState()
        }
        
        self.btnNext.didTapClosure = { [weak self] in
            guard let sSelf = self else { return }
            sSelf.presenter.btnNextTapped()
        }
    }
    
    private func updateButtonState() {
        if self.presenter.getCurrentFitnessLevel() != nil {
            self.btnNext.isEnabled = true
        } else {
            self.btnNext.isEnabled = false
        }
    }
    
}

extension CurrentFitnessLevelViewController: CurrentFitnessLevelVCProtocol {
   
    func startIndicator() {
        self.btnNext.startIndicator()
    }
    
    func stopIndicator() {
        self.btnNext.stopIndicator()
    }
    
    func popVC() {
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            sSelf.navigationController?.popViewController(animated: true)
        }
    }
    
}
