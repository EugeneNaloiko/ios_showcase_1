//
//  WorkoutBluredView.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class WorkoutBluredView: UIView {
    
    private var backgroundBlurView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        let effect = UIBlurEffect(style: .dark)
        view.effect = effect
        view.alpha = 0.8
        return view
    }()
    
    private var markView: ButtonForBluredView = {
        let view = ButtonForBluredView()
        view.setImage(imageName: "img_mark_complete")
        return view
    }()
    
    private var moveView: ButtonForBluredView = {
        let view = ButtonForBluredView()
        view.setImage(imageName: "img_move_to")
        return view
    }()
    
    private var seeRelatedVideosView: ButtonForBluredView = {
        let view = ButtonForBluredView()
        view.setImage(imageName: "img_see_related_videos")
        return view
    }()
    
    var markViewTappedClosure: (() -> Void)?
    var moveViewTappedClosure: (() -> Void)?
    var seeRelatedVideosViewTappedClosure: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        self.subscribeClosures()
        self.addingViews()
        self.setupConstraints()
        self.subscribeClosures()
    }
    
    private func subscribeClosures() {
        self.markView.btnTappedClosure = { [weak self] in
            self?.markViewTappedClosure?()
        }
        
        self.moveView.btnTappedClosure = { [weak self] in
            self?.moveViewTappedClosure?()
        }
        
        self.seeRelatedVideosView.btnTappedClosure = { [weak self] in
            self?.seeRelatedVideosViewTappedClosure?()
        }
    }
    
    private func addingViews() {
        self.addSubview(self.backgroundBlurView)
        self.addSubview(self.markView)
        self.addSubview(self.moveView)
        self.addSubview(self.seeRelatedVideosView)
    }
    
    private func setupConstraints() {
        self.backgroundBlurView.pinToView(view: self)
        self.markView.translatesAutoresizingMaskIntoConstraints = false
        self.moveView.translatesAutoresizingMaskIntoConstraints = false
        self.seeRelatedVideosView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            markView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
            markView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 14),
            
            moveView.topAnchor.constraint(equalTo: self.markView.topAnchor),
            moveView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            seeRelatedVideosView.topAnchor.constraint(equalTo: self.markView.topAnchor),
            seeRelatedVideosView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -14),
        ])
    }
    
    func setTitles(markViewTitle: String?, moveViewTitle: String?, seeRelatedVideosViewTitle: String?) {
        self.markView.setTitle(titleText: markViewTitle)
        self.moveView.setTitle(titleText: moveViewTitle)
        self.seeRelatedVideosView.setTitle(titleText: seeRelatedVideosViewTitle)
        
        if markViewTitle == nil {
            self.markView.isHidden = true
        } else {
            self.markView.isHidden = false
        }
        
        if moveViewTitle == nil {
            self.moveView.isHidden = true
        } else {
            self.moveView.isHidden = false
        }
        
    }
    
    func getMoveViewTitle() -> String {
        return self.moveView.getMoveViewTitle()
    }
    
}
