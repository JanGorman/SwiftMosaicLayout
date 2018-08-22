![](https://www.dropbox.com/s/1etd4ue7iwqbd14/SwiftMosaicLayout.png?raw=1)

# Installation

SwiftMosaicLayout is available via CocoaPods

```ruby
pod 'SwiftMosaicLayout'
```

or Carthage

```
github "JanGorman/SwiftMosaicLayout"
```

# How to

To use the layout, set the `collectionViewLayout` to use mosaic:

```swift
func viewDidLoad() {
  super.viewDidLoad()

  let layout = SwiftMosaicLayout()
  // Optional
  layout.delegate = self

  collectionView.collectionViewLayout = layout
}
```

Adopting `SwiftMosaicLayoutDelegate` allows you to control various aspects of the layout, such as the number of columns or what cell size to use for which indexPath:

```swift
extension ViewController: SwiftMosaicLayoutDelegate {

  func collectionView(_ collectionView: UICollectionView, layout: SwiftMosaicLayout, numberOfColumnsInSection section: Int) -> Int {
    return 2
  }

  func collectionView(_ collectionView: UICollectionView, layout: SwiftMosaicLayout, cellSizeForItemAtIndexPath indexPath: IndexPath) -> CellSize {
    return indexPath.item % 12 == 0 ? .large : .small
  }

}
```