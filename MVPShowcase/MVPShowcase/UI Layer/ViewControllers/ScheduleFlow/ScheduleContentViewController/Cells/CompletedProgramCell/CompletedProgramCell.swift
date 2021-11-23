//
//  CompletedProgramCell.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class CompletedProgramCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: type(of: self))
    
    private let imageCornerRadiusValue: CGFloat = 8
    
    private lazy var mainImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.layer.masksToBounds = true
        img.layer.cornerRadius = imageCornerRadiusValue
        return img
    }()
    
    private var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.textColor = UIColor.tfBlack
        lbl.font = UIFont.sfProFont(.semibold, size: 14)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    private let lblDescription: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.textColor = UIColor.tfGray
        lbl.font = UIFont.sfProDisplayFont(.regular, size: 14)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    private var completedCheckMarkImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.image = UIImage(named: "img_completed_checkmark")
        return img
    }()
    
    private var btnMenuDots: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "img_menu_dots"), for: .normal)
        return  btn
    }()
    
    private let activityIndicator = BaseActivityIndicator(backgroundColor: UIColor.tfBeige, size: .large)
    
    private lazy var bluredMenuView: WorkoutBluredView = {
        let view = WorkoutBluredView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = imageCornerRadiusValue
        view.isHidden = true
        return view
    }()
    
    var selectedDate: Date!
    
    var markAsIncompleteTappedClosure: (() -> Void)?
    var seeRelatedVideosViewTappedClosure: (() -> Void)?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.mainImageView.image = nil
    }
    
    private func commonInit() {
        self.addingViews()
        self.setupConstraints()
        self.contentView.backgroundColor = UIColor.tfWhite
        self.btnMenuDots.addTarget(self, action: #selector(self.btnMenuDotsTapped(_:)), for: UIControl.Event.touchUpInside)
        self.subscribeClosures()
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideOverlayBluredView), name: NSNotification.Name.hideWorkoutOverlayView, object: nil)
    }
    
    private func addingViews() {
        self.mainImageView.addSubview(self.completedCheckMarkImageView)
        
        self.contentView.addSubview(self.mainImageView)
        self.contentView.addSubview(self.lblTitle)
        self.contentView.addSubview(self.lblDescription)
        self.contentView.addSubview(self.btnMenuDots)
        
        self.contentView.addSubview(self.bluredMenuView)
    }
    
    private func setupConstraints() {
        self.mainImageView.translatesAutoresizingMaskIntoConstraints = false
        self.lblTitle.translatesAutoresizingMaskIntoConstraints = false
        self.lblDescription.translatesAutoresizingMaskIntoConstraints = false
        self.completedCheckMarkImageView.translatesAutoresizingMaskIntoConstraints = false
        self.btnMenuDots.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            self.mainImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 2),
            self.mainImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            self.mainImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            self.mainImageView.heightAnchor.constraint(equalToConstant: 176),
            
            self.lblTitle.topAnchor.constraint(equalTo: self.mainImageView.bottomAnchor, constant: 10),
            self.lblTitle.leadingAnchor.constraint(equalTo: self.mainImageView.leadingAnchor, constant: 0),
            self.lblTitle.trailingAnchor.constraint(equalTo: self.mainImageView.trailingAnchor, constant: 0),
            
            self.lblDescription.topAnchor.constraint(equalTo: self.lblTitle.bottomAnchor, constant: 5),
            self.lblDescription.leadingAnchor.constraint(equalTo: self.lblTitle.leadingAnchor, constant: 0),
            self.lblDescription.trailingAnchor.constraint(equalTo: self.lblTitle.trailingAnchor, constant: 0),
            self.lblDescription.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            
            self.completedCheckMarkImageView.topAnchor.constraint(equalTo: self.mainImageView.topAnchor, constant: 16),
            self.completedCheckMarkImageView.trailingAnchor.constraint(equalTo: self.mainImageView.trailingAnchor, constant: -16),
            self.completedCheckMarkImageView.heightAnchor.constraint(equalToConstant: 24),
            self.completedCheckMarkImageView.widthAnchor.constraint(equalToConstant: 24),
            
            self.btnMenuDots.bottomAnchor.constraint(equalTo: self.mainImageView.bottomAnchor, constant: -2),
            self.btnMenuDots.trailingAnchor.constraint(equalTo: self.mainImageView.trailingAnchor, constant: -14),
            self.btnMenuDots.heightAnchor.constraint(equalToConstant: 24),
            self.btnMenuDots.widthAnchor.constraint(equalToConstant: 24)
        ])
        
        self.bluredMenuView.pinToView(view: self.mainImageView)
    }
    
    func setData(dataModel: CompletedWorkoutsSectionDataModel, selectedDate: Date) {
        self.selectedDate = selectedDate
        self.lblTitle.text = dataModel.program?.programDetails?.title
        let descriptionText = "\(dataModel.workout?.cycleName ?? "") • \(dataModel.workout?.dayInProgram ?? "")\n\(dataModel.workout?.workoutName ?? "")"
        
        self.lblDescription.text = descriptionText
        
        self.bluredMenuView.setTitles(markViewTitle: L.string("MARK_AS_INCOMPLETE"),
                                      moveViewTitle: nil,
                                      seeRelatedVideosViewTitle: L.string("SEE_RELATED_VIDEOS"))
        
        loadImageIfPossible(imageUrl: dataModel.workout?.thumbnail)
    }
    
    @objc private func hideOverlayBluredView() {
        self.bluredMenuView.isHidden = true
    }
    
    private func loadImageIfPossible(imageUrl: String?) {
        //MARK: set image
        self.mainImageView.image = nil
        self.mainImageView.sd_setImage(with: URL(string: imageUrl ?? ""), completed: { [weak self] _,_,_,_  in
            self?.activityIndicator.stop()
        })
    }
    
    @objc private func btnMenuDotsTapped(_ sender: UIButton) {
        self.bluredMenuView.isHidden = !self.bluredMenuView.isHidden
    }
    
    private func subscribeClosures() {
        self.bluredMenuView.markViewTappedClosure = { [weak self] in
            self?.bluredMenuView.isHidden = true
            self?.markAsIncompleteTappedClosure?()
        }
        
        self.bluredMenuView.moveViewTappedClosure = { [weak self] in
            self?.bluredMenuView.isHidden = true
        }
        
        self.bluredMenuView.seeRelatedVideosViewTappedClosure = { [weak self] in
            self?.bluredMenuView.isHidden = true
            self?.seeRelatedVideosViewTappedClosure?()
        }
    }
    
}
