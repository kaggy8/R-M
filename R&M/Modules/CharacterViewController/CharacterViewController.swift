//
//  CharacterViewController.swift
//  R&M
//
//  Created by Stanislav Demyanov on 30.01.2023.
//

import UIKit
import Kingfisher

class CharacterViewController: UIViewController {
    // MARK: - Outlets
    
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var genderValueLabel: UILabel!
    @IBOutlet weak var genderView: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var typeValueLabel: UILabel!
    @IBOutlet weak var typeView: UIView!
    
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var speciesValueLabel: UILabel!
    @IBOutlet weak var speciesView: UIView!
    @IBOutlet weak var idView: UIView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var idValueLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusValueLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var charStackView: UIStackView!
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: - Public properties
    
    var characterAttributes: CharacterSet?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupText()
        setupUI()
        loadData()
    }
}

// MARK: - Extension for text setup

extension CharacterViewController {
    func setupText() {
        view.backgroundColor = .systemGreen
        nameLabel.text = characterAttributes?.name
        nameLabel.textColor = .black
        
        idLabel.text = "ID"
        idValueLabel.text = String(Int((characterAttributes?.id)!))
        
        statusLabel.text = "Status"
        statusValueLabel.text = characterAttributes?.status
        
        speciesLabel.text = "Species"
        speciesValueLabel.text = characterAttributes?.species
        
        typeLabel.text = "Type"
        if characterAttributes?.type == "" {
            typeValueLabel.text = "Unknown"
        } else {
            typeValueLabel.text = characterAttributes?.type
        }
        
        genderLabel.text = "Gender"
        genderValueLabel.text = characterAttributes?.gender
    }
}
// MARK: - Extension for elements setup

extension CharacterViewController {
    func setupUI() {
        characterImage.layer.cornerRadius = 20
        characterImage.layer.borderWidth = 1
        idView.backgroundColor = .systemMint
        statusView.backgroundColor = .white
        speciesView.backgroundColor = .systemYellow
        typeView.backgroundColor = .systemGray2
        genderView.backgroundColor = .systemPurple
        
        idView.layer.cornerRadius = 10
        statusView.layer.cornerRadius = 10
        speciesView.layer.cornerRadius = 10
        typeView.layer.cornerRadius = 10
        genderView.layer.cornerRadius = 10
        
        idView.layer.borderWidth = 1
        statusView.layer.borderWidth = 1
        speciesView.layer.borderWidth = 1
        typeView.layer.borderWidth = 1
        genderView.layer.borderWidth = 1
        
        idLabel.font = .systemFont(ofSize: 21)
        idLabel.textColor = .black
        idValueLabel.font = .systemFont(ofSize: 21)
        idValueLabel.textColor = .black
        
        statusLabel.font = .systemFont(ofSize: 21)
        statusLabel.textColor = .black
        statusValueLabel.font = .systemFont(ofSize: 21)
        statusValueLabel.textColor = .black
        
        speciesLabel.font = .systemFont(ofSize: 21)
        speciesLabel.textColor = .black
        speciesValueLabel.font = .systemFont(ofSize: 21)
        speciesValueLabel.textColor = .black
        
        typeLabel.font = .systemFont(ofSize: 21)
        typeLabel.textColor = .black
        typeValueLabel.font = .systemFont(ofSize: 21)
        typeValueLabel.textColor = .black
        
        genderLabel.font = .systemFont(ofSize: 21)
        genderLabel.textColor = .black
        genderValueLabel.font = .systemFont(ofSize: 21)
        genderValueLabel.textColor = .black
    }
}

// MARK: - Extension for load data

extension CharacterViewController {
    func loadData() {
        if let url = URL(string: characterAttributes?.image ?? "") {
            characterImage?.kf.indicatorType = .activity
            characterImage?.kf.setImage(with: url)
        }
        else {
            characterImage?.image = UIImage(systemName: "person.crop.circle.badge.exclamationmark")
        }
    }
}
