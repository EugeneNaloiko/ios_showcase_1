//
//  WorkoutAdditionalInfoView.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class WorkoutAdditionalInfoView: UIView {
    
    private var equipmentView: EquipmentView = {
        let view = EquipmentView()
        view.setTitle(titleText: L.string("EQUIPMENT"))
        return view
    }()
    
    private var typeView: IntensityView = {
        let view = IntensityView()
        view.setTitle(titleText: L.string("TYPE_STRING"))
        return view
    }()
    
    private var intensityView: IntensityView = {
        let view = IntensityView()
        view.setTitle(titleText: L.string("INTENSITY_STRING"))
        return view
    }()
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .fillEqually
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        self.prepareUI()
        self.addingViews()
        self.setupConstraints()
    }
    
    private func prepareUI() {
        self.backgroundColor = UIColor.clear
    }
    
    private func addingViews() {
        self.stackView.addArrangedSubview(self.equipmentView)
        self.stackView.addArrangedSubview(self.typeView)
        self.stackView.addArrangedSubview(self.intensityView)
        self.addSubview(self.stackView)
    }
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.pinToView(view: self)
    }
    
    func setData(equipmentIconsUrls: [String], workoutData: WorkoutDataModel) {
        let estimatedWidth: CGFloat = (UIScreen.main.bounds.width - 40) / 3
        
        self.equipmentView.setValues(equipmentUrls: equipmentIconsUrls, estimatedWidth: estimatedWidth)
        self.typeView.setValues(values: workoutData.workoutType ?? [])
        self.intensityView.setValues(values: workoutData.workoutIntensity ?? [])
    }
    
}
