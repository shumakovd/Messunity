//
//  APIManager.swift
//  Messunity
//
//  Created by Shumakov Dmytro on 13.11.2022.
//

import Alamofire
import CodableAlamofire
import Foundation

protocol APIConfiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
    var encoding: Alamofire.ParameterEncoding? { get }
    var baseURL: URL? { get }
}

final class APIManager {
    
    /// The static field that controls the access to the singleton instance.
    /// This implementation let you extend the Singleton class while keeping
    /// just one instance of each subclass around.
    class func shared() -> APIManager {
        return sharedNetworkManager
    }
    
    private static var sharedNetworkManager: APIManager = {
        APIManager()
    }()
    
    private init() {}
    
    // MARK: - Enums -
    
    enum Result<T> {
        case success(T)
        case failure(String)
    }
    
    enum ResultNoResponse {
        case success
        case failure(String)
    }
    
    // MARK: - Properties -
    
    private let failureNoInternet = "No Internet. Please, make sure you are connected and try again."
    
    private let manager: Alamofire.Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        return Alamofire.Session(configuration: configuration)
    }()
        
    private func performRequest<T: Codable>(router: BaseRouter, needToChangeDecoder: Bool = false, completion: @escaping (Result<T>) -> Void) {
        print("API -->: \(router.path), params: \(String(describing: router.parameters ?? nil)) ")
        
        // Check Internet connection
        if !NetworkStatus.isConnectedToInternet() {
            completion(.failure(failureNoInternet))
        }
        // Setup decoder
        let decoder = JSONDecoder()
        if needToChangeDecoder {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            decoder.dateDecodingStrategy = .formatted(formatter)
        } else {
            decoder.dateDecodingStrategy = .secondsSince1970
        }
        
        manager.request(router).responseDecodableObject(keyPath: router.keyPath, decoder: decoder) { (response: AFDataResponse<T>) in
            print("Result: \(String(describing: response.response))")
            
            guard response.error == nil else {
                let statusCode = response.response?.statusCode ?? -1
                print("Status Code = \(statusCode)")
                // Handle status code and work with it
                completion(.failure("\(statusCode)"))
                return
            }
            
            if let object = response.value {
                print("SUCCESS DECODE")
                do {
                    let encoder = JSONEncoder()
                    encoder.outputFormatting = .prettyPrinted
                    let data = try encoder.encode(object)
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print(jsonString)
                    }
                } catch {
                    print(error)
                }
                completion(.success(object))
            }
        }
    }
    
    
    // MARK: - GET METHODS -
    
    // MARK: - POST METHODS -


}

