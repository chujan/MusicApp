//
//  playerControlsView.swift
//  MusicApp
//
//  Created by Jennifer Chukwuemeka on 06/10/2022.
//

import Foundation
import UIKit

protocol PlayerControlsViewDelegate: AnyObject{
    func playerControlsViewDidTapPlayPauseButton(_ playerControlsView: PlayControlsView)
    func playerControlsViewDidTapForwardButton(_ playerControlsView: PlayControlsView)
    func playerControlsViewDidTapBackwardsButton(_ playerControlsView: PlayControlsView)
    func playerControlsView(_ playerControlsView: PlayControlsView, didSlideSlider value: Float)
}


struct PlayerControllersViewModel {
    let title: String?
    let subtitle: String?
}


final class PlayControlsView: UIView {
    
    private var isPlaying = true
    
    
    
    
    weak var delegate: PlayerControlsViewDelegate?
    
    private let volumeSlider: UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        return slider
        
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "This is my song"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
        
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Drake (feat .some other artist)"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textColor = .secondaryLabel
        return label
        
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "backward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        return button
        
    }()
    
    private let forwardButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "forward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        return button
        
    }()
    
    private let playPauseButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "pause.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        return button
        
    }()
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(nameLabel)
        addSubview(subtitleLabel)
        addSubview(volumeSlider)
        addSubview(backButton)
        addSubview(forwardButton)
        addSubview(playPauseButton)
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didTapForward), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        
        volumeSlider.addTarget(self, action: #selector(didSlideSlider(_:)), for: .valueChanged)
       
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc func didSlideSlider(_ slider: UISlider) {
        let value = slider.value
        delegate?.playerControlsView(self, didSlideSlider: value)
        
    }
    
    @objc  func  didTapBack() {
        delegate?.playerControlsViewDidTapBackwardsButton(self)
    }
    @objc func  didTapForward() {
        delegate?.playerControlsViewDidTapForwardButton(self)
        
    }
    
    @objc func  didTapPlayPause() {
        self.isPlaying = !isPlaying
        delegate?.playerControlsViewDidTapPlayPauseButton(self)
        let pause = UIImage(systemName: "pause.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        let play = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        playPauseButton.setImage(isPlaying ? pause : play, for: .normal)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.frame = CGRect(x: 0, y: 0, width: width, height: 20)
        subtitleLabel.frame = CGRect(x: 0, y: nameLabel.bottom+10, width: width, height: 20)
        volumeSlider.frame = CGRect(x: 10, y: subtitleLabel.bottom+20, width: width-20, height: 40)
        let buttonSize: CGFloat = 60
        playPauseButton.frame = CGRect(x: (width - buttonSize)/2, y: volumeSlider.bottom + 30, width: buttonSize, height: buttonSize)
        backButton.frame = CGRect(x: playPauseButton.left - 80-buttonSize, y: playPauseButton.top, width: buttonSize, height: buttonSize)
        forwardButton.frame = CGRect(x: playPauseButton.right+80, y: playPauseButton.top, width: buttonSize, height: buttonSize)
    }
    func configure(with viewModel: PlayerControllersViewModel) {
        nameLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        
        
        
        
    }
}
