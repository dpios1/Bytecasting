//
//  LMSBytecastingTests.swift
//  LMSBytecastingTests
//
//  Created by SPURGE on 30/12/21.
//

import UIKit
import WebKit

open class WebViewController:  UIViewController {

    /// access url string
    @IBOutlet weak var vw_webView: UIView!
    public var urlString: String? {
        didSet {
            guard let urlString = urlString, let url = URL(string: urlString) else {
                fatalError("URL can't be nil")
            }
            var request = URLRequest(url: url)
            request.addValue("skey=skeyValue", forHTTPHeaderField: "Cookie")
            webView.load(request)
        }
    }


    /// access urlRequest
    public var urlRequest: URLRequest? {
        didSet {
            guard let urlRequest = urlRequest else {
                fatalError("urlRequest can't be nil")
            }
            webView.load(urlRequest)
        }
    }

    /// whether show progressView of loading
    open var isShowProgressView: Bool {
        return true
    }

    /// whether show title of webView content
    open var isShowTitle: Bool {
        return true
    }

    /// progressView's tintColor
    public var progressTintColor: UIColor = WebViewConfig.progressTintColor
    /// progressView's track tintColor
    public var progressTrackTintColor: UIColor = WebViewConfig.progressTrackTintColor
    /// alert confirm title of runJavaScriptAlertPanelWithMessage, default is  "OK"，can setup at WebViewConfig.alertConfirmTitle
    public var alertConfirmTitle: String = WebViewConfig.alertConfirmTitle
    /// alert confirm title of runJavaScriptAlertPanelWithMessage, default is  "Cancel"，can setup at WebViewConfig.alertCancelTitle
    public var alertCancelTitle: String = WebViewConfig.alertCancelTitle

    public lazy private(set) var webView: WKWebView = {
        let userContentController = WKUserContentController()
        let cookieScript = WKUserScript(source: "document.cookie = 'skey=skeyValue';",
                                        injectionTime: .atDocumentStart, forMainFrameOnly: false)
        userContentController.addUserScript(cookieScript)

        let configuration = WKWebViewConfiguration()
        configuration.preferences.minimumFontSize = 1
        configuration.preferences.javaScriptEnabled = true
        configuration.allowsInlineMediaPlayback = true
        configuration.userContentController = userContentController

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.allowsBackForwardNavigationGestures = true

        webView.uiDelegate = self
        webView.navigationDelegate = self

        return webView
    }()

    public lazy private(set) var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.trackTintColor = progressTrackTintColor
        progressView.tintColor = progressTintColor
        return progressView
    }()

    private var loadingObservation: NSKeyValueObservation?
    private var titleObservation: NSKeyValueObservation?
    private var progressObservation: NSKeyValueObservation?

    deinit {
        loadingObservation = nil
        titleObservation = nil
        progressObservation = nil
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
        setupUI()
    }

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isShowProgressView {
            let progressViewHeight: CGFloat = 2
            progressView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: progressViewHeight)
            webView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        } else {
            webView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        }
    }
    @IBAction func reloadAction(_ sender: Any) {
        reload()
    }
    @IBAction func forwardAction(_ sender: Any) {
        goForward()
    }
    @IBAction func backwardAction(_ sender: Any) {
        goBack()
    }
}
// MARK: - UI
private extension WebViewController {
    func setupUI() {
        vw_webView.addSubview(webView)
        if isShowProgressView {
            vw_webView.addSubview(progressView)
        }
    }

    func showProgressView() {
        let originY = webView.scrollView.autualContentInset.top
        progressView.frame.origin.y = originY
        progressView.isHidden = false
        progressView.setProgress(Float(webView.estimatedProgress), animated: true)
    }

    func hideProgressView() {
        progressView.isHidden = true
        progressView.setProgress(0, animated: false)
    }
}
// MARK: - Function
private extension WebViewController {
    func addObservers() {
        loadingObservation = webView.observe(\WKWebView.isLoading) { [weak self] (_, _) in
            guard let self = self else { return }
            if !self.webView.isLoading {
                self.hideProgressView()
            }
        }
        titleObservation = webView.observe(\WKWebView.title) { [weak self] (webView, _) in
            guard let self = self, self.isShowTitle else { return }
            self.title = self.webView.title
        }
        progressObservation = webView.observe(\WKWebView.estimatedProgress) { [weak self] (_, _) in
            guard let self = self else { return }
            self.showProgressView()
        }
    }
}
