//
//  SeeRelatedVideosPresenter.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

final class SeeRelatedVideosPresenter: BasePresenter, SeeRelatedVideosPresenterProtocol {
    
    weak var view: SeeRelatedVideosVCProtocol!
    weak var programsRouter: ProgramsRouterProtocol!
    var networkManager: NetworkManagerProtocol!
    private let relatedVideos: [VideoDataModel]
    
    init(view: SeeRelatedVideosVCProtocol, programsRouter: ProgramsRouterProtocol, networkManager: NetworkManagerProtocol, relatedVideos: [VideoDataModel]) {
        self.relatedVideos = relatedVideos
        super.init()
        self.view = view
        self.programsRouter = programsRouter
        self.networkManager = networkManager
        if relatedVideos.isEmpty {
            self.view.displayNoRelatedVideosView()
        } else {
            self.view.displayRelatedVideos()
        }
    }
    
    func getNumberOfSections() -> Int {
        return 1
    }
    
    func getNumberOfRows(for section: Int) -> Int {
        guard section == 0 else { return 0 }
        return relatedVideos.count
    }
    
    func getCellTitle(indexPath: IndexPath) -> String {
        guard indexPath.row < self.relatedVideos.count else { return  "" }
        return relatedVideos[indexPath.row].title ?? ""
    }
    
    func getCellThumbnail(indexPath: IndexPath) -> String {
        guard indexPath.row < self.relatedVideos.count else { return  "" }
        return relatedVideos[indexPath.row].thumbnail ?? ""
    }
    
    func getVideosCellInfo(indexPath: IndexPath) -> AllMuseVideosModel? {
        guard indexPath.row < self.relatedVideos.count else { return  nil }

        let svid = self.relatedVideos[indexPath.row].museSvid ?? ""
        
        if svid != "" {
            return StorageDataManager.shared.getDetailInfoForVideoBy(svid: svid)
        } else {
            return nil
        }
    }
    
    func getVideoTypes(indexPath: IndexPath) -> [String] {
        guard indexPath.row < self.relatedVideos.count else { return [] }
        return self.relatedVideos[indexPath.row].videoType ?? []
    }
}
