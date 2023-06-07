//
//  BookingViewController.swift
//  ZAND
//
//  Created by Василий on 05.05.2023.
//

import Foundation
import WebKit

final class BookingViewController: UIViewController {

    // MARK: - Properties
    
    private lazy var webView: WKWebView = {
        let configurator = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: configurator)
        return webView
    }()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
    }
    
    // MARK: - Instance method
    
    private func request() {
        guard let url = URL(string: YClientsMockURL.url) else { return }
        let request = URLRequest(url: url)
        DispatchQueue.main.async { [weak self] in
            self?.webView.load(request)
        }
    }
}
