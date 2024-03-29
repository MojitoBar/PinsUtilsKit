//
//  KeyboardAnimationManager.swift
//  PinsUtilKit
//
//  Created by 주동석 on 12/31/23.
//

import UIKit

public final class KeyboardAnimationManager {
    private let animationManager: AnimationManager = AnimationManager()
    public typealias KeyboardAnimation = (_ keyboardHeight: CGFloat, _ isKeyboardVisible: Bool) -> Void

    public init() { }
    
    public func setKeyboardObservers(animation: @escaping KeyboardAnimation) {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { [self] notification in
            handleKeyboardNotification(notification, isShowing: true, animation: animation)
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { [self] notification in
            handleKeyboardNotification(notification, isShowing: false, animation: animation)
        }
    }
    private func handleKeyboardNotification(_ notification: Notification, isShowing: Bool, animation: @escaping KeyboardAnimation) {
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        let (duration, options) = animationManager.keyboardAnimation(notification: notification)

        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            animation(keyboardHeight, isShowing)
        }, completion: nil)
    }
}
