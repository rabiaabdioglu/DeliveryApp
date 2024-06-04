//
//  PurchaseBasketVC.swift
//  DeliveryApp
//
//  Created by Rabia Abdioğlu on 4.06.2024.
//

import Foundation
import UIKit
import SnapKit
import Lottie

class PurchaseBasketVC: UIViewController {
    private var backButton : UIButton!
    var permissionControl = false

    private var pageTitleLabel : UILabel!
    private var headerLabel: UILabel!
    private var animationView: LottieAnimationView!

    var viewModel = BasketViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                self.permissionControl = granted
            }
        
        view.backgroundColor = .white
        setupHeader()
        setupAnimation()
    }
    override func viewWillDisappear(_ animated: Bool) {
        animationView.stop()
        if permissionControl{
            let content =  UNMutableNotificationContent()
            content.title = "Home Chef"
            content.subtitle = "Your Order"
            content.body = "Your order has been delivered. "
            content.badge = 1
            content.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 30, repeats: false)
            let request = UNNotificationRequest(identifier: "id", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
        deleteLocalBasketDataFromWeb()
    }
    
    private func setupHeader() {
        pageTitleLabel = UILabel()
        pageTitleLabel.text = "Order Info"
        pageTitleLabel.font = UIFont(name: "Montserrat-SemiBold", size: 20)
        pageTitleLabel.textColor = .clrDarkGray
        
        view.addSubview(pageTitleLabel)
        pageTitleLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            
        }
        backButton = UIButton()
        backButton.setImage(UIImage(systemName: "chevron.left")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        backButton.backgroundColor = .lightGray.withAlphaComponent(0.4)
        backButton.layer.masksToBounds = true
        backButton.layer.cornerRadius = 10
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.centerY.equalTo(pageTitleLabel.snp.centerY)
            make.width.height.equalTo(40)
        }
        

    }

    private func setupAnimation() {
        animationView = LottieAnimationView(name: "delivery")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop

        view.addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-200)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(animationView.snp.width)
        }

        animationView.play()
        
        headerLabel = UILabel()
        headerLabel.text = "Your order is on the way..."
        headerLabel.font = UIFont(name: "Montserrat-SemiBold", size: 22)
        headerLabel.textColor = .clrGreen

        view.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(animationView.snp.bottom).offset(40)
        }
    }
    
    @objc func backButtonTapped(){
        self.dismiss(animated: true)
    }
    

    private func deleteLocalBasketDataFromWeb() {
        viewModel.removeAllBasket()
    }
    
}

extension PurchaseBasketVC : UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner,.sound,.badge])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let app = UIApplication.shared
    
        center.setBadgeCount(0)
        completionHandler()
    }
}
