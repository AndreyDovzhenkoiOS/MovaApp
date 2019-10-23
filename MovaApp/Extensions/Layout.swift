//
//  AiryLayout.swift
//  MovaApp
//
//  Created by Andrey on 10/22/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit

enum LayoutPinnedSide: Hashable {
    case top(CGFloat)
    case left(CGFloat)
    case right(CGFloat)
    case bottom(CGFloat)
}

enum LayoutSideDirection: Int {
    case top
    case left
    case right
    case bottom
}

private var isSafeAreaEnabled: Bool = true

extension UIView {
    var safeTopAnchor: NSLayoutYAxisAnchor {
         if isSafeAreaEnabled {
             return safeAreaLayoutGuide.topAnchor
         } else {
             return topAnchor
         }
     }

     var safeBottomAnchor: NSLayoutYAxisAnchor {
         if isSafeAreaEnabled {
             return safeAreaLayoutGuide.bottomAnchor
         } else {
             return bottomAnchor
         }
     }

     var safeLeftAnchor: NSLayoutXAxisAnchor {
         if isSafeAreaEnabled {
             return safeAreaLayoutGuide.leftAnchor
         } else {
             return leftAnchor
         }
     }

     var safeLeadingAnchor: NSLayoutXAxisAnchor {
         if isSafeAreaEnabled {
             return safeAreaLayoutGuide.leadingAnchor
         } else {
             return leadingAnchor
         }
     }

     var safeTrailingAnchor: NSLayoutXAxisAnchor {
         if isSafeAreaEnabled {
             return safeAreaLayoutGuide.trailingAnchor
         } else {
             return trailingAnchor
         }
     }

     var safeCenterXAnchor: NSLayoutXAxisAnchor {
         if isSafeAreaEnabled {
             return safeAreaLayoutGuide.centerXAnchor
         } else {
             return centerXAnchor
         }
     }

     var safeCenterYAnchor: NSLayoutYAxisAnchor {
         if isSafeAreaEnabled {
             return safeAreaLayoutGuide.centerYAnchor
         } else {
             return centerYAnchor
         }
     }

    @discardableResult
    func prepareForAutoLayout() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }

    @discardableResult
    func withoutSafeArea(_ closure: (UIView) -> Void) -> Self {
        isSafeAreaEnabled = false
        closure(self)
        isSafeAreaEnabled = true
        return self
    }

    @discardableResult
    func pin(insets: UIEdgeInsets = .zero, to toView: UIView? = nil) -> UIView {
        let view = check(toView)

        safeTopAnchor ~ view.safeTopAnchor + insets.top
        safeTrailingAnchor ~ view.safeTrailingAnchor - insets.right
        safeLeadingAnchor ~ view.safeLeadingAnchor + insets.left
        safeBottomAnchor ~ view.safeBottomAnchor - insets.bottom

        return self
    }

    @discardableResult
    func pin(_ inset: CGFloat = 0.0) -> UIView {
        return pin(insets: UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset))
    }

    @discardableResult
    func centerY(_ inset: CGFloat = 0.0, to toView: UIView? = nil) -> UIView {
        let view = check(toView)
        safeCenterYAnchor ~ view.safeCenterYAnchor + inset
        return self
    }

    @discardableResult
    func centerX(_ inset: CGFloat = 0.0, to toView: UIView? = nil) -> UIView {
        let view = check(toView)
        safeCenterXAnchor ~ view.safeCenterXAnchor + inset
        return self
    }

    @discardableResult
    func height(_ value: CGFloat, priority: Float = 1000) -> UIView {
        var constraint = heightAnchor.constraint(equalToConstant: value)
        constraint.priority = UILayoutPriority(rawValue: priority)
        constraint = constraint.activate()
        return self
    }

    @discardableResult
    func height(value: CGFloat = 0.0, to toView: UIView? = nil) -> UIView {
        let view = check(toView)
        heightAnchor ~ view.heightAnchor + value
        return self
    }

    @discardableResult
    func width(_ value: CGFloat) -> UIView {
        widthAnchor ~ value
        return self
    }

    @discardableResult
    func width(value: CGFloat = 0.0, to toView: UIView? = nil) -> UIView {
        let view = check(toView)
        widthAnchor ~ view.widthAnchor + value
        return self
    }

    @discardableResult
    func left(_ inset: CGFloat = 0.0, to toView: UIView? = nil) -> UIView {
        let view = check(toView)
        safeLeadingAnchor ~ view.safeLeadingAnchor + inset
        return self
    }

    @discardableResult
    func left(to side: LayoutPinnedSide, of toView: UIView? = nil) -> UIView {
        let view = check(toView)
        let (_, inset) = direction(from: side)
        safeLeadingAnchor ~ view.anchorX(for: side) + inset
        return self
    }

    @discardableResult
    func right(_ inset: CGFloat = 0.0, to toView: UIView? = nil) -> UIView {
        let view = check(toView)
        safeTrailingAnchor ~ view.safeTrailingAnchor - inset
        return self
    }

    @discardableResult
    func right(to side: LayoutPinnedSide, of toView: UIView? = nil) -> UIView {
        let view = check(toView)
        let (_, inset) = direction(from: side)
        safeTrailingAnchor ~ view.anchorX(for: side) - inset
        return self
    }

    @discardableResult
    func top(_ inset: CGFloat = 0.0, to toView: UIView? = nil) -> UIView {
        let view = check(toView)
        safeTopAnchor ~ view.safeTopAnchor + inset
        return self
    }

    @discardableResult
    func top(to side: LayoutPinnedSide, of toView: UIView? = nil) -> UIView {
        let view = check(toView)
        let (_, inset) = direction(from: side)
        safeTopAnchor ~ view.anchorY(for: side) + inset
        return self
    }

    @discardableResult
    func bottom(_ inset: CGFloat = 0.0, to toView: UIView? = nil) -> UIView {
        let view = check(toView)
        safeBottomAnchor ~ view.safeBottomAnchor - inset
        return self
    }

    @discardableResult
    func bottom(to side: LayoutPinnedSide, of toView: UIView? = nil) -> UIView {
        let view = check(toView)
        let (_, inset) = direction(from: side)
        safeBottomAnchor ~ view.anchorY(for: side) - inset
        return self
    }

    @discardableResult
    func aspectRatio(widthToHeight: CGFloat = 1.0) -> UIView {
        widthAnchor.constraint(equalTo: heightAnchor, multiplier: widthToHeight).isActive = true
        return self
    }
}

private extension UIView {
    private func check(_ view: UIView?) -> UIView {
        defer {
            translatesAutoresizingMaskIntoConstraints = false
        }
        guard view == nil else {
            return view!
        }
        guard let superview = superview else {
            fatalError("No superview for your view and also parameter `view` is nil")
        }
        return superview
    }

    @inline(__always)
    private func side(for direction: LayoutSideDirection, inset: CGFloat = 0.0) -> LayoutPinnedSide {
        switch direction {
        case .top:
            return LayoutPinnedSide.top(inset)
        case .left:
            return LayoutPinnedSide.left(inset)
        case .right:
            return LayoutPinnedSide.right(inset)
        case .bottom:
            return LayoutPinnedSide.bottom(inset)
        }
    }

    @inline(__always)
    private func direction(from side: LayoutPinnedSide) -> (LayoutSideDirection, CGFloat) {
        switch side {
        case let .top(inset):
            return (.top, inset)
        case let .left(inset):
            return (.left, inset)
        case let .right(inset):
            return (.right, inset)
        case let .bottom(inset):
            return (.bottom, inset)
        }
    }

    private func anchorX(for side: LayoutPinnedSide) -> NSLayoutXAxisAnchor {
        switch side {
        case .right:
            return safeTrailingAnchor
        case .left:
            return safeLeadingAnchor
        default:
            fatalError("Something went wrong")
        }
    }

    private func anchorY(for side: LayoutPinnedSide) -> NSLayoutYAxisAnchor {
        switch side {
        case .top:
            return safeTopAnchor
        case .bottom:
            return safeBottomAnchor
        default:
            fatalError("Something went wrong")
        }
    }
}

struct ConstraintAttribute<T: AnyObject> {
    let anchor: NSLayoutAnchor<T>
    let const: CGFloat
}

struct LayoutGuideAttribute {
    let guide: UILayoutSupport
    let const: CGFloat
}

func + <T>(lhs: NSLayoutAnchor<T>, rhs: CGFloat) -> ConstraintAttribute<T> {
    return ConstraintAttribute(anchor: lhs, const: rhs)
}

func + (lhs: UILayoutSupport, rhs: CGFloat) -> LayoutGuideAttribute {
    return LayoutGuideAttribute(guide: lhs, const: rhs)
}

func + <T>(lhs: ConstraintAttribute<T>, rhs: CGFloat) -> ConstraintAttribute<T> {
    return ConstraintAttribute(anchor: lhs.anchor, const: lhs.const + rhs)
}

func - <T>(lhs: NSLayoutAnchor<T>, rhs: CGFloat) -> ConstraintAttribute<T> {
    return ConstraintAttribute(anchor: lhs, const: -rhs)
}

func - (lhs: UILayoutSupport, rhs: CGFloat) -> LayoutGuideAttribute {
    return LayoutGuideAttribute(guide: lhs, const: -rhs)
}

func - <T>(lhs: ConstraintAttribute<T>, rhs: CGFloat) -> ConstraintAttribute<T> {
    return ConstraintAttribute(anchor: lhs.anchor, const: lhs.const - rhs)
}

precedencegroup AiryLayoutEquivalence {
    higherThan: ComparisonPrecedence
    lowerThan: AdditionPrecedence
}

infix operator ~: AiryLayoutEquivalence
infix operator <~: AiryLayoutEquivalence
infix operator ~>: AiryLayoutEquivalence

@discardableResult
func ~ (lhs: NSLayoutYAxisAnchor, rhs: UILayoutSupport) -> NSLayoutConstraint {
    return lhs.constraint(equalTo: rhs.bottomAnchor).activate()
}

@discardableResult
func ~ <T>(lhs: NSLayoutAnchor<T>, rhs: NSLayoutAnchor<T>) -> NSLayoutConstraint {
    return lhs.constraint(equalTo: rhs).activate()
}

@discardableResult
func ~ <T>(lhs: NSLayoutAnchor<T>, rhs: ConstraintAttribute<T>) -> NSLayoutConstraint {
    return lhs.constraint(equalTo: rhs.anchor, constant: rhs.const).activate()
}

@discardableResult
func ~ (lhs: NSLayoutYAxisAnchor, rhs: NSLayoutYAxisAnchor) -> NSLayoutConstraint {
    return lhs.constraint(equalTo: rhs).activate()
}

@discardableResult
func ~ (lhs: NSLayoutXAxisAnchor, rhs: NSLayoutXAxisAnchor) -> NSLayoutConstraint {
    return lhs.constraint(equalTo: rhs).activate()
}

@discardableResult
func ~ (lhs: NSLayoutYAxisAnchor, rhs: LayoutGuideAttribute) -> NSLayoutConstraint {
    return lhs.constraint(equalTo: rhs.guide.bottomAnchor, constant: rhs.const).activate()
}

@discardableResult
func ~ (lhs: NSLayoutDimension, rhs: CGFloat) -> NSLayoutConstraint {
    return lhs.constraint(equalToConstant: rhs).activate()
}

@discardableResult
func <~ <T>(lhs: NSLayoutAnchor<T>, rhs: ConstraintAttribute<T>) -> NSLayoutConstraint {
    return lhs.constraint(lessThanOrEqualTo: rhs.anchor, constant: rhs.const).activate()
}

@discardableResult
func <~ (lhs: NSLayoutYAxisAnchor, rhs: NSLayoutYAxisAnchor) -> NSLayoutConstraint {
    return lhs.constraint(lessThanOrEqualTo: rhs).activate()
}

@discardableResult
func <~ (lhs: NSLayoutDimension, rhs: CGFloat) -> NSLayoutConstraint {
    return lhs.constraint(lessThanOrEqualToConstant: rhs).activate()
}

@discardableResult
func ~> <T>(lhs: NSLayoutAnchor<T>, rhs: ConstraintAttribute<T>) -> NSLayoutConstraint {
    return lhs.constraint(greaterThanOrEqualTo: rhs.anchor, constant: rhs.const).activate()
}

@discardableResult
func ~> (lhs: NSLayoutDimension, rhs: CGFloat) -> NSLayoutConstraint {
    return lhs.constraint(greaterThanOrEqualToConstant: rhs).activate()
}

@discardableResult
func ~> (lhs: NSLayoutYAxisAnchor, rhs: NSLayoutYAxisAnchor) -> NSLayoutConstraint {
    return lhs.constraint(greaterThanOrEqualTo: rhs).activate()
}

@discardableResult
func ~> (lhs: NSLayoutXAxisAnchor, rhs: NSLayoutXAxisAnchor) -> NSLayoutConstraint {
    return lhs.constraint(greaterThanOrEqualTo: rhs).activate()
}

extension NSLayoutConstraint {
    func activate() -> Self {
        isActive = true
        return self
    }
}

// swiftlint:disable:this file_length
