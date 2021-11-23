//
//  ActiveProgramCell.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class ActiveProgramCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: type(of: self))
    
    private var collectionView: UICollectionView!
    
    private let lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.textColor = UIColor.tfBlack
        lbl.font = UIFont.sfProFont(.bold, size: 16)
        return lbl
    }()
    
    private var programDataModel: ProgramDataModel! {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
    
    var selectedDate: Date!
    
    var closureTappedBtnNext: (() -> Void)?
    var seeRelatedVideosViewTappedClosure: ((WorkoutDataModel) -> Void)?
    
    var markAsCompleteTappedClosure: ((_ workoutDataModel: WorkoutDataModel) -> Void)?
    
    var moveToTodayActionClosure: ((_ programSku: String, _ currentPosition: Int) -> Void)?
    var moveToTomorrowActionClosure: ((_ programSku: String, _ currentPosition: Int) -> Void)?
    
    var scrolledToItem: ((Int)->Void)?
    var pickedItem: ((WorkoutDataModel)->Void)?
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        self.setupCollectionView()
        self.addingViews()
        self.setupConstraints()
        self.contentView.backgroundColor = UIColor.tfWhite
    }
    
    private func setupCollectionView() {
        let layout: UICollectionViewFlowLayout = SnappingCollectionViewLayout() //UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

        collectionView?.decelerationRate = UIScrollView.DecelerationRate.fast

        collectionView.backgroundColor = UIColor.tfWhite
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        self.registerCollectionViewCells()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    private func registerCollectionViewCells() {
        collectionView?.register(ActiveProgramCollectionViewCell.self, forCellWithReuseIdentifier: ActiveProgramCollectionViewCell.reuseIdentifier)
    }
    
    private func addingViews() {
        self.contentView.addSubview(self.lblTitle)
        self.contentView.addSubview(self.collectionView)
    }
    
    private func setupConstraints() {
        self.lblTitle.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.lblTitle.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15),
            self.lblTitle.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            self.lblTitle.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            
            self.collectionView.topAnchor.constraint(equalTo: self.lblTitle.bottomAnchor, constant: 10),
            self.collectionView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.collectionView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    func setData(programDataModel: ProgramDataModel, selectedDate: Date, indexPath: IndexPath) {
        self.selectedDate = selectedDate
        self.programDataModel = programDataModel
        self.lblTitle.text = programDataModel.programDetails?.title
        
        guard let firstWorkout = programDataModel.workouts.first else { return }
        guard let lastWorkout = programDataModel.workouts.last else { return }
        
        if let firstWorkoutDate = firstWorkout?.dateString.toDateIgnoreAnyTimeZone(), selectedDate < firstWorkoutDate {
            self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
        } else if let lastWorkoutDate = lastWorkout?.dateString.toDateIgnoreAnyTimeZone(), selectedDate > lastWorkoutDate {
            self.collectionView.scrollToItem(at: IndexPath(row: programDataModel.workouts.count - 1, section: 0), at: .left, animated: true)
        } else {
            for (index, workout) in programDataModel.workouts.enumerated() {
                if selectedDate.toString() == workout?.dateString {
                    DispatchQueue.main.async { [weak self] in
                        guard let sSelf = self else { return }
                        sSelf.collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .left, animated: true)
                    }
                }
            }
        }
        
    }
    
}

extension ActiveProgramCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.programDataModel?.workouts ?? []).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActiveProgramCollectionViewCell.reuseIdentifier, for: indexPath) as? ActiveProgramCollectionViewCell else { return UICollectionViewCell() }
        let workouts = self.programDataModel?.workouts ?? []
        let workout = workouts[indexPath.row]
        cell.setData(dataModel: workout, selectedDate: self.selectedDate)
    
        cell.closureTappedOnBtnAction = { [weak self] in
            guard let workout = workout, workout.id != nil else { return }
            self?.pickedItem?(workout)
        }
        
        cell.moveToTodayActionClosure = { [weak self] in
            guard let sSelf = self else { return }
            guard let sku = sSelf.programDataModel.sku else { return }
            sSelf.moveToTodayActionClosure?(sku, indexPath.row)
        }
        
        cell.markAsCompleteTappedClosure = { [weak self] workoutData in
            guard let sSelf = self else { return }
            sSelf.markAsCompleteTappedClosure?(workoutData)
        }
        
        cell.moveToTomorrowActionClosure = { [weak self] in
            guard let sSelf = self else { return }
            guard let sku = sSelf.programDataModel.sku else { return }
            sSelf.moveToTomorrowActionClosure?(sku, indexPath.row)
        }
        
        cell.seeRelatedVideosViewTappedClosure = { [weak self] in
            guard let workout = workout, workout.id != nil else { return }
            self?.seeRelatedVideosViewTappedClosure?(workout)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 74, height: 280)
    }
}

class SnappingCollectionViewLayout: UICollectionViewFlowLayout {

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity) }

        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalOffset = proposedContentOffset.x + collectionView.contentInset.left

        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)

        let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect)

        layoutAttributesArray?.forEach({ (layoutAttributes) in
            let itemOffset = layoutAttributes.frame.origin.x
            if fabsf(Float(itemOffset - horizontalOffset)) < fabsf(Float(offsetAdjustment)) {
                offsetAdjustment = itemOffset - horizontalOffset
            }
        })

        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
}
