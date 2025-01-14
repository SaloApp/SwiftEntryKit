//
//  EKPopUpMessageView.swift
//  SwiftEntryKit
//
//  Created by Daniel Huri on 4/20/18.
//  Copyright (c) 2018 huri000@gmail.com. All rights reserved.
//

import UIKit
@available(iOSApplicationExtension, unavailable)
final public class EKPopUpMessageView: UIView {

    // MARK: - Properties
    
    private var imageView: UIImageView!
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let actionButton: EKButtonView
    
    private let message: EKPopUpMessage
    
    // MARK: - Setup

    public init(with message: EKPopUpMessage) {
        self.message = message
        self.actionButton = .init(content: message.button)
        super.init(frame: UIScreen.main.bounds)

        setupImageView()
        setupTitleLabel()
        setupDescriptionLabel()
        setupActionButton()
        setupInterfaceStyle()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImageView() {
        guard let themeImage = message.themeImage else {
            return
        }
        imageView = UIImageView()
        addSubview(imageView)
        imageView.layoutToSuperview(.centerX)
        switch themeImage.position {
        case .centerToTop(offset: let value):
            imageView.layout(.centerY, to: .top, of: self, offset: value)
        case .topToTop(offset: let value):
            imageView.layoutToSuperview(.top, offset: value)
        }
        imageView.imageContent = themeImage.image
    }
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.content = message.title
        titleLabel.layoutToSuperview(axis: .horizontally, offset: 30)
        if let imageView = imageView {
            titleLabel.layout(.top, to: .bottom, of: imageView, offset: 20)
        } else {
            titleLabel.layoutToSuperview(.top, offset: 20)
        }
        titleLabel.forceContentWrap(.vertically)
    }
    
    private func setupDescriptionLabel() {
        addSubview(descriptionLabel)
        descriptionLabel.content = message.description
        descriptionLabel.layoutToSuperview(axis: .horizontally, offset: 30)
        descriptionLabel.layout(.top, to: .bottom, of: titleLabel, offset: 16)
        descriptionLabel.forceContentWrap(.vertically)
    }
    
    private func setupActionButton() {
        addSubview(actionButton)
        let height: CGFloat = 45
        actionButton.set(.height, of: height)
        actionButton.layout(.top, to: .bottom, of: descriptionLabel, offset: 30)
        actionButton.layoutToSuperview(.bottom, offset: -30)
        actionButton.layoutToSuperview(.centerX)
    }
    
    private func setupInterfaceStyle() {
        titleLabel.textColor = message.title.style.color(for: traitCollection)
        imageView?.tintColor = message.themeImage?.image.tintColor(for: traitCollection)
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupInterfaceStyle()
    }
    
    // MARK: - User Interaction
    
    @objc func actionButtonPressed() {
        message.button.action?()
    }
}
