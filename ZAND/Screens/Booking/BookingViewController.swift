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

    var urlString: String?

    private lazy var webView: WKWebView = {
        let configurator = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: configurator)
        return webView
    }()

    // MARK: - Initializers

    init(url: String) {
        self.urlString = url

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
        let policyUrl = URL(string: self.urlString ?? "")!

        let url = URL(string: URLS.yClientsBase)!

        if urlString == "" {
            let request = URLRequest(url: url)
            DispatchQueue.main.async { [weak self] in
                self?.webView.load(request)
            }
        } else {
            let requestPolicy = URLRequest(url: policyUrl)
            DispatchQueue.main.async { [weak self] in
                self?.webView.load(requestPolicy)
            }
        }
    }
}

//private func request() {
//    guard let policyUrl = URL(string: self.urlString ?? "") else { return }
//    let url = URL(string: URLS.yClientsBase)!
//
//    if urlString == "" {
//        let request = URLRequest(url: url)
//        DispatchQueue.main.async { [weak self] in
//            self?.webView.load(request)
//        }
//    } else {
//        let requestPolicy = URLRequest(url: policyUrl)
//        DispatchQueue.main.async { [weak self] in
//            self?.webView.load(requestPolicy)
//        }
//    }
//}
