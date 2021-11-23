//
//  PopOverMessageViewController.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class PopOverMessageViewController: UIViewController {
    
    let lblMessage: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    init(backgroundColor: UIColor, textColor: UIColor) {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = backgroundColor
        lblMessage.textColor = textColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.lblMessage)
        
        lblMessage.translatesAutoresizingMaskIntoConstraints = false
        
        lblMessage.pinToView(view: self.view, withInsets: UIEdgeInsets(top: 10, left: 15, bottom: 20, right: 15))
        lblMessage.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        
    }
    
}
