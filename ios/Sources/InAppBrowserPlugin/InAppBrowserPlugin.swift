import Foundation
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(InAppBrowserPlugin)
public class InAppBrowserPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "InAppBrowserPlugin"
    public let jsName = "InAppBrowser"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "echo", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "openInAppBrowser", returnType: CAPPluginReturnPromise)
    ]
    private let implementation = InAppBrowser()

    @objc func echo(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
        call.resolve([
            "value": implementation.echo(value)
        ])
    }

    @objc func openInAppBrowser(_ call: CAPPluginCall) {
        let url = call.getString("url") ?? ""
        let title = call.getString("title") ?? ""
        if url.isEmpty {
            call.reject("url is required")
            return
        }
        guard let presentingViewController = bridge?.viewController else {
            call.reject("presenting view controller is not available")
            return
        }
        
        implementation.openInAppBrowser(url, title, presentingViewController, getConfig())
        call.resolve()
    }
}
