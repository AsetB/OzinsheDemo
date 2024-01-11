//
//  SearchViewController.swift
//  OzinsheDemo
//
//  Created by Aset Bakirov on 10.01.2024.
//

import UIKit
import Localize_Swift
import Alamofire
import SVProgressHUD
import SwiftyJSON

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
     
    @IBOutlet weak var searchTextfield: TextFieldWithPadding!
    @IBOutlet weak var collectionVIew: UICollectionView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewToLableConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewToCollectionViewConstraint: NSLayoutConstraint!
    
    var categories: [Category] = []
    
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        downloadCategories()
        hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureViews()
    }
    

    func configureViews() {
        collectionVIew.delegate = self
        collectionVIew.dataSource = self
        
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 16
        layout.estimatedItemSize.width = 100
        collectionVIew.collectionViewLayout = layout
        
        searchTextfield.padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        searchTextfield.layer.cornerRadius = 12
        searchTextfield.layer.borderWidth = 1
        searchTextfield.layer.borderColor = UIColor(red: 229/255, green: 235/255, blue: 240/255, alpha: 1.0).cgColor
        
        searchButton.layer.cornerRadius = 12
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let MovieCellnib = UINib(nibName: "MovieCell", bundle: nil)
        tableView.register(MovieCellnib, forCellReuseIdentifier: "MovieCell")
        
        navigationBar.title = "SEARCH".localized()
        topLabel.text = "CATEGORIES".localized()
        searchTextfield.placeholder = "SEARCH".localized()
    }
    
    @IBAction func searchTextfieldEditDidBegin(_ sender: TextFieldWithPadding) {
        sender.layer.borderColor = UIColor(red: 151/255, green: 83/255, blue: 240/255, alpha: 1.0).cgColor
    }
    @IBAction func searchTextfieldEditDidEnd(_ sender: TextFieldWithPadding) {
        sender.layer.borderColor = UIColor(red: 229/255, green: 235/255, blue: 240/255, alpha: 1.0).cgColor
    }
    @IBAction func textfieldDidChanged(_ sender: Any) {
            downloadSearchMovies()
    }
    
    @IBAction func clearSearchTextfield(_ sender: Any) {
        searchTextfield.text = ""
        downloadSearchMovies()
    }
    @IBAction func searchActButton(_ sender: Any) {
        downloadSearchMovies()
    }
    
    func downloadCategories() {
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(Storage.sharedInstance.accessToken)"]
        
        AF.request(URLs.CATEGORIES_URL, method: .get, headers: headers).responseData { response in
            
            SVProgressHUD.dismiss()
            
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                if let array = json.array {
                    for item in array {
                        let categories = Category(json: item)
                        self.categories.append(categories)
                    }
                    self.collectionVIew.reloadData()
                } else {
                    SVProgressHUD.showError(withStatus: "CONNECTION_ERROR")
                }
            } else {
                var ErrorString = "CONNECTION_ERROR"
                if let sCode = response.response?.statusCode {
                    ErrorString = ErrorString + " \(sCode)"
                }
                ErrorString = ErrorString + " \(resultString)"
                SVProgressHUD.showError(withStatus: "\(ErrorString)")
            }
        }
    }
    
    func downloadSearchMovies() {
        
        if searchTextfield.text!.isEmpty {
            topLabel.text = "CATEGORIES".localized()
            collectionVIew.isHidden = false
            tableViewToLableConstraint.priority = .defaultLow
            tableViewToCollectionViewConstraint.priority = .defaultHigh
            tableView.isHidden = true
            movies.removeAll()
            tableView.reloadData()
            clearButton.isHidden = true
            return
        } else {
            topLabel.text = "SEARCH_RESULTS".localized()
            collectionVIew.isHidden = true
            tableViewToLableConstraint.priority = .defaultHigh
            tableViewToCollectionViewConstraint.priority = .defaultLow
            tableView.isHidden = false
            clearButton.isHidden = false
        }
        
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(Storage.sharedInstance.accessToken)"]
        
        let parameters = ["search": searchTextfield.text!]
        
        AF.request(URLs.SEARCH_MOVIES_URL, method: .get, parameters: parameters, headers: headers).responseData { response in
            
            SVProgressHUD.dismiss()
            
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                if let array = json.array {
                    self.movies.removeAll()
                    self.tableView.reloadData()
                    for item in array {
                        let movie = Movie(json: item)
                        self.movies.append(movie)
                    }
                 self.tableView.reloadData()
                }
                    else {
                        SVProgressHUD.showError(withStatus: "CONNECTION_ERROR")
                    }
                } else {
                    var ErrorString = "CONNECTION_ERROR"
                    if let sCode = response.response?.statusCode {
                        ErrorString = ErrorString + " \(sCode)"
                    }
                    ErrorString = ErrorString + " \(resultString)"
                    SVProgressHUD.showError(withStatus: "\(ErrorString)")
                }
            }
        }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK: Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        let label = cell.viewWithTag(1001) as! UILabel
        label.text = categories[indexPath.row].name
        
        let backgroundView = cell.viewWithTag(1000)
        backgroundView?.layer.cornerRadius = 8
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let categoryTableViewController = storyboard?.instantiateViewController(withIdentifier: "CategoryTableViewController") as! CategoryTableViewController
        categoryTableViewController.categoryID = categories[indexPath.row].id
        categoryTableViewController.categoryName = categories[indexPath.row].name
        
        navigationController?.show(categoryTableViewController, sender: self)
    }
    
    //MARK: Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieTableViewCell
        
        cell.setData(movie: movies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 153
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }

            layoutAttribute.frame.origin.x = leftMargin

            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }

        return attributes
    }
}
