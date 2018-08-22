//
//  Copyright © 2018 Schnaub. All rights reserved.
//

import UIKit
import SwiftMosaicLayout

final class ViewController: UIViewController {

  @IBOutlet private var collectionView: UICollectionView!

  private let images: [UIImage] = [
    #imageLiteral(resourceName: "1391"),
    #imageLiteral(resourceName: "1356"),
    #imageLiteral(resourceName: "0501"),
    #imageLiteral(resourceName: "1337"),
    #imageLiteral(resourceName: "1256"),
    #imageLiteral(resourceName: "1311"),
    #imageLiteral(resourceName: "0977"),
    #imageLiteral(resourceName: "1452"),
    #imageLiteral(resourceName: "0567"),
    #imageLiteral(resourceName: "1355"),
    #imageLiteral(resourceName: "1353"),
    #imageLiteral(resourceName: "1410"),
    #imageLiteral(resourceName: "0754"),
    #imageLiteral(resourceName: "1507"),
    #imageLiteral(resourceName: "1113")
  ]

  override func viewDidLoad() {
    super.viewDidLoad()

    let layout = SwiftMosaicLayout()
    layout.delegate = self
    collectionView.collectionViewLayout = layout
  }

}

extension ViewController: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 100
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
    cell.imageView.image = images[indexPath.item % images.count]
    return cell
  }

}

extension ViewController: SwiftMosaicLayoutDelegate {

  func collectionView(_ collectionView: UICollectionView, layout: SwiftMosaicLayout, numberOfColumnsInSection section: Int) -> Int {
    return 2
  }

  func collectionView(_ collectionView: UICollectionView, layout: SwiftMosaicLayout, cellSizeForItemAtIndexPath indexPath: IndexPath) -> CellSize {
    return indexPath.item % 12 == 0 ? .large : .small
  }

}
