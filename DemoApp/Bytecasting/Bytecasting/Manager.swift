//
//  LMSBytecastingTests.swift
//  LMSBytecastingTests
//
//  Created by SPURGE on 30/12/21.
//

import UIKit

public class Manager {
    public init(){}
    public func viewController() -> WebViewController {
        let bundle = Bundle(for: WebViewController.self)
        let vc = WebViewController(nibName: "WebviewController", bundle: bundle)
        return vc
    }
}
