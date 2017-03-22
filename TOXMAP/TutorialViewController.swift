//
//  TutorialViewController.swift
//  TOXMAP
//
//  Created by Sanjay Shrestha on 3/21/17.
//  Copyright © 2017 NIH. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController, UIScrollViewDelegate {

    
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet var startButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //1
        self.scrollView.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:self.view.frame.height)
        let scrollViewWidth:CGFloat = self.scrollView.frame.width
        let scrollViewHeight:CGFloat = self.scrollView.frame.height
        //2
        self.startButton.alpha = 0
        self.startButton.layer.cornerRadius = 8.0
        //3
        let imgOne = UIImageView(frame: CGRect(x:0, y:0,width:scrollViewWidth, height:scrollViewHeight-self.bottomView.frame.height))
        imgOne.image = UIImage(named: "1")
        let imgTwo = UIImageView(frame: CGRect(x:scrollViewWidth, y:0,width:scrollViewWidth, height:scrollViewHeight-self.bottomView.frame.height))
        imgTwo.image = UIImage(named: "2")
        let imgThree = UIImageView(frame: CGRect(x:scrollViewWidth*2, y:0,width:scrollViewWidth, height:scrollViewHeight-self.bottomView.frame.height))
        imgThree.image = UIImage(named: "3")
        let imgFour = UIImageView(frame: CGRect(x:scrollViewWidth*3, y:0,width:scrollViewWidth, height:scrollViewHeight-self.bottomView.frame.height))
        imgFour.image = UIImage(named: "4")
        imgOne.contentMode = .scaleAspectFit
        imgTwo.contentMode = .scaleAspectFit
        imgThree.contentMode = .scaleAspectFit
        imgFour.contentMode = .scaleAspectFit
        
        self.scrollView.addSubview(imgOne)
        self.scrollView.addSubview(imgTwo)
        self.scrollView.addSubview(imgThree)
        self.scrollView.addSubview(imgFour)
        //4
        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.width * 4, height:self.scrollView.frame.height)
        self.scrollView.delegate = self
        self.pageControl.currentPage = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UIScrollView Delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pageControl.currentPage = Int(currentPage);
        // Change the text accordingly
        if Int(currentPage) == 0{
            textLabel.text = "Welcome"
        }else if Int(currentPage) == 1{
            startButton.setTitle("Next", for: .normal)
        
            textLabel.text = "Explore"
        }else if Int(currentPage) == 2{
            startButton.setTitle("Next", for: .normal)

            textLabel.text = "Search"
        }else{
             startButton.setTitle("Let's get Start", for: .normal)
            textLabel.text = "More Info"
            UIView.animate(withDuration: 1.0, animations: { () -> Void in
                self.startButton.alpha = 1.0
            })
        }
    }
    @IBAction func nextPressed(_ sender: Any) {
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pageControl.currentPage = Int(currentPage);
        // Change the text accordingly
        if Int(currentPage) == 0{
            print("Welcome")
        }else if Int(currentPage) == 1{
            print("Explore")
        }else if Int(currentPage) == 2{
            print("Search")
        }else{
            print("More Info")
            performSegue(withIdentifier: "goHome", sender: nil)
        }

    }
    
}
