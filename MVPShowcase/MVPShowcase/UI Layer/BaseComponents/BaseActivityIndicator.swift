//
//  BaseActivityIndicator.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

enum ActivityIndicatorSize {
    case small
    case large
}

class BaseActivityIndicator: UIView {
    
    private let viewWithIndicator = UIView()
    private let activityIndicator = UIActivityIndicatorView()
    
    required init(backgroundColor: UIColor, size: ActivityIndicatorSize) {
        super.init(frame: CGRect.zero)
        self.prepareUI(backgroundColor: backgroundColor, size: size)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareUI(backgroundColor: UIColor, size: ActivityIndicatorSize) {
        self.backgroundColor = backgroundColor
        switch size {
        case .small:
            activityIndicator.style = UIActivityIndicatorView.Style.medium
        case .large:
            activityIndicator.style = UIActivityIndicatorView.Style.large
        }
        activityIndicator.color = UIColor.tfWhite
        viewWithIndicator.backgroundColor = backgroundColor
        viewWithIndicator.layer.cornerRadius = 8
    }
    
    func start(onView view: UIView) {
        view.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.pinToView(view: view)
        
        self.addSubview(self.viewWithIndicator)
        self.viewWithIndicator.addSubview(self.activityIndicator)
        
        self.viewWithIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            viewWithIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            viewWithIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            viewWithIndicator.heightAnchor.constraint(equalToConstant: 90),
            viewWithIndicator.widthAnchor.constraint(equalToConstant: 90),
            
            activityIndicator.topAnchor.constraint(equalTo: self.viewWithIndicator.topAnchor, constant: 10),
            activityIndicator.leftAnchor.constraint(equalTo: self.viewWithIndicator.leftAnchor, constant: 10),
            activityIndicator.rightAnchor.constraint(equalTo: self.viewWithIndicator.rightAnchor, constant: -10),
            activityIndicator.bottomAnchor.constraint(equalTo: self.viewWithIndicator.bottomAnchor, constant: -10),
        ])
        
        self.activityIndicator.startAnimating()
    }
    
    func stop(completion: (() -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.viewWithIndicator.removeFromSuperview()
            self?.removeFromSuperview()
            completion?()
        }
    }
    
}
