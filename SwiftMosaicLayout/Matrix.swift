//
//  Copyright © 2018 Schnaub. All rights reserved.
//

import Foundation

struct Matrix {

  private var grid: [[CGFloat]]

  var numberOfSections: Int {
    return grid.count
  }

  init(sections: [[CGFloat]]) {
    grid = sections
  }

  subscript(section: Int) -> [CGFloat] {
    return grid[section]
  }

  subscript(section: Int, item: Int) -> CGFloat {
    get {
      return grid[section][item]
    }
    set {
      grid[section][item] = newValue
    }
  }

}
