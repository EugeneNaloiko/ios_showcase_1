//
//  HomeScreenWelcomeHeader.swift
//
//  Created by Eugene Naloiko.
//

import UIKit
 
class HomeScreenWelcomeHeader: UITableViewHeaderFooterView {
    
    static let reuseIdentifier = String(describing: type(of: self))
    
    private let welcomeView = HomeVCWelcomeView()
    
    var btnNextTappedClosure: (() -> Void)?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.prepareUI()
        self.addingViews()
        self.setupConstraints()
        self.subscribeClosures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareUI() {
        self.contentView.backgroundColor = .tfWhite
    }
    
    private func addingViews() {
        self.contentView.addSubview(self.welcomeView)
    }
    
    private func setupConstraints() {
        self.welcomeView.translatesAutoresizingMaskIntoConstraints = false

        self.welcomeView.pinToView(view: self.contentView, withInsets: UIEdgeInsets(top: 30, left: 0, bottom: 30, right: 0))
        
    }
    
    private func subscribeClosures() {
        self.welcomeView.btnNextTappedClosure = { [weak self] in
            self?.btnNextTappedClosure?()
        }
    }
    
}
