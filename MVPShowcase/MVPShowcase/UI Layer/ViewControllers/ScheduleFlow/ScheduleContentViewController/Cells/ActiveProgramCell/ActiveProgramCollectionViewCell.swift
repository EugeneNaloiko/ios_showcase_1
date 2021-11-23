//
//  ActiveProgramCollectionViewCell.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class ActiveProgramCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "ActiveProgramCollectionViewCell"
    
    private let imageCornerRadiusValue: CGFloat = 8
    
    private lazy var imgView: UIImageView = {
        let img = UIImageView()
        img.layer.masksToBounds = true
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = imageCornerRadiusValue
        img.backgroundColor = UIColor.tfLightGray
        return img
    }()
    
    private var completedCheckMarkImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.image = UIImage(named: "img_completed_checkmark")
        img.isHidden = true
        return img
    }()
    
    private let lblCycle: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.textColor = UIColor.tfBlack
        lbl.font = UIFont.sfProFont(.semibold, size: 14)
        return lbl
    }()
    
    private let lblWorkoutName: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.textColor = UIColor.tfBlack
        lbl.font = UIFont.sfProFont(.semibold, size: 14)
        return lbl
    }()
    
    private let lblDate: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.textColor = UIColor.tfBlack
        lbl.font = UIFont.sfProFont(.semibold, size: 14)
        return lbl
    }()
    
    private var lblRestDay: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = UIColor.tfWhite
        lbl.font = UIFont.sfProFont(.heavy, size: 24)
        lbl.text = L.string("REST_DAY")
        lbl.isHidden = true
        
        return lbl
    }()
    
    private let activityIndicator = BaseActivityIndicator(backgroundColor: UIColor.tfBeige, size: .large)
    
    private let btnAction: UIButton = UIButton()
    
    private var btnMenuDots: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "img_menu_dots"), for: .normal)
        return  btn
    }()
    
    private lazy var bluredMenuView: WorkoutBluredView = {
        let view = WorkoutBluredView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = imageCornerRadiusValue
        view.isHidden = true
        return view
    }()
    
    private var workoutDataModel: WorkoutDataModel!
    
    var selectedDate: Date!
    
    var closureTappedOnBtnAction: (() -> Void)?
    
    var markAsCompleteTappedClosure: ((_ workoutDataModel: WorkoutDataModel) -> Void)?
    
    var seeRelatedVideosViewTappedClosure: (() -> Void)?
    
    var moveToTodayActionClosure: (() -> Void)?
    var moveToTomorrowActionClosure: (() -> Void)?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepareUI()
        self.addingViews()
        self.setupConstraints()
        self.subscribeClosures()
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideOverlayBluredView), name: NSNotification.Name.hideWorkoutOverlayView, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareUI() {
        self.btnAction.addTarget(self, action: #selector(self.tappedOnBtnAction), for: .touchUpInside)
        self.btnMenuDots.addTarget(self, action: #selector(self.btnMenuDotsTapped(_:)), for: UIControl.Event.touchUpInside)
        self.imgView.backgroundColor = .tfBeige
    }
    
    private func addingViews() {
        self.contentView.addSubview(self.imgView)
        self.imgView.addSubview(self.completedCheckMarkImageView)
        self.imgView.addSubview(self.lblRestDay)
        self.contentView.addSubview(self.lblCycle)
        self.contentView.addSubview(self.lblWorkoutName)
        self.contentView.addSubview(self.lblDate)
        self.contentView.addSubview(self.btnAction)
        self.contentView.addSubview(self.btnMenuDots)
        self.contentView.addSubview(self.bluredMenuView)
    }
    
    private func setupConstraints() {
        self.imgView.translatesAutoresizingMaskIntoConstraints = false
        self.completedCheckMarkImageView.translatesAutoresizingMaskIntoConstraints = false
        self.lblRestDay.translatesAutoresizingMaskIntoConstraints = false
        self.lblCycle.translatesAutoresizingMaskIntoConstraints = false
        self.lblWorkoutName.translatesAutoresizingMaskIntoConstraints = false
        self.lblDate.translatesAutoresizingMaskIntoConstraints = false
        self.btnAction.translatesAutoresizingMaskIntoConstraints = false
        self.btnMenuDots.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imgView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            imgView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            imgView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            imgView.widthAnchor.constraint(equalToConstant: 302),
            imgView.heightAnchor.constraint(equalToConstant: 176),
            
            completedCheckMarkImageView.topAnchor.constraint(equalTo: self.imgView.topAnchor, constant: 16),
            completedCheckMarkImageView.trailingAnchor.constraint(equalTo: self.imgView.trailingAnchor, constant: -15),
            completedCheckMarkImageView.heightAnchor.constraint(equalToConstant: 24),
            completedCheckMarkImageView.widthAnchor.constraint(equalToConstant: 24),
            
            lblRestDay.centerXAnchor.constraint(equalTo: self.imgView.centerXAnchor),
            lblRestDay.centerYAnchor.constraint(equalTo: self.imgView.centerYAnchor),
            
            lblCycle.topAnchor.constraint(equalTo: self.imgView.bottomAnchor, constant: 10),
            lblCycle.leadingAnchor.constraint(equalTo: self.imgView.leadingAnchor),
            lblCycle.trailingAnchor.constraint(equalTo: self.imgView.trailingAnchor),
            
            lblWorkoutName.topAnchor.constraint(equalTo: self.lblCycle.bottomAnchor, constant: 10),
            lblWorkoutName.leadingAnchor.constraint(equalTo: self.imgView.leadingAnchor),
            lblWorkoutName.trailingAnchor.constraint(equalTo: self.imgView.trailingAnchor),
            
            lblDate.topAnchor.constraint(equalTo: self.lblWorkoutName.bottomAnchor, constant: 10),
            lblDate.leadingAnchor.constraint(equalTo: self.imgView.leadingAnchor),
            lblDate.trailingAnchor.constraint(equalTo: self.imgView.trailingAnchor),
            lblDate.bottomAnchor.constraint(lessThanOrEqualTo: self.contentView.bottomAnchor, constant: -3),
            
            btnAction.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            btnAction.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            btnAction.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            
            self.btnMenuDots.bottomAnchor.constraint(equalTo: self.imgView.bottomAnchor, constant: -2),
            self.btnMenuDots.trailingAnchor.constraint(equalTo: self.imgView.trailingAnchor, constant: -14),
            self.btnMenuDots.heightAnchor.constraint(equalToConstant: 24),
            self.btnMenuDots.widthAnchor.constraint(equalToConstant: 24)
        ])
        
        self.btnAction.pinToView(view: self.contentView)
        self.bluredMenuView.pinToView(view: self.imgView)
    }
    
    @objc private func tappedOnBtnAction() {
        self.closureTappedOnBtnAction?()
    }
    
    @objc private func btnMenuDotsTapped(_ sender: UIButton) {
        self.bluredMenuView.isHidden = !self.bluredMenuView.isHidden
    }
    
    @objc private func hideOverlayBluredView() {
        self.bluredMenuView.isHidden = true
    }
    
    func setData(dataModel: WorkoutDataModel?, selectedDate: Date?) {
        self.workoutDataModel = dataModel
        self.selectedDate = selectedDate
        
        self.completedCheckMarkImageView.isHidden = true
        if dataModel?.id == nil {
            self.btnMenuDots.isHidden = true
            self.lblRestDay.isHidden = false
        } else {
            self.btnMenuDots.isHidden = false
            self.lblRestDay.isHidden = true
        }
        
        //MARK: set text
        
        self.lblCycle.text = "\(dataModel?.cycleName ?? "") • \(dataModel?.dayInProgram ?? "")"
        self.lblWorkoutName.text = dataModel?.workoutName ?? ""
        if dataModel?.dateString.toDateIgnoreAnyTimeZone()?.isCurrentDay() == true {
            self.lblDate.text = L.string("TODAY")
        } else {
            self.lblDate.text = dataModel?.dateString ?? ""
        }
        
        self.bluredMenuView.isHidden = true
        
        let date = dataModel?.dateString.toDateIgnoreAnyTimeZone()
        
        if let date = date {
            if date.isPreviousDay() {
                var markViewTitle: String? = L.string("MARK_AS_COMPLETE")
                
                if selectedDate?.isFutureDay() == true {
                    markViewTitle = nil
                }
                
                self.bluredMenuView.setTitles(markViewTitle: markViewTitle,
                                              moveViewTitle: L.string("MOVE_TO_TODAY"),
                                              seeRelatedVideosViewTitle: L.string("SEE_RELATED_VIDEOS"))
            } else if date.isCurrentDay() {
                var markViewTitle: String? = L.string("MARK_AS_COMPLETE")
                
                if selectedDate?.isFutureDay() == true {
                    markViewTitle = nil
                }
                
                self.bluredMenuView.setTitles(markViewTitle: markViewTitle,
                                              moveViewTitle: L.string("MOVE_TO_TOMORROW"),
                                              seeRelatedVideosViewTitle: L.string("SEE_RELATED_VIDEOS"))
            } else if date.isFutureDay() {
                self.bluredMenuView.setTitles(markViewTitle: nil,
                                              moveViewTitle: L.string("MOVE_TO_TODAY"),
                                              seeRelatedVideosViewTitle: L.string("SEE_RELATED_VIDEOS"))
            }
        }
        
        //MARK: set image
        self.imgView.image = nil
        self.loadImageIfPossible(imageUrl: dataModel?.thumbnail)
    }
    
    private func loadImageIfPossible(imageUrl: String?) {
        self.activityIndicator.start(onView: self.imgView)
        self.imgView.sd_setImage(with: URL(string: imageUrl ?? ""), completed: { [weak self] _,_,_,_  in
            self?.activityIndicator.stop()
        })
    }
    
    private func subscribeClosures() {
        
        self.bluredMenuView.markViewTappedClosure = { [weak self] in
            guard let sSelf = self else { return }
            sSelf.bluredMenuView.isHidden = true
            sSelf.markAsCompleteTappedClosure?(sSelf.workoutDataModel)
        }
        
        self.bluredMenuView.moveViewTappedClosure = { [weak self] in
            guard let sSelf = self else { return }
            sSelf.bluredMenuView.isHidden = true
            if sSelf.bluredMenuView.getMoveViewTitle() == L.string("MOVE_TO_TOMORROW") {
                sSelf.moveToTomorrowActionClosure?()
            } else if self?.bluredMenuView.getMoveViewTitle() == L.string("MOVE_TO_TODAY") {
                self?.moveToTodayActionClosure?()
            }
        }
        
        self.bluredMenuView.seeRelatedVideosViewTappedClosure = { [weak self] in
            self?.bluredMenuView.isHidden = true
            self?.seeRelatedVideosViewTappedClosure?()
        }
    }
}
