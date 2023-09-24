//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Артем Кохан on 03.09.2023.
//

import UIKit

class OnboardingViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var onConfirm: (() -> Void)?
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .gray
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        return pageControl
    }()
    
    lazy var techButton: UIButton = {
        
        let techButton = UIButton(type: .system)
        
        techButton.backgroundColor = .black
        techButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        techButton.setTitleColor(.white, for: .normal)
        techButton.setTitle("Вот это технологии!", for: .normal)
        techButton.layer.cornerRadius = 16
        techButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        techButton.translatesAutoresizingMaskIntoConstraints = false
        
        return techButton
    }()
    
    lazy var pages: [UIViewController] = {
        let bluePage = OnboardingPageViewController(text: "Отслеживайте только то, что хотите",
                                                    backgroundImage: UIImage(named: "OnboardingBackgroundBlue"))
        
        let redPage = OnboardingPageViewController(text: "Даже если это не литры воды и йога",
                                                   backgroundImage: UIImage(named: "OnboardingBackgroundRed"))
        
        return [bluePage, redPage]
    }()
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else {
            return nil
        }
        
        return pages[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
        
        setupHierarchy()
        setupLayout()
    }
    
    private func setupHierarchy() {
        
        view.addSubview(pageControl)
        view.addSubview(techButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            techButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            techButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            techButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            techButton.heightAnchor.constraint(equalToConstant: 60),
            pageControl.bottomAnchor.constraint(equalTo: techButton.topAnchor, constant: -20),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc
    private func buttonTapped() {
        onConfirm?()
    }
}

