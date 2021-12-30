//
//  LMSBytecastingTests.swift
//  LMSBytecastingTests
//
//  Created by SPURGE on 30/12/21.
//

import Foundation
import WebKit



class WeakScriptMessageDelegate: NSObject, WKScriptMessageHandler {
    weak var scriptDelegate: WKScriptMessageHandler?

    init(_ scriptDelegate: WKScriptMessageHandler) {
        self.scriptDelegate = scriptDelegate
        super.init()
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        scriptDelegate?.userContentController(userContentController, didReceive: message)
    }
}

public extension WKWebView {
    fileprivate struct AssociatedKey {
        static var receiveScriptMessageHandlerWrapper: String = "com.EasyWebView.receiveScriptMessageHandler"
    }

    private var receiveScriptMessageHandler: ReceiveScriptMessageBlock? {
        get {
            guard let block = associatedObject(forKey: &AssociatedKey.receiveScriptMessageHandlerWrapper) as? ReceiveScriptMessageBlock else {
                return nil
            }
            return block
        }
        set {
            associate(copyObject: newValue, forKey: &AssociatedKey.receiveScriptMessageHandlerWrapper)
        }
    }

    /// js 用以下的方法调用 iOS 的函数：
    /// window.webkit.messageHandlers. {scriptName}.postMessage(object)
    /// - Parameter scriptNames: 函数名称数组
    /// - Parameter receiveScriptMessageHandler: 回调
    func addScriptMessageHandler(scriptNames: [String], receiveScriptMessageHandler: ReceiveScriptMessageBlock? = nil) {
        self.receiveScriptMessageHandler = receiveScriptMessageHandler
        for scriptName in scriptNames {
            configuration.userContentController.removeScriptMessageHandler(forName: scriptName)
            configuration.userContentController.add(WeakScriptMessageDelegate(self), name: scriptName)
        }
    }
}

extension WKWebView: WKScriptMessageHandler {
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        receiveScriptMessageHandler?(userContentController, message)
    }
}
// MARK: - Action
public extension WebViewController {
    /// back to last page
    ///
    /// - Parameter completion: whether can back to prefix page
    func goBack(completion: BoolBlock? = nil) {
        if webView.canGoBack {
            webView.goBack()
            completion?(webView.canGoBack)
        }
        completion?(false)
    }

    /// go to next oage
    ///
    /// - Parameter completion: whether can go to next page
    func goForward(completion: BoolBlock? = nil) {
        if webView.canGoForward {
            webView.goForward()
            completion?(webView.canGoForward)
        }
        completion?(false)
    }

    /// reload the webView
    func reload() {
        webView.reload()
    }
}
