//
//  ViewController.swift
//  Crypto-exchange
//
//  Created by Даниил Симахин on 18.05.2022.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    
    var coinManager = CoinManager()
    var selectBaseCurrency = 0
    var selectQuoteCurrency = 0
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Сryptocurrency exchange"
        label.font = .italicSystemFont(ofSize: 45)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let backgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 40
        view.backgroundColor = .systemGray.withAlphaComponent(0.6)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let currencyPriceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.contentMode = .scaleToFill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let currencyPriceImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "USD")
        imageView.tintColor = .white
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let currencyPriceLabel: UILabel = {
        let label = UILabel()
        label.contentMode = .left
        label.text = "..."
        label.font = .systemFont(ofSize: 30, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.contentMode = .center
        label.text = "AUD"
        label.font = .systemFont(ofSize: 30, weight: .regular)
        label.numberOfLines = 1
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let updateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Update", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 25
        button.titleLabel?.font = .systemFont(ofSize: 25, weight: .regular)
        button.backgroundColor = .systemGray.withAlphaComponent(0.6)
        button.addTarget(self, action: #selector(updateButtonPressed(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let pickerCurrency: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0xF7/0xFF, green: 0xB2/0xFF, blue: 0x67/0xFF, alpha: 0xFF)
        
        setupUI()
        coinManager.delegate = self
        pickerCurrency.delegate = self
        pickerCurrency.dataSource = self
        coinManager.performRequest(base: coinManager.currencyBase[selectBaseCurrency], quote: coinManager.currencyQuote[selectQuoteCurrency])
    }

    func setupUI() {
        view.addSubview(label)
        view.addSubview(pickerCurrency)
        view.addSubview(backgroundView)
        view.addSubview(updateButton)
        backgroundView.addSubview(currencyPriceStackView)
        currencyPriceStackView.addArrangedSubview(currencyPriceImageView)
        currencyPriceStackView.addArrangedSubview(currencyPriceLabel)
        currencyPriceStackView.addArrangedSubview(currencyLabel)
        
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 120),
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            
            backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            backgroundView.heightAnchor.constraint(equalTo: currencyPriceStackView.heightAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: currencyPriceStackView.trailingAnchor, constant: 10),
            backgroundView.leadingAnchor.constraint(equalTo: currencyPriceStackView.leadingAnchor),
            
            currencyPriceStackView.heightAnchor.constraint(equalToConstant: 80),
            
            currencyPriceImageView.widthAnchor.constraint(equalToConstant: 80),
            currencyPriceImageView.topAnchor.constraint(equalTo: currencyPriceStackView.topAnchor),
            currencyPriceImageView.bottomAnchor.constraint(equalTo: currencyPriceStackView.bottomAnchor),

            pickerCurrency.heightAnchor.constraint(lessThanOrEqualToConstant: 200),
            pickerCurrency.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            pickerCurrency.bottomAnchor.constraint(equalTo: updateButton.topAnchor, constant: -20),
            pickerCurrency.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            
            updateButton.heightAnchor.constraint(equalToConstant: 50),
            updateButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            updateButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            updateButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
        ])
    }
    
    @objc func updateButtonPressed(_ sender: UIButton) {
        coinManager.performRequest(base: coinManager.currencyBase[selectBaseCurrency], quote: coinManager.currencyQuote[selectQuoteCurrency])
    }
}

//MARK: - UIPickerViewDelegate

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return coinManager.currencyBase[row]
        case 1:
            return coinManager.currencyQuote[row]
        default:
            return "Data lost"
        }
    }
}

//MARK: - UIPickerViewDataSource

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return coinManager.currencyBase.count
        } else {
            return coinManager.currencyQuote.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(row)
        switch component {
        case 0:
            selectBaseCurrency = row
        case 1:
            selectQuoteCurrency = row
        default:
            print("asd")
        }
        coinManager.performRequest(base: coinManager.currencyBase[selectBaseCurrency], quote: coinManager.currencyQuote[selectQuoteCurrency])
    }
}

//MARK: - CoinManagerDelegate

extension ViewController: CoinManagerDelegate {
    func didUpdateCurrencyPrice(price: String, currencyBase: String, currencyQuote: String) {
        DispatchQueue.main.async {
            self.currencyPriceImageView.image = UIImage(named: currencyBase)
            self.currencyPriceLabel.text = price
            self.currencyLabel.text = currencyQuote
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - SwiftUIController

struct SwiftUIController: UIViewControllerRepresentable {
    typealias UIViewControllerType = ViewController
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        let viewController = UIViewControllerType()
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

struct SwiftUIController_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIController().edgesIgnoringSafeArea(.all).previewInterfaceOrientation(.portrait)
    }
}

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
