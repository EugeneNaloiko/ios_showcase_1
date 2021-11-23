//
//  GetDashboardInfo.swift
//
//  Created by Eugene Naloiko on 05.07.2021.
//

import Foundation

extension NetworkManager {
    
    // MARK: GetDashboardInfo
    func getDashboardInfo(completion: ((_ dashboardInfoModel: DashboardInfoModel?, _ error: NetworkResponseError?) -> Void)?) {
        
        func performRequest() {
            let endpoint: EndPoint = .getDashboardInfo
            
            router.request(endpoint, completion: { [weak self] data, response, error in
                guard let sSelf = self else { return }
                sSelf.responseDataProcessingGeneric(data: data, response: response, error: error, isShouldRefreshToken: true) { (responseModel: DashboardInfoModel?, responseError, isShouldRepeatRequest)  in
                    guard !isShouldRepeatRequest else { performRequest(); return }
                    if let _ = responseError {
                        UIUtils.displayNetworkErrorBanner(btnTryAgainTappedCompletion: performRequest)
                    } else {
                        StorageDataManager.shared.dashboardInfo = responseModel
                        completion?(responseModel, responseError)
                    }
                }
            })
        }
        
        performRequest()
    }
    
}
