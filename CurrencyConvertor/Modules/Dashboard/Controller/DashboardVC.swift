//
//  DashboardVC.swift
//  CurrencyConvertor
//
//  Created by Anugrah on 14/08/24.
//

import UIKit
import Lottie

class DashboardVC: UIViewController {

    @IBOutlet weak var currencyCollectionView: UICollectionView!
    @IBOutlet weak var currencyTextF: UITextField!
    @IBOutlet weak var amtTextF: UITextField!
    private let viewModel = CurrencyConverterViewModel()
    private var animationView: LottieAnimationView?
    private var currencyCodes: [String] = []
    private var filteredCurrencyCodes: [String] = []
    private var conversions: [String: Double] = [:]
    private var currencyPicker: UIPickerView!
    private var toolbar: UIToolbar!
    private var emptyStateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Currency Convertor"
        navigationController?.navigationBar.prefersLargeTitles = true
        setupUI()
        setupCurrencyPicker()
        setupAmountTextField()
        loadCurrencyData()
        setupLottieAnimation()
    }
    

    private func setupLottieAnimation() {
      
        animationView = LottieAnimationView(name: "emptyState")
        animationView?.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        animationView?.center = CGPoint(x: currencyCollectionView.center.x, y: currencyCollectionView.center.y - 50)
        animationView?.contentMode = .scaleAspectFit
        animationView?.loopMode = .loop
        animationView?.isUserInteractionEnabled = false
        
        // Setup label
        emptyStateLabel = UILabel()
        emptyStateLabel.text = "Please enter Amount and currency type"
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.font = UIFont.systemFont(ofSize: 16)
        emptyStateLabel.textColor = .gray
        emptyStateLabel.frame = CGRect(x: 10, y: 0, width: 300, height: 50)
        emptyStateLabel.center = CGPoint(x: currencyCollectionView.center.x, y: animationView!.frame.maxY + 15)
        
        view.addSubview(animationView!)
        view.addSubview(emptyStateLabel)
        animationView?.isHidden = true
        emptyStateLabel.isHidden = true
        view.insertSubview(animationView!, belowSubview: currencyCollectionView)
        view.insertSubview(emptyStateLabel, belowSubview: currencyCollectionView)
    }


    
    private func setupUI() {
        currencyCollectionView.delegate = self
        currencyCollectionView.dataSource = self
        currencyTextF.delegate = self
        amtTextF.delegate = self
        amtTextF.keyboardType = .numberPad
    }
    
    private func setupCurrencyPicker() {

        currencyPicker = UIPickerView()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
        toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        currencyTextF.inputView = currencyPicker
        currencyTextF.inputAccessoryView = toolbar
    }

    private func setupAmountTextField() {

        toolbar = UIToolbar()
        toolbar.sizeToFit()

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        amtTextF.inputAccessoryView = toolbar
    }

    private func loadCurrencyData() {
        viewModel.fetchRatesIfNeeded { [weak self] success in
            guard success else {
           // Handle Error
                return
            }
            DispatchQueue.main.async {
                self?.currencyCodes = Array(self?.viewModel.currencyRates.keys ?? ["": 0.0].keys)
                self?.currencyPicker.reloadAllComponents()
            }
        }
    }
    
    @objc private func donePressed() {
        if currencyTextF.isFirstResponder {
            let selectedRow = currencyPicker.selectedRow(inComponent: 0)
            let selectedCurrency = currencyCodes[selectedRow]
            
            guard let amountText = amtTextF.text, !amountText.isEmpty, let amount = Double(amountText), amount > 0 else {
                showAlert(title: "Invalid Input", message: "Please enter a valid amount.")
                return
            }
            
    
            if let selectedCurrency = currencyTextF.text, !selectedCurrency.isEmpty {
                conversions = viewModel.convert(amount: amount, from: selectedCurrency)
                currencyCollectionView.reloadData()
            }
            currencyTextF.text = selectedCurrency
            currencyTextF.resignFirstResponder()
        }
        
        if amtTextF.isFirstResponder {

            amtTextF.resignFirstResponder()
        }
    }


    @objc private func cancelPressed() {
        if currencyTextF.isFirstResponder {
//            currencyTextF.text = ""
            currencyTextF.resignFirstResponder()
        }
        
        if amtTextF.isFirstResponder {
//            amtTextF.text = ""
            amtTextF.resignFirstResponder()
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}


// MARK: PickerView Delegate DataSource
extension DashboardVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyCodes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyCodes[row]
    }
}

// MARK: CollectionView Delegate DataSource
extension DashboardVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = conversions.count
        if count == 0 {
            emptyStateLabel.isHidden = false
            animationView?.isHidden = false
            animationView?.play()
        } else {
            emptyStateLabel.isHidden = true
            animationView?.isHidden = true
            animationView?.stop()
        }
        return count
    }


    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CurrencyCell", for: indexPath) as! CurrencyCell
        
        let currency = Array(conversions.keys)[indexPath.item]
        let amount = conversions[currency] ?? 0.0
        
        cell.currencyName.text = currency
        cell.amountLabel.text = String(format: "%.2f", amount)
        cell.setUp()

        animationView?.isHidden = true
        animationView?.stop()
        
        return cell
    }


    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = currencyCollectionView.frame.width/3 - 10
        let height = 100.0
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: TextField Delegate DataSource

extension DashboardVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == currencyTextF {
            if currencyTextF.text?.isEmpty ?? true, currencyCodes.count > 0 {
                currencyTextF.text = currencyCodes[0]
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

