//
//  NetworkErrorWithRetryButtonView.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class NetworkErrorWithRetryButtonView: UIView {
    
    private let contentView = NetworkErrorContentView()
    
    private let btnNext: BaseButton = {
        let btn = BaseButton(style: .orange)
        btn.setTitle(L.string("TRY_AGAIN"), for: UIControl.State.normal)
        return btn
    }()
    
    var didTapTryAgainClosure: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        self.prepareUI()
        self.addingViews()
        self.setupConstraints()
        self.subscribeClosures()
    }
    
    private func prepareUI() {
        self.backgroundColor = UIColor.tfWhite
    }
    
    private func addingViews() {
        self.addSubview(contentView)
        self.addSubview(btnNext)
    }
    
    private func setupConstraints() {
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.btnNext.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.btnNext.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            self.btnNext.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.btnNext.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            self.contentView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.contentView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -20),
            self.contentView.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 40),
            
        ])
    }
    
    private func subscribeClosures() {
        self.btnNext.didTapClosure = { [weak self] in
            self?.didTapTryAgainClosure?()
        }
    }
    
    func setData(titleText: String, descriptionText: String) {
        self.contentView.setData(titleText: titleText, descriptionText: descriptionText)
    }
    
}
