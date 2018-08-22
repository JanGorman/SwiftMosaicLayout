//
//  Copyright © 2018 Schnaub. All rights reserved.
//

import UIKit

@objc public protocol SwiftMosaicLayoutDelegate: UICollectionViewDelegate {

  /// Return the number of columns in each section
  ///
  /// - Parameters:
  ///   - collectionView: The UICollectionView
  ///   - layout: The layout instance
  ///   - section: The section
  /// - Returns: The number of columns in the section
  func collectionView(_ collectionView: UICollectionView, layout: SwiftMosaicLayout, numberOfColumnsInSection section: Int) -> Int

  /// The `CellSize` for an item at the given indexPath
  ///
  /// - Parameters:
  ///   - collectionView: The UICollectionView
  ///   - layout: The layout instance
  ///   - indexPath: The indexPath
  /// - Returns: The `CellSize` for the item. Either .small or .large
  @objc optional func collectionView(_ collectionView: UICollectionView, layout: SwiftMosaicLayout,
                                     cellSizeForItemAtIndexPath indexPath: IndexPath) -> CellSize

  /// The `UIEdgeInsets` for the section
  ///
  /// - Parameters:
  ///   - collectionView: The UICollectionView
  ///   - layout: The layout instance
  ///   - section: The section
  /// - Returns: `UIEdgeInsets`
  @objc optional func collectionView(_ collectionView: UICollectionView, layout: SwiftMosaicLayout,
                                     insetForSection section: Int) -> UIEdgeInsets

  /// The interitem spacing for the section
  ///
  /// - Parameters:
  ///   - collectionView: The UICollectionView
  ///   - layout: The layout instance
  ///   - section: The section
  /// - Returns: The spacing as `CGFloat`
  @objc optional func collectionView(_ collectionView: UICollectionView, layout: SwiftMosaicLayout,
                                     interitemSpacingForSection section: Int) -> CGFloat

  /// The header height for the section
  ///
  /// - Parameters:
  ///   - collectionView: The UICollectionView
  ///   - layout: The layout instance
  ///   - section: The section
  /// - Returns: The height as `CGFloat`
  @objc optional func collectionView(_ collectionView: UICollectionView, layout: SwiftMosaicLayout,
                                     heightForHeaderInSection section: Int) -> CGFloat

  /// The footer height for the section
  ///
  /// - Parameters:
  ///   - collectionView: The UICollectionView
  ///   - layout: The layout instance
  ///   - section: The section
  /// - Returns: The height as `CGFloat`
  @objc optional func collectionView(_ collectionView: UICollectionView, layout: SwiftMosaicLayout,
                                     heightForFooterInSection section: Int) -> CGFloat

  /// Should the header overlay the content. Defaults to `false`
  ///
  /// - Parameters:
  ///   - collectionView: The UICollectionView
  ///   - layout: The layout instance
  /// - Returns: `Bool`
  @objc optional func headerOverlaysContentInCollectionView(_ collectionView: UICollectionView, layout: SwiftMosaicLayout) -> Bool

  /// Should the footer overlay the content. Defaults to `false`
  ///
  /// - Parameters:
  ///   - collectionView: The UICollectionView
  ///   - layout: The layout instance
  /// - Returns: `Bool`
  @objc optional func footerOverlaysContentInCollectionView(_ collectionView: UICollectionView, layout: SwiftMosaicLayout) -> Bool

}
