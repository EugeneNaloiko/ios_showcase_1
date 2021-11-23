//
//  WorkoutTopHeaderView.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class WorkoutTopHeaderView: UIView {
    
    private let imgView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.backgroundColor = UIColor.tfLightGray
        img.clipsToBounds = true
        return img
    }()
    
    private let imgPlayAction: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage(named: "img_play_action")
        return imgView
    }()
    
    private var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.textColor = UIColor.tfBlack
        lbl.font = UIFont.sfProFont(.semibold, size: 24)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    private let lblSubtitle: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.textColor = UIColor.tfLightGreyBlue
        lbl.font = UIFont.sfProFont(.regular, size: 12)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    private let lblProgramName: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.textColor = UIColor.tfOrangish
        lbl.font = UIFont.sfProFont(.regular, size: 12)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    private let lblSelectedDate: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = UIColor.tfOrangish
        lbl.font = UIFont.sfProFont(.semibold, size: 12)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        return lbl
    }()
    
    private let btnComplete: BaseButton = {
        let btn = BaseButton(style: .orange)
        return btn
    }()
    
    private let bottomSeparatorView = BaseSeparatorView()
    
    private let additionalInfoView: WorkoutAdditionalInfoView = {
        let view = WorkoutAdditionalInfoView()
        return view
    }()
    
    private var workoutData: WorkoutDataModel!
    
    var btnCompleteIncompleteTappedClosure: (() -> Void)?
    var shouldUpdateHeaderHeightClosure: ((_ isAnimated: Bool) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        subscribeClosures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        self.prepareUI()
        self.addingViews()
        self.setupConstraints()
        self.setPlayImageHidden()
    }
    
    private func prepareUI() {
        self.backgroundColor = .tfWhite
        self.additionalInfoView.backgroundColor = .clear
    }
    
    private func addingViews() {
        self.addSubview(self.imgView)
        self.imgView.addSubview(self.imgPlayAction)
        self.addSubview(self.lblTitle)
        self.addSubview(self.lblSubtitle)
        self.addSubview(self.lblProgramName)
        self.addSubview(self.btnComplete)
        self.addSubview(self.lblSelectedDate)
        self.addSubview(self.additionalInfoView)
        self.addSubview(self.bottomSeparatorView)
    }
    
    private func setupConstraints() {
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgPlayAction.translatesAutoresizingMaskIntoConstraints = false
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        lblSubtitle.translatesAutoresizingMaskIntoConstraints = false
        lblProgramName.translatesAutoresizingMaskIntoConstraints = false
        btnComplete.translatesAutoresizingMaskIntoConstraints = false
        lblSelectedDate.translatesAutoresizingMaskIntoConstraints = false
        additionalInfoView.translatesAutoresizingMaskIntoConstraints = false
        bottomSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        
        self.btnComplete.height = 32
        
        NSLayoutConstraint.activate([
            self.imgView.topAnchor.constraint(equalTo: self.topAnchor),
            self.imgView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.imgView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.imgView.heightAnchor.constraint(equalToConstant: 264),
            
            self.imgPlayAction.centerXAnchor.constraint(equalTo: self.imgView.centerXAnchor),
            self.imgPlayAction.centerYAnchor.constraint(equalTo: self.imgView.centerYAnchor),
            self.imgPlayAction.heightAnchor.constraint(equalToConstant: 41),
            self.imgPlayAction.widthAnchor.constraint(equalToConstant: 41),
            
            self.btnComplete.topAnchor.constraint(equalTo: self.imgView.bottomAnchor, constant: 23),
            self.btnComplete.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            self.btnComplete.widthAnchor.constraint(equalToConstant: 106),
            
            self.lblSelectedDate.topAnchor.constraint(equalTo: self.btnComplete.bottomAnchor, constant: 10),
            self.lblSelectedDate.leadingAnchor.constraint(equalTo: self.btnComplete.leadingAnchor, constant: 0),
            self.lblSelectedDate.trailingAnchor.constraint(equalTo: self.btnComplete.trailingAnchor, constant: 0),
            
            self.lblTitle.topAnchor.constraint(equalTo: self.imgView.bottomAnchor, constant: 14),
            self.lblTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.lblTitle.trailingAnchor.constraint(equalTo: self.btnComplete.leadingAnchor, constant: -10),
            
            self.lblSubtitle.topAnchor.constraint(equalTo: self.lblTitle.bottomAnchor, constant: 5),
            self.lblSubtitle.leadingAnchor.constraint(equalTo: self.lblTitle.leadingAnchor),
            self.lblSubtitle.trailingAnchor.constraint(equalTo: self.lblTitle.trailingAnchor),
            
            self.lblProgramName.topAnchor.constraint(equalTo: self.lblSubtitle.bottomAnchor, constant: 5),
            self.lblProgramName.leadingAnchor.constraint(equalTo: self.lblSubtitle.leadingAnchor),
            self.lblProgramName.trailingAnchor.constraint(equalTo: self.lblSubtitle.trailingAnchor),
            
            self.additionalInfoView.topAnchor.constraint(equalTo: self.lblProgramName.bottomAnchor, constant: 20),
            self.additionalInfoView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.additionalInfoView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            self.bottomSeparatorView.topAnchor.constraint(equalTo: self.additionalInfoView.bottomAnchor, constant: 16),
            self.bottomSeparatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.bottomSeparatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.bottomSeparatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            self.bottomSeparatorView.heightAnchor.constraint(equalToConstant: 4),
        ])
    }
    
    func setData(programData: ProgramDataModel, workoutData: WorkoutDataModel, selectedDate: String) {
        self.workoutData = workoutData
        lblTitle.text = workoutData.workoutName
        lblSubtitle.text = workoutData.workoutDescription
        
        self.lblProgramName.text = programData.programDetails?.title
        
        self.lblSelectedDate.text = selectedDate
        
        if selectedDate.toDateIgnoreAnyTimeZone()?.isFutureDay() == true {
            self.btnComplete.isHidden = true
        } else {
            self.btnComplete.isHidden = false
        }
        
        self.additionalInfoView.setData(equipmentIconsUrls: workoutData.trainingEquipmentIcons ?? [], workoutData: workoutData)
        
        //MARK: set image
        self.imgView.image = nil
        self.imgView.sd_setImage(with: URL(string: workoutData.thumbnail ?? ""), completed: nil)
    }
    
    private func subscribeClosures() {
        
        self.btnComplete.didTapClosure = { [weak self] in
            guard let sSelf = self else { return }
            sSelf.btnCompleteIncompleteTappedClosure?()
        }
    }
    
    func setPlayImageHidden() {
        self.imgPlayAction.isHidden = true
    }
    
    func changeButtonStateTo(state: WorkoutState) {
        switch state {
        case .incomplete:
            self.btnComplete.setTitle(L.string("COMPLETE_STRING"), for: UIControl.State.normal)
        case .complete:
            self.btnComplete.setTitle(L.string("INCOMPLETE_STRING"), for: UIControl.State.normal)
        }
    }
    
}
