//
//  FSPagerViewCell.swift
//  FSPagerView
//
//  Created by Wenchao Ding on 17/12/2016.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//

import UIKit
import Combine

open class FSPagerViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private var subscriptions = Set<AnyCancellable>()
    
    private let selectionColor = UIColor(white: 0.2, alpha: 0.2)
    private weak var selectedForegroundView: UIView?
    
    // MARK: - Public Properties
    
    @objc
    open var textLabel: UILabel? {
        if let existingLabel = _textLabel {
            return existingLabel
        }
        
        let containerView = UIView(frame: .zero)
        containerView.isUserInteractionEnabled = false
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        let textLabel = UILabel(frame: .zero)
        textLabel.textColor = .white
        textLabel.font = UIFont.preferredFont(forTextStyle: .body)
        
        self.contentView.addSubview(containerView)
        containerView.addSubview(textLabel)
        
        textLabel.publisher(for: \.font)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.setNeedsLayout()
            }
            .store(in: &subscriptions)
        
        _textLabel = textLabel
        return textLabel
    }
    
    @objc
    open var imageView: UIImageView? {
        if let existingImageView = _imageView {
            return existingImageView
        }
        let imageView = UIImageView(frame: .zero)
        self.contentView.addSubview(imageView)
        _imageView = imageView
        
        // 이미지뷰가 생성될 때 선택 오버레이도 함께 설정
        let overlayView = UIView(frame: imageView.bounds)
        overlayView.layer.backgroundColor = UIColor.clear.cgColor
        imageView.addSubview(overlayView)
        selectedForegroundView = overlayView
        
        return imageView
    }
    
    // MARK: - Private Properties
    
    private weak var _textLabel: UILabel?
    private weak var _imageView: UIImageView?
    
    // MARK: - Selection Handling
    
    open override var isHighlighted: Bool {
        didSet {
            updateSelectionState()
        }
    }
    
    open override var isSelected: Bool {
        didSet {
            updateSelectionState()
        }
    }
    
    private func updateSelectionState() {
        let shouldShowSelection = isHighlighted || isSelected
        selectedForegroundView?.layer.backgroundColor = shouldShowSelection ? selectionColor.cgColor : UIColor.clear.cgColor
    }
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowRadius = 5
        contentView.layer.shadowOpacity = 0.75
        contentView.layer.shadowOffset = .zero
    }
    
    // MARK: - Layout
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        // ImageView layout
        _imageView?.frame = contentView.bounds
        selectedForegroundView?.frame = contentView.bounds
        
        // TextLabel layout
        if let textLabel = _textLabel {
            let containerView = textLabel.superview!
            
            // Container view layout
            let labelHeight = textLabel.font.pointSize * 1.5
            containerView.frame = CGRect(
                x: 0,
                y: contentView.frame.height - labelHeight,
                width: contentView.frame.width,
                height: labelHeight
            )
            
            // Label layout
            textLabel.frame = containerView.bounds.insetBy(dx: 8, dy: 1)
        }
    }
    
    // MARK: - Cleanup
    
    deinit {
        subscriptions.removeAll()
    }
}

