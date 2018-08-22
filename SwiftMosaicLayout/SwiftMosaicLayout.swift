//
//  Copyright © 2018 Schnaub. All rights reserved.
//

import UIKit

public final class SwiftMosaicLayout: UICollectionViewLayout {

  private static let defaultNumberOfColumns = 2

  private var cellLayoutAttributes: [IndexPath: UICollectionViewLayoutAttributes]!
  private var supplementaryLayoutAttributes: [IndexPath: UICollectionViewLayoutAttributes]!
  private var matrix: Matrix!

  public weak var delegate: SwiftMosaicLayoutDelegate?

  public override var collectionViewContentSize: CGSize {
    guard let collectionView = collectionView else {
      return .zero
    }
    let height: CGFloat = (0..<matrix.numberOfSections).reduce(0) { result, section in
      let indexOfTallestColumn = self.index(ofTallestColumnInSection: section)
      return result + matrix[section, indexOfTallestColumn]
    }

    return CGSize(width: collectionView.frame.width, height: height)
  }

  public override func prepare() {
    super.prepare()

    guard let collectionView = collectionView else {
      return
    }

    reset()

    (0..<collectionView.numberOfSections).forEach { section in
      let interitemSpacing = self.interitemSpacing(inSection: section)
      let inset = self.inset(forSection: section)
      increaseColumnHeight(by: inset.top, section: section)

      let headerLayoutAttributes = layoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                                    at: IndexPath(item: 0, section: section))
      if !headerOverlaysContent() {
        increaseColumnHeight(by: headerLayoutAttributes.frame.height + interitemSpacing, section: section)
      }

      var smallCells: [IndexPath] = []
      (0..<collectionView.numberOfItems(inSection: section)).forEach { item in
        let indexPath = IndexPath(item: item, section: section)
        let cellSize = self.cellSize(forItemAtIndexPath: indexPath)
        let shortestColumnIndex = index(ofShortestColumnInSection: section)

        switch cellSize {
        case .large:
          let attributes = largeCellLayoutAttributes(forIndexPath: indexPath, inColumn: shortestColumnIndex)
          matrix[section, shortestColumnIndex] += attributes.frame.height + interitemSpacing
        case .small:
          smallCells.append(indexPath)

          if smallCells.count == 2 {
            let attributes = smallCellLayoutAttributes(forIndexPath: smallCells[0], inColumn: shortestColumnIndex,
                                                       offsetColumn: false)
            smallCellLayoutAttributes(forIndexPath: smallCells[1], inColumn: shortestColumnIndex, offsetColumn: true)

            matrix[section, shortestColumnIndex] += attributes.frame.height + interitemSpacing

            smallCells.removeAll()
          }
        }
      }

      // Cleanup remaining cells
      if !smallCells.isEmpty {
        let shortestColumnIndex = self.index(ofShortestColumnInSection: section)
        let attributes = smallCellLayoutAttributes(forIndexPath: smallCells[0], inColumn: shortestColumnIndex,
                                                   offsetColumn: false)
        matrix[section, shortestColumnIndex] += attributes.frame.height + interitemSpacing

        smallCells.removeAll()
      }

      let footerLayoutAttributes = layoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                                    at: IndexPath(item: 1, section: section))
      if !footerOverlaysContent() {
        increaseColumnHeight(by: footerLayoutAttributes.frame.height, section: section)
      }
      increaseColumnHeight(by: self.inset(forSection: section).bottom, section: section)
    }
  }

  private func reset() {
    guard let collectionView = collectionView else {
      fatalError("We need a collectionView to proceed")
    }
    cellLayoutAttributes = [:]
    supplementaryLayoutAttributes = [:]
    let sections: [[CGFloat]] = (0..<collectionView.numberOfSections).reduce(into: []) { result, section in
      result.append(Array(repeating: 0, count: numberOfColumns(inSection: section)))
    }
    matrix = Matrix(sections: sections)
  }

  private func increaseColumnHeight(by increase: CGFloat, section: Int) {
    matrix[section].enumerated().forEach { offset, element in
      matrix[section, offset] = element + increase
    }
  }

  public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var attributes: [UICollectionViewLayoutAttributes] = cellLayoutAttributes.values.filter { rect.intersects($0.frame) }
    attributes.append(contentsOf: supplementaryLayoutAttributes.values.filter { rect.intersects($0.frame) })
    return attributes
  }

  public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return cellLayoutAttributes[indexPath]
  }

  public override func layoutAttributesForSupplementaryView(ofKind elementKind: String,
                                                            at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return supplementaryLayoutAttributes[indexPath]
  }

  public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    guard let collectionView = collectionView else {
      return false
    }
    if !collectionView.bounds.size.equalTo(newBounds.size) {
      prepare()
      return true
    }
    return false
  }

}

private extension SwiftMosaicLayout {

  func largeCellLayoutAttributes(forIndexPath indexPath: IndexPath, inColumn column: Int) -> UICollectionViewLayoutAttributes {
    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
    let frame = cellRect(withSize: .large, atIndexPath: indexPath, inColumn: column)
    attributes.frame = frame
    cellLayoutAttributes[indexPath] = attributes
    return attributes
  }

  @discardableResult
  func smallCellLayoutAttributes(forIndexPath indexPath: IndexPath, inColumn column: Int,
                                         offsetColumn: Bool) -> UICollectionViewLayoutAttributes {
    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

    let interitemSpacing = self.interitemSpacing(inSection: indexPath.section)
    let width = cellHeight(forSize: .small, section: indexPath.section)
    var frame = cellRect(withSize: .small, atIndexPath: indexPath, inColumn: column)
    if offsetColumn {
      frame = frame.offsetBy(dx: (width + interitemSpacing), dy: 0)
    }
    attributes.frame = frame

    cellLayoutAttributes[indexPath] = attributes

    return attributes
  }

  func layoutAttributes(forSupplementaryViewOfKind kind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
    let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: kind, with: indexPath)

    let inset = self.inset(forSection: indexPath.section)
    let originX = inset.left
    var originY = verticalOffset(forSection: indexPath.section)
    let width = (collectionView?.frame.width ?? 0) - inset.left - inset.right
    let height: CGFloat

    switch kind {
    case UICollectionView.elementKindSectionHeader:
      height = self.height(forHeaderInSection: indexPath.section)
    case UICollectionView.elementKindSectionFooter:
      height = self.height(forFooterInSection: indexPath.section)
      if footerOverlaysContent() {
        originY -= height
      }
    default:
      fatalError("Unhandled kind \(kind)")
    }

    let tallestColumnIndex = self.index(ofTallestColumnInSection: indexPath.section)
    let sectionColumnHeight = matrix[indexPath.section, tallestColumnIndex]

    attributes.frame = CGRect(x: originX, y: sectionColumnHeight + originY, width: width, height: height)
    attributes.zIndex = 1

    supplementaryLayoutAttributes[indexPath] = attributes

    return attributes
  }

}

private extension SwiftMosaicLayout {

  func index(ofShortestColumnInSection section: Int) -> Int {
    let columnHeights = matrix[section]
    let shortest = columnHeights.min()!
    return columnHeights.firstIndex(of: shortest)!
  }

  func index(ofTallestColumnInSection section: Int) -> Int {
    let columnHeights = matrix[section]
    let tallest = columnHeights.max()!
    return columnHeights.firstIndex(of: tallest)!
  }

}

private extension SwiftMosaicLayout {

  func cellRect(withSize size: CellSize, atIndexPath indexPath: IndexPath, inColumn column: Int) -> CGRect {
    let section = indexPath.section
    let height = cellHeight(forSize: size, section: section)
    let width = height

    let inset = self.inset(forSection: section)
    let interitemSpacing = self.interitemSpacing(inSection: section)

    let columnHeight = matrix[section, column]
    let originX = CGFloat(column) * columnWidth(inSection: section) + inset.left + CGFloat(column) * interitemSpacing
    let originY = verticalOffset(forSection: section) + columnHeight

    return CGRect(x: originX, y: originY, width: width, height: height)
  }

  func cellHeight(forSize size: CellSize, section: Int) -> CGFloat {
    let width = columnWidth(inSection: section)
    let interitemSpacing = self.interitemSpacing(inSection: section)
    return size == .large ? width : (width - interitemSpacing) / 2
  }

  func columnWidth(inSection section: Int) -> CGFloat {
    guard let collectionView = collectionView else {
      return 0
    }
    let inset = self.inset(forSection: section)
    let numberOfColumns = CGFloat(self.numberOfColumns(inSection: section))
    let combinedInteritemSpacing = (numberOfColumns - 1) * interitemSpacing(inSection: section)
    let combinedColumnWidth = collectionView.frame.width - inset.left - inset.right - combinedInteritemSpacing

    return combinedColumnWidth / numberOfColumns
  }

  func verticalOffset(forSection section: Int) -> CGFloat {
    let verticalOffset: CGFloat = (0..<section).reduce(0) { result, _ in
      let indexOfTallestColumn = self.index(ofTallestColumnInSection: section)
      return result + matrix[section, indexOfTallestColumn]
    }
    return verticalOffset
  }

}

private extension SwiftMosaicLayout {

  func numberOfColumns(inSection section: Int) -> Int {
    guard let collectionView = collectionView, let delegate = delegate else {
      return SwiftMosaicLayout.defaultNumberOfColumns
    }
    return delegate.collectionView(collectionView, layout: self, numberOfColumnsInSection: section)
  }

  func cellSize(forItemAtIndexPath indexPath: IndexPath) -> CellSize {
    guard let collectionView = collectionView else {
      return .small
    }
    return delegate?.collectionView?(collectionView, layout: self, cellSizeForItemAtIndexPath: indexPath) ?? .small
  }

  func inset(forSection section: Int) -> UIEdgeInsets {
    guard let collectionView = collectionView else {
      return .zero
    }
    return delegate?.collectionView?(collectionView, layout: self, insetForSection: section) ?? .zero
  }

  func interitemSpacing(inSection section: Int) -> CGFloat {
    guard let collectionView = collectionView else {
      return 0
    }
    return delegate?.collectionView?(collectionView, layout: self, interitemSpacingForSection: section) ?? 0
  }

  func height(forHeaderInSection section: Int) -> CGFloat {
    guard let collectionView = collectionView else {
      return 0
    }
    return delegate?.collectionView?(collectionView, layout: self, heightForHeaderInSection: section) ?? 0
  }

  func height(forFooterInSection section: Int) -> CGFloat {
    guard let collectionView = collectionView else {
      return 0
    }
    return delegate?.collectionView?(collectionView, layout: self, heightForFooterInSection: section) ?? 0
  }

  func headerOverlaysContent() -> Bool {
    guard let collectionView = collectionView else {
      return false
    }
    return delegate?.headerOverlaysContentInCollectionView?(collectionView, layout: self) ?? false
  }

  func footerOverlaysContent() -> Bool {
    guard let collectionView = collectionView else {
      return false
    }
    return delegate?.footerOverlaysContentInCollectionView?(collectionView, layout: self) ?? false
  }

}
