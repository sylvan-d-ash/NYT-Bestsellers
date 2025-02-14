//
//  UIView+AutoLayout.swift
//  NYT Bestsellers
//
//  Created by Sylvan Ash on 14/02/2025.
//

import UIKit

extension UIView {
    @discardableResult func fillParent(_ inset: CGFloat = 0, priority: UILayoutPriority? = nil, identifier: String? = nil) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        constraints += fillParentVertically(inset, priority: priority, identifier: identifier)
        constraints += fillParentHorizontally(inset, priority: priority, identifier: identifier)
        return constraints
    }

    @discardableResult func fillParentVertically(_ inset: CGFloat = 0, priority: UILayoutPriority? = nil, identifier: String? = nil) -> [NSLayoutConstraint] {
        return [
            alignToTop(inset, priority: priority, identifier: identifier),
            alignToBottom(inset, priority: priority, identifier: identifier)
        ]
    }

    @discardableResult func fillParentHorizontally(_ inset: CGFloat = 0, priority: UILayoutPriority? = nil, identifier: String? = nil) -> [NSLayoutConstraint] {
        return [
            alignToLeft(inset, priority: priority, identifier: identifier),
            alignToRight(inset, priority: priority, identifier: identifier)
        ]
    }

    @discardableResult func centerInParent() -> [NSLayoutConstraint] {
        return [centerInParentVertically(), centerInParentHorizontally()]
    }

    @discardableResult func centerInParentVertically(priority: UILayoutPriority? = nil, identifier: String? = nil) -> NSLayoutConstraint {
        return alignToParent(.centerY, priority: priority, identifier: identifier)
    }

    @discardableResult func centerInParentHorizontally(priority: UILayoutPriority? = nil, identifier: String? = nil) -> NSLayoutConstraint {
        return alignToParent(.centerX, priority: priority, identifier: identifier)
    }

    @discardableResult func alignToTop(_ padding: CGFloat = 0, priority: UILayoutPriority? = nil, identifier: String? = nil) -> NSLayoutConstraint {
        return alignToParent(.top, padding: padding, priority: priority, identifier: identifier)
    }

    @discardableResult func alignToBottom(_ padding: CGFloat = 0, priority: UILayoutPriority? = nil, identifier: String? = nil) -> NSLayoutConstraint {
        return alignToParent(.bottom, padding: -padding, priority: priority, identifier: identifier)
    }

    @discardableResult func alignToLeft(_ padding: CGFloat = 0, priority: UILayoutPriority? = nil, identifier: String? = nil) -> NSLayoutConstraint {
        return alignToParent(.left, padding: padding, priority: priority, identifier: identifier)
    }

    @discardableResult func alignToRight(_ padding: CGFloat = 0, priority: UILayoutPriority? = nil, identifier: String? = nil) -> NSLayoutConstraint {
        return alignToParent(.right, padding: -padding, priority: priority, identifier: identifier)
    }

    @discardableResult func setWidthConstraint(_ size: CGFloat, priority: UILayoutPriority? = nil, identifier: String? = nil) -> NSLayoutConstraint {
        return setSizeConstraint(size, dimension: .width, priority: priority, identifier: identifier)
    }

    @discardableResult func setHeightConstraint(_ size: CGFloat, priority: UILayoutPriority? = nil, identifier: String? = nil) -> NSLayoutConstraint {
        return setSizeConstraint(size, dimension: .height, priority: priority, identifier: identifier)
    }

    @discardableResult func setMinWidthConstraint(_ size: CGFloat, priority: UILayoutPriority? = nil, identifier: String? = nil) -> NSLayoutConstraint {
        return setSizeConstraint(size, dimension: .width, relatedBy: .greaterThanOrEqual, priority: priority, identifier: identifier)
    }

    @discardableResult func setMinHeightConstraint(_ size: CGFloat, priority: UILayoutPriority? = nil, identifier: String? = nil) -> NSLayoutConstraint {
        return setSizeConstraint(size, dimension: .height, relatedBy: .greaterThanOrEqual, priority: priority, identifier: identifier)
    }

    @discardableResult func alignToTopOf(_ sibling: UIView, padding: CGFloat, priority: UILayoutPriority? = nil, identifier: String? = nil) -> NSLayoutConstraint {
        return siblingAlignment(sibling, edge: .top, padding: padding, priority: priority, identifier: identifier)
    }

    @discardableResult func alignToBottomOf(_ sibling: UIView, padding: CGFloat, priority: UILayoutPriority? = nil, identifier: String? = nil) -> NSLayoutConstraint {
        return siblingAlignment(sibling, edge: .bottom, padding: padding, priority: priority, identifier: identifier)
    }

    @discardableResult func alignToLeftOf(_ sibling: UIView, padding: CGFloat, priority: UILayoutPriority? = nil, identifier: String? = nil) -> NSLayoutConstraint {
        return siblingAlignment(sibling, edge: .left, padding: padding, priority: priority, identifier: identifier)
    }

    @discardableResult func alignToRightOf(_ sibling: UIView, padding: CGFloat, priority: UILayoutPriority? = nil, identifier: String? = nil) -> NSLayoutConstraint {
        return siblingAlignment(sibling, edge: .right, padding: padding, priority: priority, identifier: identifier)
    }
}

private extension UIView {
    func alignToParent(_ edge: NSLayoutConstraint.Attribute, padding: CGFloat = 0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority? = nil, identifier: String? = nil) -> NSLayoutConstraint {
        guard let superview = superview else { return NSLayoutConstraint() }
        return alignToView(superview, edge: edge, padding: padding, relatedBy: relatedBy, priority: priority, identifier: identifier)
    }

    func siblingAlignment(_ sibling: UIView, edge: NSLayoutConstraint.Attribute, padding: CGFloat = 0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority? = nil, identifier: String? = nil) -> NSLayoutConstraint {
        guard superview != nil, sibling.superview != nil else {
            assertionFailure("both views must have a superview")
            return NSLayoutConstraint()
        }
        translatesAutoresizingMaskIntoConstraints = false
        sibling.translatesAutoresizingMaskIntoConstraints = false
        return alignToView(sibling, edge: edge, padding: padding, priority: priority, identifier: identifier)
    }

    func alignToView(_ view: UIView, edge: NSLayoutConstraint.Attribute, padding: CGFloat = 0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority? = nil, identifier: String? = nil) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: edge,
                                            relatedBy: relatedBy,
                                            toItem: view,
                                            attribute: edge,
                                            multiplier: 1,
                                            constant: padding)
        if let priority = priority {
            constraint.priority = priority
        }
        constraint.identifier = identifier
        constraint.isActive = true
        return constraint
    }

    func setSizeConstraint(_ size: CGFloat, dimension: NSLayoutConstraint.Attribute, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority? = nil, identifier: String? = nil) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: dimension,
                                            relatedBy: relatedBy,
                                            toItem: nil,
                                            attribute: .notAnAttribute,
                                            multiplier: 1,
                                            constant: size)
        if let priority = priority {
            constraint.priority = priority
        }
        constraint.identifier = identifier
        constraint.isActive = true
        return constraint
    }
}
