//
//  UITableView+Additions.swift
//  Lunar
//
//  Created by hbkim on 2023/01/29.
//  Copyright © 2023 theo. All rights reserved.
//

import UIKit

public extension UITableView {
  func register<Cell>(
    cell: Cell.Type,
    forCellReuseIdentifier reuseIdentifier: String = Cell.reuseIdentifier
  ) where Cell: UITableViewCell {
    register(cell, forCellReuseIdentifier: reuseIdentifier)
  }

  func register<Cell>(
    cell: Cell.Type,
    forCellReuseIdentifier reuseIdentifier: String = Cell.reuseIdentifier
  ) where Cell: UITableViewHeaderFooterView {
    register(cell, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
  }

  func dequeue<Cell>(_ reusableCell: Cell.Type) -> Cell? where Cell: UITableViewCell {
    return dequeueReusableCell(withIdentifier: reusableCell.reuseIdentifier) as? Cell
  }

  func dequeue<Cell>(_ reusableCell: Cell.Type) -> Cell? where Cell: UITableViewHeaderFooterView {
    return dequeueReusableHeaderFooterView(withIdentifier: reusableCell.reuseIdentifier) as? Cell
  }
}

public protocol Reusable {}
public extension Reusable where Self: UIView {
  static var reuseIdentifier: String {
    return String(describing: self.self)
  }
}

extension UITableViewHeaderFooterView: Reusable {}
extension UITableViewCell: Reusable {}
