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

final class InAppBrowserViewController: UIViewController {
    private let url: URL
    private let titleText: String
    private let webView = WKWebView(frame: .zero)

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
        titleLabel.textColor = UIColor(red: 36.0 / 255.0, green: 40.0 / 255.0, blue: 40.0 / 255.0, alpha: 1)
        titleLabel.lineBreakMode = .byTruncatingTail

        let closeButton = UIButton(type: .system)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(makeCloseIconImage().withRenderingMode(.alwaysOriginal), for: .normal)
        closeButton.imageView?.contentMode = .scaleAspectFit
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)

        webView.backgroundColor = .white
        webView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            // Prevent automatic safe-area insets from creating extra scroll space.
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        }

        view.addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(closeButton)
        view.addSubview(webView)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 56),

            closeButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            closeButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 32),
            closeButton.heightAnchor.constraint(equalToConstant: 32),

            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: headerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: closeButton.leadingAnchor, constant: -12),

            webView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        let request = URLRequest(url: url)
        webView.load(request)
    }

    @objc private func closeTapped() {
        dismiss(animated: true)
    }

    private func makeCloseIconImage() -> UIImage {
        let size = CGSize(width: 15, height: 15)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 14.781, y: 13.7198))
            path.addCurve(to: CGPoint(x: 14.9437, y: 13.9632),
                          controlPoint1: CGPoint(x: 14.8507, y: 13.7895),
                          controlPoint2: CGPoint(x: 14.906, y: 13.8722))
            path.addCurve(to: CGPoint(x: 15.0008, y: 14.2504),
                          controlPoint1: CGPoint(x: 14.9814, y: 14.0543),
                          controlPoint2: CGPoint(x: 15.0008, y: 14.1519))
            path.addCurve(to: CGPoint(x: 14.9437, y: 14.5376),
                          controlPoint1: CGPoint(x: 15.0008, y: 14.349),
                          controlPoint2: CGPoint(x: 14.9814, y: 14.4465))
            path.addCurve(to: CGPoint(x: 14.781, y: 14.781),
                          controlPoint1: CGPoint(x: 14.906, y: 14.6286),
                          controlPoint2: CGPoint(x: 14.8507, y: 14.7114))
            path.addCurve(to: CGPoint(x: 14.5376, y: 14.9437),
                          controlPoint1: CGPoint(x: 14.7114, y: 14.8507),
                          controlPoint2: CGPoint(x: 14.6286, y: 14.906))
            path.addCurve(to: CGPoint(x: 14.2504, y: 15.0008),
                          controlPoint1: CGPoint(x: 14.4465, y: 14.9814),
                          controlPoint2: CGPoint(x: 14.349, y: 15.0008))
            path.addCurve(to: CGPoint(x: 13.9632, y: 14.9437),
                          controlPoint1: CGPoint(x: 14.1519, y: 15.0008),
                          controlPoint2: CGPoint(x: 14.0543, y: 14.9814))
            path.addCurve(to: CGPoint(x: 13.7198, y: 14.781),
                          controlPoint1: CGPoint(x: 13.8722, y: 14.906),
                          controlPoint2: CGPoint(x: 13.7895, y: 14.8507))
            path.addLine(to: CGPoint(x: 7.50042, y: 8.56073))
            path.addLine(to: CGPoint(x: 1.28104, y: 14.781))
            path.addCurve(to: CGPoint(x: 0.750417, y: 15.0008),
                          controlPoint1: CGPoint(x: 1.14031, y: 14.9218),
                          controlPoint2: CGPoint(x: 0.94944, y: 15.0008))
            path.addCurve(to: CGPoint(x: 0.219792, y: 14.781),
                          controlPoint1: CGPoint(x: 0.551394, y: 15.0008),
                          controlPoint2: CGPoint(x: 0.360523, y: 14.9218))
            path.addCurve(to: CGPoint(x: 0, y: 14.2504),
                          controlPoint1: CGPoint(x: 0.0790615, y: 14.6403),
                          controlPoint2: CGPoint(x: 0, y: 14.4494))
            path.addCurve(to: CGPoint(x: 0.219792, y: 13.7198),
                          controlPoint1: CGPoint(x: 0, y: 14.0514),
                          controlPoint2: CGPoint(x: 0.0790615, y: 13.8605))
            path.addLine(to: CGPoint(x: 6.4401, y: 7.50042))
            path.addLine(to: CGPoint(x: 0.219792, y: 1.28104))
            path.addCurve(to: CGPoint(x: 0, y: 0.750417),
                          controlPoint1: CGPoint(x: 0.0790615, y: 1.14031),
                          controlPoint2: CGPoint(x: 0, y: 0.94944))
            path.addCurve(to: CGPoint(x: 0.219792, y: 0.219792),
                          controlPoint1: CGPoint(x: 0, y: 0.551394),
                          controlPoint2: CGPoint(x: 0.0790615, y: 0.360523))
            path.addCurve(to: CGPoint(x: 0.750417, y: 0),
                          controlPoint1: CGPoint(x: 0.360523, y: 0.0790615),
                          controlPoint2: CGPoint(x: 0.551394, y: 0))
            path.addCurve(to: CGPoint(x: 1.28104, y: 0.219792),
                          controlPoint1: CGPoint(x: 0.94944, y: 0),
                          controlPoint2: CGPoint(x: 1.14031, y: 0.0790615))
            path.addLine(to: CGPoint(x: 7.50042, y: 6.4401))
            path.addLine(to: CGPoint(x: 13.7198, y: 0.219792))
            path.addCurve(to: CGPoint(x: 14.2504, y: 0),
                          controlPoint1: CGPoint(x: 13.8605, y: 0.0790615),
                          controlPoint2: CGPoint(x: 14.0514, y: 0))
            path.addCurve(to: CGPoint(x: 14.781, y: 0.219792),
                          controlPoint1: CGPoint(x: 14.4494, y: 0),
                          controlPoint2: CGPoint(x: 14.6403, y: 0.0790615))
            path.addCurve(to: CGPoint(x: 15.0008, y: 0.750417),
                          controlPoint1: CGPoint(x: 14.9218, y: 0.360523),
                          controlPoint2: CGPoint(x: 15.0008, y: 0.551394))
            path.addCurve(to: CGPoint(x: 14.781, y: 1.28104),
                          controlPoint1: CGPoint(x: 15.0008, y: 0.94944),
                          controlPoint2: CGPoint(x: 14.9218, y: 1.14031))
            path.addLine(to: CGPoint(x: 8.56073, y: 7.50042))
            path.addLine(to: CGPoint(x: 14.781, y: 13.7198))
            path.close()

            UIColor(red: 36.0 / 255.0, green: 40.0 / 255.0, blue: 40.0 / 255.0, alpha: 1).setFill()
            path.fill()
        }
    }
}
