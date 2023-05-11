//
//  BookingViewController.swift
//  ZAND
//
//  Created by Василий on 05.05.2023.
//

import Foundation
import WebKit

final class BookingViewController: UIViewController {

    private lazy var webView: WKWebView = {
        let configurator = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: configurator)
        return webView
    }()
    
    override func loadView() {
        super.loadView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
    }
    
    private func request() {
        let urlString = "https://www.youtube.com/watch?v=eGdAipbnoys&list=RDEMYXFd1WjBMZdHHvPdHyaEiw&index=3"
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        DispatchQueue.main.async { [weak self] in
            self?.webView.load(request)
        }
    }
}
