//
//  MaleOrFemaleViewController.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class MaleOrFemaleViewController: BaseViewController {
    
    var presenter: MaleOrFemalePresenterProtocol!
    
    private let headerView = OnboardingHeaderViewWithLogo()
    private let maleOrFemaleContentView = MaleOrFemaleContentView()
    
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
        self.maleOrFemaleContentView.setInitialState(sex: self.presenter.getSex())
    }
    
    private func addingViews() {
        self.view.addSubview(self.headerView)
        self.view.addSubview(self.maleOrFemaleContentView)
        self.view.addSubview(self.btnNext)
    }
    
    private func setupConstraints() {
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        self.maleOrFemaleContentView.translatesAutoresizingMaskIntoConstraints = false
        self.btnNext.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: -20),
            self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            self.btnNext.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            self.btnNext.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.btnNext.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            
            self.maleOrFemaleContentView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: 40),
            self.maleOrFemaleContentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.maleOrFemaleContentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            self.maleOrFemaleContentView.bottomAnchor.constraint(equalTo: self.btnNext.topAnchor, constant: -40),
        ])
        
    }
    
    private func updateButtonState() {
        if self.presenter.getSex() != nil {
            self.btnNext.isEnabled = true
        } else {
            self.btnNext.isEnabled = false
        }
    }
    
    private func subscribeClosures() {
        
        self.maleOrFemaleContentView.selectionChangedClosure = { [weak self] newSelection in
            self?.presenter.setSelectedSexToProfileModel(sex: newSelection)
            self?.updateButtonState()
        }
        
        self.btnNext.didTapClosure = { [weak self] in
            guard let sSelf = self else { return }
            sSelf.presenter.btnNextTapped()
        }
    }
    
}

extension MaleOrFemaleViewController: MaleOrFemaleVCProtocol {
    
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
