//
//  EKButtonView.swift
//  SwiftEntryKit
//
//  Created by Daniel Huri on 12/8/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
@available(iOSApplicationExtension, unavailable)
final class EKButtonView: UIView {

    // MARK: - Properties
    
    private let button = UIButton()
    private let titleLabel = UILabel()
    private let backgroundView = EKBackgroundView()

    private let content: EKProperty.ButtonContent
    
    // MARK: - Setup
    
    init(content: EKProperty.ButtonContent) {
        self.content = content
        super.init(frame: .zero)
        setupTitleLabel()
        setupButton()
        setupAcceessibility()
        setupInterfaceStyle()
        setupBackgroundView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAcceessibility() {
        isAccessibilityElement = false
        button.isAccessibilityElement = true
        button.accessibilityIdentifier = content.accessibilityIdentifier
        button.accessibilityLabel = content.label.text
    }
    
    private func setupButton() {
        addSubview(button)
        button.fillSuperview(priority: .defaultLow)

        widthAnchor.constraint(equalTo: button.widthAnchor, constant: content.contentEdgeInset).isActive = true
        button.addTarget(self, action: #selector(buttonTouchUp),
                         for: [.touchUpInside, .touchUpOutside, .touchCancel])
        button.addTarget(self, action: #selector(buttonTouchDown),
                         for: .touchDown)
        button.addTarget(self, action: #selector(buttonTouchUpInside),
                         for: .touchUpInside)
    }

    private func setupBackgroundView() {
        backgroundView.style = .init(background: content.backgroundStyle,
                                     displayMode: .inferred)

        insertSubview(backgroundView, at: 0)
        backgroundView.fillSuperview()
    }
    
    private func setupTitleLabel() {
        titleLabel.numberOfLines = content.label.style.numberOfLines
        titleLabel.font = content.label.style.font
        titleLabel.text = content.label.text
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byWordWrapping
        addSubview(titleLabel)
        titleLabel.layoutToSuperview(axis: .horizontally,
                                     offset: 0)
        titleLabel.layoutToSuperview(axis: .vertically,
                                     offset: 0)
    }
    
    private func setBackground(by content: EKProperty.ButtonContent,
                               isHighlighted: Bool) {
        backgroundView.style = .init(background: content.backgroundStyle,
                                     displayMode: .inferred)
    }
    
    private func setupInterfaceStyle() {
        titleLabel.textColor = content.label.style.color(for: traitCollection)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        backgroundView.layer.cornerRadius = content.cornerRadius
        backgroundView.layer.masksToBounds = true
    }
    // MARK: - Selectors
    
    @objc func buttonTouchUpInside() {
        content.action?()
    }
    
    @objc func buttonTouchDown() {
        setBackground(by: content, isHighlighted: true)
    }
    
    @objc func buttonTouchUp() {
        setBackground(by: content, isHighlighted: false)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupInterfaceStyle()
    }
}
