//
//  PopUpChooseActionViewController.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class PopUpChooseActionViewController: BaseViewController {
    
    private var backgroundBlurView: UIVisualEffectView!
    
    private let contentView = PopUpChooseActionContentView()
    
    private var initialTouchPoint = CGPoint.zero
    private var viewTranslation = CGPoint(x: 0, y: 0)
    
    var didSelectButtonClosure: ((_ buttonTag: Int) -> Void)?
    
    init(dataModel: [WaveDataModel]) {
        super.init(nibName: nil, bundle: nil)
        let effect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: effect)
        self.backgroundBlurView = visualEffectView
        self.backgroundBlurView.alpha = 0.9
        
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
        self.setupButtons(dataModel: dataModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("Was deinit -----> \(String(describing: type(of: self)))")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commonInit()
        self.addSwipeGesture()
    }
    
    private func commonInit() {
        self.addingViews()
        self.setupConstraints()
    }
    
    private func addSwipeGesture() {
        let gestureRecognizer = UIPanGestureRecognizer(target: self,
                                                       action: #selector(panGestureRecognizerHandler(_:)))
        self.contentView.addGestureRecognizer(gestureRecognizer)
    }
    
    private func addingViews() {
        self.view.addSubview(self.backgroundBlurView)
        self.view.addSubview(self.contentView)
    }
    
    private func setupConstraints() {
        backgroundBlurView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundBlurView.pinToView(view: self.view)
        
        NSLayoutConstraint.activate([
            self.contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    
    func setData(titleText: String, descriptionText: String) {
        self.contentView.setData(titleText: titleText, descriptionText: descriptionText)
    }
    
    func setupButtons(dataModel: [WaveDataModel]) {
        var btnsArray: [PopUpChooseButton] = []
        
        for (index, item) in dataModel.enumerated() {
            let btn = PopUpChooseButton()
            btn.tag = index
            btn.setData(titleText: item.waveName, descriptionText: item.excerptClean ?? "")
            
            btn.btnTappedClosure = { [weak self] tag in
                self?.didSelectButtonClosure?(tag)
                self?.dismiss(animated: true, completion: nil)
            }
            
            btnsArray.append(btn)
        }
        
        self.contentView.setupButtons(buttons: btnsArray)
    }
    
    @objc private func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        
        let touchPoint = sender.translation(in: contentView)
        
        switch sender.state {
        case .began:
            initialTouchPoint = touchPoint
        case .changed:
            viewTranslation = sender.translation(in: contentView)
            if viewTranslation.y - initialTouchPoint.y > 0 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.contentView.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
                })
            }
        case .ended, .cancelled:
            if viewTranslation.y < 30 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.contentView.transform = .identity
                })
            } else {
                dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
    }
    
}
