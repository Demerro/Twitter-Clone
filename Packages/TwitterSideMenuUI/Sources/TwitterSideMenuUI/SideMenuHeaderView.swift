import UIKit

final class SideMenuHeaderView: UICollectionReusableView {
    
    let imageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "ProfileImageTemplate", in: .module, with: nil)
        $0.clipsToBounds = true
        $0.layer.cornerCurve = .continuous
        return $0
    }(UIImageView(frame: .zero))
    
    let nameLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Nikita"
        $0.font = .preferredFont(forTextStyle: .body, compatibleWith: UITraitCollection(legibilityWeight: .bold))
        return $0
    }(UILabel(frame: .zero))
    
    let nicknameLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "@DEM3RRO"
        $0.textColor = .secondaryLabel
        $0.font = .preferredFont(forTextStyle: .subheadline)
        return $0
    }(UILabel(frame: .zero))
    
    let followingLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel(frame: .zero))
    
    let followersLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return $0
    }(UILabel(frame: .zero))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCommon()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        RunLoop.current.add(Timer(timeInterval: 0.0, repeats: false, block: { [imageView] _ in
            MainActor.assumeIsolated {
                imageView.layer.cornerRadius = imageView.frame.width / 2.0
            }
        }), forMode: .common)
    }
}

extension SideMenuHeaderView {
    
    private func setupCommon() {
        backgroundColor = .secondarySystemGroupedBackground
        
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(nicknameLabel)
        addSubview(followingLabel)
        addSubview(followersLabel)
        
        followingLabel.attributedText = NSAttributedString(makeInformationString(number: 216, text: "Following"))
        followersLabel.attributedText = NSAttributedString(makeInformationString(number: 117, text: "Followers"))
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 55.0),
            imageView.heightAnchor.constraint(equalToConstant: 55.0),
            imageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            
            nameLabel.topAnchor.constraint(equalToSystemSpacingBelow: imageView.bottomAnchor, multiplier: 1.0),
            nameLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            
            nicknameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            nicknameLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            
            followingLabel.topAnchor.constraint(equalToSystemSpacingBelow: nicknameLabel.bottomAnchor, multiplier: 2.0),
            followingLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            
            followersLabel.topAnchor.constraint(equalToSystemSpacingBelow: nicknameLabel.bottomAnchor, multiplier: 2.0),
            followersLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: followingLabel.trailingAnchor, multiplier: 1.0),
            layoutMarginsGuide.trailingAnchor.constraint(greaterThanOrEqualTo: followersLabel.trailingAnchor),
            bottomAnchor.constraint(equalToSystemSpacingBelow: followersLabel.bottomAnchor, multiplier: 2.0),
        ])
    }
}

extension SideMenuHeaderView {
    
    private func makeInformationString(number: Int, text: String) -> AttributedString {
        let numberString = AttributedString(String(number))
        var textString = AttributedString(text)
        textString.foregroundColor = .secondaryLabel
        return numberString + " " + textString
    }
}
