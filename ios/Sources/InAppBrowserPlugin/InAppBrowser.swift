import Foundation
import UIKit
import WebKit

@objc public class InAppBrowser: NSObject {
    @objc public func echo(_ value: String) -> String {
        print("echo: \(value)")
        return value
    }

    @objc public func openInAppBrowser(_ url: String, _ title: String, _ presentingViewController: UIViewController) {
        print("openInAppBrowser: \(url), \(title)")
        guard let targetURL = URL(string: url) else {
            print("openInAppBrowser: invalid url")
            return
        }

        DispatchQueue.main.async {
            let browserViewController = InAppBrowserViewController(url: targetURL, titleText: title)
            browserViewController.modalPresentationStyle = .fullScreen
            browserViewController.modalTransitionStyle = .coverVertical
            presentingViewController.present(browserViewController, animated: true)
        }
    }
}

final class InAppBrowserViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    private static let textColor = UIColor(red: 36.0 / 255.0, green: 40.0 / 255.0, blue: 40.0 / 255.0, alpha: 1)
    private let url: URL
    private let titleText: String
    private let webView = WKWebView(frame: .zero)
    private let backButton = UIButton(type: .system)
    private var canGoBackObservation: NSKeyValueObservation?
    private let progressView = UIProgressView(progressViewStyle: .bar)
    private var progressObservation: NSKeyValueObservation?

    init(url: URL, titleText: String) {
        self.url = url
        self.titleText = titleText
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = .white

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = titleText
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textAlignment = .center
        titleLabel.textColor = Self.textColor
        titleLabel.lineBreakMode = .byTruncatingTail

        backButton.translatesAutoresizingMaskIntoConstraints = false
        let backSymbolConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .regular)
        let backSymbol = UIImage(systemName: "chevron.left", withConfiguration: backSymbolConfig)
        backButton.setImage(backSymbol, for: .normal)
        backButton.tintColor = Self.textColor
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        backButton.isHidden = true

        let closeButton = UIButton(type: .system)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        let closeSymbolConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .regular)
        let closeSymbol = UIImage(systemName: "xmark", withConfiguration: closeSymbolConfig)
        closeButton.setImage(closeSymbol, for: .normal)
        closeButton.tintColor = Self.textColor
        closeButton.imageView?.contentMode = .scaleAspectFit
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)

        webView.backgroundColor = .white
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        webView.uiDelegate = self
        canGoBackObservation = webView.observe(\.canGoBack, options: [.initial, .new]) { [weak self] _, _ in
            self?.updateBackButtonVisibility()
        }
        if #available(iOS 11.0, *) {
            // Prevent automatic safe-area insets from creating extra scroll space.
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        }

        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.trackTintColor = .clear
        progressView.progress = 0
        progressView.isHidden = true
        progressObservation = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, _ in
            self?.updateProgress(Float(webView.estimatedProgress))
        }

        view.addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(backButton)
        headerView.addSubview(closeButton)
        view.addSubview(progressView)
        view.addSubview(webView)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 56),

            backButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 32),
            backButton.heightAnchor.constraint(equalToConstant: 32),

            closeButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            closeButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 32),
            closeButton.heightAnchor.constraint(equalToConstant: 32),

            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: backButton.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: closeButton.leadingAnchor, constant: -12),

            progressView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 2),

            webView.topAnchor.constraint(equalTo: progressView.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        let request = URLRequest(url: url)
        webView.load(request)
    }

    @objc private func backTapped() {
        if webView.canGoBack {
            webView.goBack()
        }
    }

    @objc private func closeTapped() {
        dismiss(animated: true)
    }

    private func updateBackButtonVisibility() {
        backButton.isHidden = !webView.canGoBack
    }

    private func updateProgress(_ progress: Float) {
        if progress >= 1.0 {
            progressView.setProgress(1.0, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                self?.progressView.isHidden = true
                self?.progressView.progress = 0
            }
        } else {
            if progressView.isHidden {
                progressView.isHidden = false
            }
            progressView.setProgress(progress, animated: true)
        }
    }

    // Open new window requests in the same webview.
    func webView(_ webView: WKWebView,
                 createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction,
                 windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil, let targetURL = navigationAction.request.url {
            webView.load(URLRequest(url: targetURL))
        }
        return nil
    }

}
