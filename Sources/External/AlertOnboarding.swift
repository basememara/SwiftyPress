//
//  AlertOnboarding.swift
//  AlertOnboarding
//
//  Created by Philippe on 26/09/2016.
//  Copyright © 2016 CookMinute. All rights reserved.
//

import UIKit

public protocol AlertOnboardingDelegate {
    func alertOnboardingSkipped(_ currentStep: Int, maxStep: Int)
    func alertOnboardingCompleted()
    func alertOnboardingNext(_ nextStep: Int)
}

open class AlertOnboarding: UIView, AlertPageViewDelegate {
    
    //FOR DATA  ------------------------
    fileprivate var arrayOfImage = [String]()
    fileprivate var arrayOfTitle = [String]()
    fileprivate var arrayOfDescription = [String]()
    
    //FOR DESIGN    ------------------------
    open var buttonBottom: UIButton!
    fileprivate var container: AlertPageViewController!
    open var background: UIView!
    
    
    //PUBLIC VARS   ------------------------
    open var colorForAlertViewBackground: UIColor = UIColor.white
    
    open var colorButtonBottomBackground: UIColor = UIColor(red: 226/255, green: 237/255, blue: 248/255, alpha: 1.0)
    open var colorButtonText: UIColor = UIColor(red: 118/255, green: 125/255, blue: 152/255, alpha: 1.0)
    
    open var colorTitleLabel: UIColor = UIColor(red: 171/255, green: 177/255, blue: 196/255, alpha: 1.0)
    open var colorDescriptionLabel: UIColor = UIColor(red: 171/255, green: 177/255, blue: 196/255, alpha: 1.0)
    
    open var colorPageIndicator = UIColor(red: 171/255, green: 177/255, blue: 196/255, alpha: 1.0)
    open var colorCurrentPageIndicator = UIColor(red: 118/255, green: 125/255, blue: 152/255, alpha: 1.0)
    
    open var heightForAlertView: CGFloat!
    open var widthForAlertView: CGFloat!
    
    open var percentageRatioHeight: CGFloat = 0.8
    open var percentageRatioWidth: CGFloat = 0.8
    
    open var titleSkipButton = "SKIP"
    open var titleGotItButton = "GOT IT !"
    
    open var delegate: AlertOnboardingDelegate?
    
    
    public init (arrayOfImage: [String], arrayOfTitle: [String], arrayOfDescription: [String]) {
        super.init(frame: CGRect(x: 0,y: 0,width: 0,height: 0))
        self.configure(arrayOfImage, arrayOfTitle: arrayOfTitle, arrayOfDescription: arrayOfDescription)
        self.arrayOfImage = arrayOfImage
        self.arrayOfTitle = arrayOfTitle
        self.arrayOfDescription = arrayOfDescription
        
        self.interceptOrientationChange()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //-----------------------------------------------------------------------------------------
    // MARK: PUBLIC FUNCTIONS    --------------------------------------------------------------
    //-----------------------------------------------------------------------------------------
    
    open func show() {
        
        //Update Color
        self.buttonBottom.backgroundColor = colorButtonBottomBackground
        self.backgroundColor = colorForAlertViewBackground
        self.buttonBottom.setTitleColor(colorButtonText, for: UIControlState())
        self.buttonBottom.setTitle(self.titleSkipButton, for: UIControlState())
        
        self.container = AlertPageViewController(arrayOfImage: arrayOfImage, arrayOfTitle: arrayOfTitle, arrayOfDescription: arrayOfDescription, alertView: self)
        self.container.delegate = self
        self.insertSubview(self.container.view, aboveSubview: self)
        self.insertSubview(self.buttonBottom, aboveSubview: self)
        
        // Only show once
        if self.superview != nil {
            return
        }
        
        // Find current stop viewcontroller
        if let topController = getTopViewController() {
            let superView: UIView = topController.view
            superView.addSubview(self.background)
            superView.addSubview(self)
            self.configureConstraints(topController.view)
            self.animateForOpening()
        }
    }
    
    //Hide onboarding with animation
    open func hide(){
        self.checkIfOnboardingWasSkipped()
        DispatchQueue.main.async { () -> Void in
            self.animateForEnding()
        }
    }
    
    
    //------------------------------------------------------------------------------------------
    // MARK: PRIVATE FUNCTIONS    --------------------------------------------------------------
    //------------------------------------------------------------------------------------------
    
    //MARK: Check if onboarding was skipped
    fileprivate func checkIfOnboardingWasSkipped(){
        let currentStep = self.container.currentStep
        if currentStep < (self.container.arrayOfImage.count - 1) && !self.container.isCompleted{
            self.delegate?.alertOnboardingSkipped(currentStep, maxStep: self.container.maxStep)
        }
        else {
            self.delegate?.alertOnboardingCompleted()
        }
    }
    
    
    //MARK: FOR CONFIGURATION    --------------------------------------
    fileprivate func configure(_ arrayOfImage: [String], arrayOfTitle: [String], arrayOfDescription: [String]) {
        
        self.buttonBottom = UIButton(frame: CGRect(x: 0,y: 0, width: 0, height: 0))
        self.buttonBottom.titleLabel?.font = UIFont(name: "Avenir-Black", size: 15)
        self.buttonBottom.addTarget(self, action: #selector(AlertOnboarding.onClick), for: .touchUpInside)
        
        self.background = UIView(frame: CGRect(x: 0,y: 0, width: 0, height: 0))
        self.background.backgroundColor = UIColor.black
        self.background.alpha = 0.5
        
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
    }
    
    
    fileprivate func configureConstraints(_ superView: UIView) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.buttonBottom.translatesAutoresizingMaskIntoConstraints = false
        self.container.view.translatesAutoresizingMaskIntoConstraints = false
        self.background.translatesAutoresizingMaskIntoConstraints = false
        
        self.removeConstraints(self.constraints)
        self.buttonBottom.removeConstraints(self.buttonBottom.constraints)
        self.container.view.removeConstraints(self.container.view.constraints)
        
        heightForAlertView = UIScreen.main.bounds.height*percentageRatioHeight
        widthForAlertView = UIScreen.main.bounds.width*percentageRatioWidth
        
        //Constraints for alertview
        let horizontalContraintsAlertView = NSLayoutConstraint(item: self, attribute: .centerXWithinMargins, relatedBy: .equal, toItem: superView, attribute: .centerXWithinMargins, multiplier: 1.0, constant: 0)
        let verticalContraintsAlertView = NSLayoutConstraint(item: self, attribute:.centerYWithinMargins, relatedBy: .equal, toItem: superView, attribute: .centerYWithinMargins, multiplier: 1.0, constant: 0)
        let heightConstraintForAlertView = NSLayoutConstraint.init(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: heightForAlertView)
        let widthConstraintForAlertView = NSLayoutConstraint.init(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: widthForAlertView)
        
        //Constraints for button
        let verticalContraintsButtonBottom = NSLayoutConstraint(item: self.buttonBottom, attribute:.centerXWithinMargins, relatedBy: .equal, toItem: self, attribute: .centerXWithinMargins, multiplier: 1.0, constant: 0)
        let heightConstraintForButtonBottom = NSLayoutConstraint.init(item: self.buttonBottom, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: heightForAlertView*0.1)
        let widthConstraintForButtonBottom = NSLayoutConstraint.init(item: self.buttonBottom, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: widthForAlertView)
        let pinContraintsButtonBottom = NSLayoutConstraint(item: self.buttonBottom, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0)
        
        //Constraints for container
        let verticalContraintsForContainer = NSLayoutConstraint(item: self.container.view, attribute:.centerXWithinMargins, relatedBy: .equal, toItem: self, attribute: .centerXWithinMargins, multiplier: 1.0, constant: 0)
        let heightConstraintForContainer = NSLayoutConstraint.init(item: self.container.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: heightForAlertView*0.9)
        let widthConstraintForContainer = NSLayoutConstraint.init(item: self.container.view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: widthForAlertView)
        let pinContraintsForContainer = NSLayoutConstraint(item: self.container.view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0)
        
        
        //Constraints for background
        let widthContraintsForBackground = NSLayoutConstraint(item: self.background, attribute:.width, relatedBy: .equal, toItem: superView, attribute: .width, multiplier: 1, constant: 0)
        let heightConstraintForBackground = NSLayoutConstraint.init(item: self.background, attribute: .height, relatedBy: .equal, toItem: superView, attribute: .height, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([horizontalContraintsAlertView, verticalContraintsAlertView,heightConstraintForAlertView, widthConstraintForAlertView,
                                     verticalContraintsButtonBottom, heightConstraintForButtonBottom, widthConstraintForButtonBottom, pinContraintsButtonBottom,
                                     verticalContraintsForContainer, heightConstraintForContainer, widthConstraintForContainer, pinContraintsForContainer,
                                     widthContraintsForBackground, heightConstraintForBackground])
    }
    
    //MARK: FOR ANIMATIONS ---------------------------------
    fileprivate func animateForOpening(){
        self.alpha = 1.0
        self.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
    }
    
    fileprivate func animateForEnding(){
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
            }, completion: {
                (finished: Bool) -> Void in
                // On main thread
                DispatchQueue.main.async {
                    () -> Void in
                    self.background.removeFromSuperview()
                    self.removeFromSuperview()
                    self.container.removeFromParentViewController()
                    self.container.view.removeFromSuperview()
                }
        })
    }
    
    //MARK: BUTTON ACTIONS ---------------------------------
    
    @objc func onClick(){
        self.hide()
    }
    
    //MARK: ALERTPAGEVIEWDELEGATE    --------------------------------------
    
    func nextStep(_ step: Int) {
        self.delegate?.alertOnboardingNext(step)
    }
    
    //MARK: OTHERS    --------------------------------------
    fileprivate func getTopViewController() -> UIViewController? {
        var topController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        while topController?.presentedViewController != nil {
            topController = topController?.presentedViewController
        }
        return topController
    }
    
    //MARK: NOTIFICATIONS PROCESS ------------------------------------------
    fileprivate func interceptOrientationChange(){
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(AlertOnboarding.onOrientationChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    @objc func onOrientationChange(){
        if let superview = self.superview {
            self.configureConstraints(superview)
            self.container.configureConstraintsForPageControl()
        }
    }
}

//
//  AlertPageViewController.swift
//  AlertOnboarding
//
//  Created by Philippe on 26/09/2016.
//  Copyright © 2016 CookMinute. All rights reserved.
//

protocol AlertPageViewDelegate {
    func nextStep(_ step: Int)
}

class AlertPageViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    //FOR DESIGN
    var pageController: UIPageViewController!
    var pageControl: UIPageControl!
    var alertview: AlertOnboarding!
    
    //FOR DATA
    var arrayOfImage: [String]!
    var arrayOfTitle: [String]!
    var arrayOfDescription: [String]!
    var viewControllers = [UIViewController]()
    
    //FOR TRACKING USER USAGE
    var currentStep = 0
    var maxStep = 0
    var isCompleted = false
    var delegate: AlertPageViewDelegate?
    
    
    init (arrayOfImage: [String], arrayOfTitle: [String], arrayOfDescription: [String], alertView: AlertOnboarding) {
        super.init(nibName: nil, bundle: nil)
        self.arrayOfImage = arrayOfImage
        self.arrayOfTitle = arrayOfTitle
        self.arrayOfDescription = arrayOfDescription
        self.alertview = alertView
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configurePageViewController()
        self.configurePageControl()
        
        self.view.backgroundColor = UIColor.clear
        self.view.addSubview(self.pageController.view)
        self.view.addSubview(self.pageControl)
        self.pageController.didMove(toParentViewController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! AlertChildPageViewController).pageIndex!
        
        if(index == 0){
            return nil
        }
        
        index -= 1
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! AlertChildPageViewController).pageIndex!
        
        index += 1
        
        if(index == arrayOfImage.count){
            return nil
        }
        
        return self.viewControllerAtIndex(index)
    }
    
    
    func viewControllerAtIndex(_ index : Int) -> UIViewController? {
        
        var pageContentViewController: AlertChildPageViewController!
        pageContentViewController = UINib(nibName: "AlertOnboarding", bundle: AppConstants.bundle).instantiate(withOwner: nil, options: nil)[0] as! AlertChildPageViewController
        
        pageContentViewController.pageIndex = index // 0
        
        let realIndex = arrayOfImage.count - index - 1
        
        pageContentViewController.image.image = UIImage(named: arrayOfImage[realIndex])
        pageContentViewController.labelMainTitle.text = arrayOfTitle[realIndex]
        pageContentViewController.labelMainTitle.textColor = alertview.colorTitleLabel
        pageContentViewController.labelDescription.text = arrayOfDescription[realIndex]
        pageContentViewController.labelDescription.textColor = alertview.colorDescriptionLabel
        
        return pageContentViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0] as! AlertChildPageViewController
        let index = pageContentViewController.pageIndex
        self.currentStep = (arrayOfImage.count - index! - 1)
        self.delegate?.nextStep(self.currentStep)
        //Check if user watching the last step
        if currentStep == arrayOfImage.count - 1 {
            self.isCompleted = true
        }
        //Remember the last screen user have seen
        if currentStep > self.maxStep {
            self.maxStep = currentStep
        }
        if pageControl != nil {
            pageControl.currentPage = arrayOfImage.count - index! - 1
            if pageControl.currentPage == arrayOfImage.count - 1 {
                self.alertview.buttonBottom.setTitle(alertview.titleGotItButton, for: UIControlState())
            } else {
                self.alertview.buttonBottom.setTitle(alertview.titleSkipButton, for: UIControlState())
            }
        }
    }
    
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return arrayOfImage.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    //MARK: CONFIGURATION ---------------------------------------------------------------------------------
    fileprivate func configurePageControl() {
        self.pageControl = UIPageControl(frame: CGRect(x: 0,y: 0,width: 0,height: 0))
        self.pageControl.backgroundColor = UIColor.clear
        self.pageControl.pageIndicatorTintColor = alertview.colorPageIndicator
        self.pageControl.currentPageIndicatorTintColor = alertview.colorCurrentPageIndicator
        self.pageControl.numberOfPages = arrayOfImage.count
        self.pageControl.currentPage = 0
        self.pageControl.isEnabled = false
        
        self.configureConstraintsForPageControl()
    }
    
    fileprivate func configurePageViewController(){
        self.pageController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.horizontal, options: nil)
        self.pageController.view.backgroundColor = UIColor.clear
        
        if #available(iOS 9.0, *) {
            let pageControl = UIPageControl.appearance(whenContainedInInstancesOf: [AlertPageViewController.self])
            pageControl.pageIndicatorTintColor = UIColor.clear
            pageControl.currentPageIndicatorTintColor = UIColor.clear
            
        } else {
            // Fallback on earlier versions
        }
        
        self.pageController.dataSource = self
        self.pageController.delegate = self
        
        let initialViewController = self.viewControllerAtIndex(arrayOfImage.count-1)
        self.viewControllers = [initialViewController!]
        self.pageController.setViewControllers(viewControllers, direction: .forward, animated: false, completion: nil)
        
        self.addChildViewController(self.pageController)
    }
    
    //MARK: Called after notification orientation changement
    func configureConstraintsForPageControl() {
        let alertViewSizeHeight = UIScreen.main.bounds.height*alertview.percentageRatioHeight
        let positionX = alertViewSizeHeight - (alertViewSizeHeight * 0.1) - 50
        self.pageControl.frame = CGRect(x: 0, y: positionX, width: self.view.bounds.width, height: 50)
    }
}

//
//  AlertChildPageViewController.swift
//  AlertOnboarding
//
//  Created by Philippe on 26/09/2016.
//  Copyright © 2016 CookMinute. All rights reserved.
//

class AlertChildPageViewController: UIViewController {
    
    var pageIndex: Int!
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var labelMainTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
