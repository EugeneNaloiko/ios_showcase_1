//
//  HomePageTodayRecoveryDayCell.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class HomePageTodayRecoveryDayCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: type(of: self))
    
    private let recoveryDayView = HomePageRecoveryDayView()
    
    var btnNextTappedClosure: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commonInit()
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
        self.contentView.backgroundColor = .tfWhite
    }
    
    private func addingViews() {
        self.contentView.addSubview(self.recoveryDayView)
    }
    
    private func setupConstraints() {
        self.recoveryDayView.translatesAutoresizingMaskIntoConstraints = false

        self.recoveryDayView.pinToView(view: self.contentView, withInsets: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0))
        
    }
    
    private func subscribeClosures() {
        self.recoveryDayView.btnNextTappedClosure = { [weak self] in
            self?.btnNextTappedClosure?()
        }
    }
    
}

