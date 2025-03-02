//
//  Bundle.swift
//  XCStringsTool
//
//  Created by Roberto Casula on 02/03/25.
//

import Foundation

#if DEBUG
    private class BundleFinder {}
#endif

extension Foundation.Bundle {
    static let current: Bundle = {
        #if DEBUG
        let bundleName = "XCStringsTool_PluginTests"

        let candidates = [
            // Bundle should be present here when the package is linked into an App.
            Bundle.main.resourceURL,

            // Bundle should be present here when the package is linked into a framework.
            Bundle(for: BundleFinder.self).resourceURL,

            // For command-line tools.
            Bundle.main.bundleURL,

            // Bundle should be present here when running previews
            // from a different package (this is the path to "…/Debug-iphonesimulator/").
            Bundle(for: BundleFinder.self).resourceURL?.deletingLastPathComponent()
                .deletingLastPathComponent(),
        ]

        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }
        fatalError("unable to find bundle named \(bundleName)")
        #else
        .module
        #endif
    }()
}
