//
//  LMSBytecastingTests.swift
//  LMSBytecastingTests
//
//  Created by SPURGE on 30/12/21.
//

import Foundation
import UIKit
import WebKit

public typealias BoolBlock = (_ boolen: Bool) -> Void
public typealias ReceiveScriptMessageBlock = (_ userContentController: WKUserContentController, _ message: WKScriptMessage) -> Void

public struct WebViewConfig {
    ///
    public static var alertConfirmTitle: String = "Done"
    ///
    public static var alertCancelTitle: String = "Cancel"
    ///
    public static var progressTintColor: UIColor = UIColor.blue
    ///
    public static var progressTrackTintColor: UIColor = .lightGray
}
