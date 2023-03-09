//
//  MainViewController.swift
//  Weather1
//
//  Created by Burak Erden on 11.01.2023.
//

import UIKit

class MainViewController: UIViewController {
    
    var viewModel = MainViewModel()
    
    let hPageCities = ["Istanbul": "lat=41.00&lon=28.57", "Izmir": "lat=38.43&lon=27.15", "Bursa": "lat=40.19&lon=29.06", "Ankara": "lat=39.52&lon=32.51"]
    
    let currentDate = Date()
    let formatter = DateFormatter()
    let coordService = CoordService()
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        
        if nameTextField.text != "" {
            getCoordData(cityName: nameTextField.text!.replacingOccurrences(of: " ", with: "+"))
        } else {
            nameTextField.placeholder = "Search field can't be empty"
        }
    }
    
    func setupUI() {
        nameTextField.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
        mainCollectionView.register(UINib(nibName: "MainCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MainCollectionViewCell")
        gestureRecognizer()
        date()
        navigationController?.navigationBar.tintColor = .black
        navigationItem.backButtonTitle = ""
        nameTextField.returnKeyType = .search
    }
    
    func date() {
        formatter.dateStyle = .full
        let result = formatter.string(from: currentDate)
        dateLabel.text = result
    }
    
    //MARK: - Get Data
    
    func getCoordData(cityName: String) {
        coordService.getCoordData(cityName: cityName) { result in
            guard let cName = result else {return}
            if cName.count == 0 {
                self.needAlert(title: "Error", message: "Enter valid city name.")
            } else {
                let vc = DetailViewController()
                vc.cityName = cityName
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } onError: { error in
            print(error)
        }
    }
    
    //MARK: - Alert

    func needAlert(title: String, message: String?) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}

//MARK: - Text Field

extension MainViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        nameTextField.text = ""
        nameTextField.placeholder = "Type city name"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if nameTextField.text != "" {
            getCoordData(cityName: nameTextField.text!.replacingOccurrences(of: " ", with: "+"))
        } else {
            nameTextField.placeholder = "Search field can't be empty"
        }
        return true
    }
}

//MARK: - Tap Gesture

extension MainViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    @objc func handleTapGesture(_ sender: UITapGestureRecognizer) {
        
        if sender.state == .ended {
            view.endEditing(true)
            let tapLocation = sender.location(in: mainCollectionView)
            if let tappedIndexPath = mainCollectionView.indexPathForItem(at: tapLocation) {
                mainCollectionView.selectItem(at: tappedIndexPath, animated: true, scrollPosition: .top)
                mainCollectionView.delegate?.collectionView?(mainCollectionView, didSelectItemAt: tappedIndexPath)
            }
        }
    }
}

//MARK: - Collection View

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        hPageCities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: MainCollectionViewCell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as? MainCollectionViewCell else {return UICollectionViewCell()}
        cell.cellName.text = Array(hPageCities)[indexPath.row].key
        viewModel.cities(coordinate: Array(hPageCities)[indexPath.row].value, image: cell.cellImage, condition: cell.cellCondition)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        getCoordData(cityName: Array(hPageCities)[indexPath.row].key)
    }
    
    
}






