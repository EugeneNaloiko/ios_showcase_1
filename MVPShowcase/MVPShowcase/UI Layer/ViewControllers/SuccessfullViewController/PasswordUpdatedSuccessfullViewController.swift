//
//  SuccessfullViewController.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class SuccessfullViewController: BaseViewController {
    
    var presenter: SuccessfullPresenterProtocol!
    
    weak var profileRouter: ProfileRouterProtocol!
    
    private let contentView: SuccessfullContentView = {
        let view = SuccessfullContentView()
        return view
    }()
    
    private let btnNext: BaseButton = {
        let btn = BaseButton(style: .orange)
        return btn
    }()
    
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
        self.btnNext.setTitle(self.presenter.nextButtonTitle, for: UIControl.State.normal)
        contentView.setData(titleText: self.presenter.titleText,
                            descriptionText: self.presenter.descriptionText)
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
            
            self.contentView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0),
            self.contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            self.contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40)
        ])
        
    }
    
    private func subscribeClosures() {
        self.btnNext.didTapClosure = { [weak self] in
            self?.presenter.btnNextTapped()
        }
    }
    
}

extension SuccessfullViewController: SuccessfullVCProtocol {
    
    func startIndicator() {
        self.btnNext.startIndicator()
    }
    
    func stopIndicator() {
        self.btnNext.stopIndicator()
    }
    
    func popToProfileVC() {
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            
            for vc in sSelf.navigationController?.viewControllers ?? [] {
                if vc is ProfileViewController {
                    sSelf.navigationController?.popToViewController(vc, animated: true)
                }
            }
            
        }
    }
    
}
