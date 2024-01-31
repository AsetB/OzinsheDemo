//
//  OnboardingViewController.swift
//  OzinsheDemo
//
//  Created by Aset Bakirov on 24.01.2024.
//

import UIKit

class OnboardingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: CustomPageControl!
    
    var arraySlides = [["firstSlide", "ÖZINŞE-ге қош келдің!", "Фильмдер, телехикаялар, ситкомдар, анимациялық жобалар, телебағдарламалар мен реалити-шоулар, аниме және тағы басқалары"],
                       ["secondSlide", "ÖZINŞE-ге қош келдің!", "Кез келген құрылғыдан қара\nСүйікті фильміңді  қосымша төлемсіз телефоннан, планшеттен, ноутбуктан қара"],
                       ["thirdSlide", "ÖZINŞE-ге қош келдің!", "Тіркелу оңай. Қазір тіркел де қалаған фильміңе қол жеткіз"]]
    
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.title = " "
    }
    
    @objc func buttonNext() {
        let signInVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
        navigationController?.show(signInVC!, sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Collection view
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arraySlides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        let imageView = cell.viewWithTag(1000) as! UIImageView
        imageView.image = UIImage(named: arraySlides[indexPath.row][0])
        
        let titleLabel = cell.viewWithTag(1001) as! UILabel
        titleLabel.text = arraySlides[indexPath.row][1]
        
        let descriptionLabel = cell.viewWithTag(1002) as! UILabel
        descriptionLabel.text = arraySlides[indexPath.row][2]
        
        let buttonTop = cell.viewWithTag(1003) as! UIButton
        buttonTop.layer.cornerRadius = 8
        if indexPath.row == 2 {
            buttonTop.isHidden = true
        }
        buttonTop.addTarget(self, action: #selector(buttonNext), for: .touchUpInside)
        
        let buttonLarge = cell.viewWithTag(1004) as! UIButton
        buttonLarge.layer.cornerRadius = 12
        if indexPath.row != 2 {
            buttonLarge.isHidden = true
        }
        buttonLarge.addTarget(self, action: #selector(buttonNext), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
        pageControl.setIndicatorImage(UIImage(named: "RectanglePC"), forPage: currentPage)
        for i in 0..<pageControl.numberOfPages {
            if i != pageControl.currentPage {
                pageControl.setIndicatorImage(nil, forPage: i)
            }
        }
    }
    
    

}
