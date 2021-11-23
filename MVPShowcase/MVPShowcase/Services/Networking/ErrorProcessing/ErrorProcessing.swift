//
//  ErrorProcessing.swift
//  NetworkLayer
//
//  Created by Eugene
//

import Foundation
import UIKit

public struct ErrorMessages {
    public static let sorryTryAgainLater = "SORRY_TRY_AGAIN_LATER"
    static let noInternetConnection = "PLEASE_CHECK_YOUR_INTERNET_CONNECTION"
    static let noResults = "THERE_ARE_NO_RESULTS"
    static let cantFindHost = "A_SERVER_WITH_THE_SPECIFIED_HOSTNAME_COULD_NOT_BE_FOUND"
    static let requestTimedOut = "REQUEST_TIMED_OUT"
    static let userLoggedInFromAnotherDeviceOrServerError = "SERVER_ERROR_APPEARED_OR_USER_SIGNED_IN_FROM_ANOTHER_DEVICE"
}

public enum NetworkResponseError: Equatable {
    case authenticationError //401
    case accessForbidden //3 Times Entered Wrong Pin //403
    case signedInOnOtherDeviceShouldLogOut //Server Error. Or Logged In From Another Device.
    case doNothing
    case alert(message: String)
    case noInternetConnection(message: String)
    case timeOut(message: String)
    
    case invalidUsernameOrPassword
    case processedOnServerError(code: Int?, message: String?)
    case callAcceptedAfterRedirectToAnotherClerk
    case unKnownError
}

class ErrorProcessing: NSObject {
    
    static func processError(data: Data?, response: URLResponse?, error: Error?) -> NetworkResponseError {
        
        if let data = data, let response = response as? HTTPURLResponse {
            return ErrorProcessing.codeToErrorProcessed(code: response.statusCode, data: data)
        } else if let error = error as NSError? {
            return ErrorProcessing.codeToErrorProcessed(code: error.code, data: data)
        } else {
            return .unKnownError
        }
    }
    
    internal static func codeToErrorProcessed(code: Int, data: Data?) -> NetworkResponseError {
        
        let errorMessage = ErrorMessages.sorryTryAgainLater
        switch code {
        case -999:
            return .doNothing
        case 400:
            if let data = data {
                //TODO: Move to extension. Data to JSON object convertion
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    let codeInError = json["code"] as? Int
                    let messageInError = json["message"] as? String
                    if messageInError?.contains("Invalid username/password.") == true {
                        return .invalidUsernameOrPassword
                    } else {
                        return .processedOnServerError(code: codeInError, message: messageInError)
                    }
                }
            }
            return .processedOnServerError(code: nil, message: nil)
        case 401:
            return .authenticationError
        case 403:
            return .accessForbidden
        case 410:
            return .callAcceptedAfterRedirectToAnotherClerk
        case NSURLErrorCannotConnectToHost: //Can not connect to the host
            return .alert(message: ErrorMessages.sorryTryAgainLater)
        case NSURLErrorNotConnectedToInternet: //-1009
            return .noInternetConnection(message: ErrorMessages.noInternetConnection)//No Internet connection
        case NSURLErrorCannotFindHost: //The connection failed because the host could not be found.//-1003
            return .alert(message: ErrorMessages.cantFindHost)
        case -1001: //NSURLErrorTimedOut: //Request Timed Out.
            return .timeOut(message: ErrorMessages.requestTimedOut)
        default:
            return .alert(message: errorMessage)
        }
    }
}
