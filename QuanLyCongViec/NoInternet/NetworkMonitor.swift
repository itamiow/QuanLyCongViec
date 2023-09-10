//
//  NetworkMonitor.swift
//  QuanLyCongViec
//
//  Created by Quang Viện on 28/08/2023.
//

import Foundation
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()

    let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    var isReachable: Bool { status == .satisfied }

    func startMonitoring() {
        monitor.pathUpdateHandler = {[weak self] path in
            self?.status = path.status

            if path.status == .satisfied {
                print("We're connected!")
                // post connected notification
            } else {
                print("No connection.")
                DispatchQueue.main.async {
                    AppDelegate.scene?.routeToNoInternet()
                }
            }
        }

        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
