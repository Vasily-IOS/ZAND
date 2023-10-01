//
//  BookingViewController.swift
//  ZAND
//
//  Created by Василий on 05.05.2023.
//

import Foundation
import WebKit

final class PrivacyPolicyViewController: UIViewController {

    // MARK: - Properties

    private let urlString: String

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

        request(urlString: urlString)
    }
    
    // MARK: - Instance methods

    private func request(urlString: String) {
        guard let url = URL(string: urlString) else { return }

        let request = URLRequest(url: url)

        DispatchQueue.main.async { [weak self] in
            self?.webView.load(request)
        }
    }
}
