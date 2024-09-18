//
//  NetworkManager.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 05/08/24.
//

import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    
    private let reachabilityManager = NetworkReachabilityManager()
    
    private init() {
        startMonitoring()
    }
    
    var isConnectedToInternet: Bool {
        return reachabilityManager?.isReachable ?? false
    }
    
    private func startMonitoring() {
        reachabilityManager?.startListening { status in
            switch status {
            case .notReachable:
                print("No internet connection")
            case .reachable(.ethernetOrWiFi), .reachable(.cellular):
                print("Connected to the internet")
            case .unknown:
                print("Unknown network status")
            }
        }
    }
    
    func stopMonitoring() {
        reachabilityManager?.stopListening()
    }
}
