import UIKit
import ImageIO

/// Responsible for storing and updating the frames of a `AnimatableImageView` instance via delegation.
class Animator {
  /// Maximum duration to increment the frame timer with.
  let maxTimeStep = 1.0
  /// An array of animated frames from a single GIF image.
  var animatedFrames = [AnimatedFrame]()
  /// The size to resize all frames to
  let size: CGSize
  /// The content mode to use when resizing
  let contentMode: UIViewContentMode
  /// Maximum number of frames to load at once
  let preloadFrameCount: Int
  /// The total number of frames in the GIF.
  var frameCount = 0
  /// A reference to the original image source.
  var imageSource: CGImageSource

  /// The index of the current GIF frame.
  var currentFrameIndex = 0 {
    didSet {
      previousFrameIndex = oldValue
    }
  }

  /// The index of the previous GIF frame.
  var previousFrameIndex = 0 {
    didSet {
      preloadFrameQueue.async {
        self.updatePreloadedFrames()
      }
    }
  }
  /// Time elapsed since the last frame change. Used to determine when the frame should be updated.
  var timeSinceLastFrameChange: TimeInterval = 0.0
  /// Specifies whether GIF frames should be pre-scaled.
  /// - seealso: `needsPrescaling` in AnimatableImageView.
  var needsPrescaling = true
  /// Dispatch queue used for preloading images.
  private var preloadFrameQueue = DispatchQueue(label: "co.kaishin.Gifu.preloadQueue")
  /// The current image frame to show.
  var currentFrameImage: UIImage? {
    return frame(at: currentFrameIndex)
  }

  /// The current frame duration
  var currentFrameDuration: TimeInterval {
    return duration(at: currentFrameIndex)
  }

  /// Is this image animatable?
  var isAnimatable: Bool {
    return imageSource.isAnimatedGIF
  }

  /// Initializes an animator instance from raw GIF image data and an `Animatable` delegate.
  ///
  /// - parameter data: The raw GIF image data.
  /// - parameter delegate: An `Animatable` delegate.
  init(data: Data, size: CGSize, contentMode: UIViewContentMode, framePreloadCount: Int) {
    let options: CFDictionary = [String(kCGImageSourceShouldCache): kCFBooleanFalse]
    self.imageSource = CGImageSourceCreateWithData(data, options) ?? CGImageSourceCreateIncremental(options)
    self.size = size
    self.contentMode = contentMode
    self.preloadFrameCount = framePreloadCount
  }

  // MARK: - Frames
  /// Loads the frames from an image source, resizes them, then caches them in `animatedFrames`.
  func prepareFrames(_ completionHandler: ((Void) -> Void)? = .none) {
    frameCount = Int(CGImageSourceGetCount(imageSource))
    animatedFrames.reserveCapacity(frameCount)
    preloadFrameQueue.async {
      self.setupAnimatedFrames()
      if let handler = completionHandler { handler() }
    }
  }

  /// Returns the frame at a particular index.
  ///
  /// - parameter index: The index of the frame.
  /// - returns: An optional image at a given frame.
  func frame(at index: Int) -> UIImage? {
    return animatedFrames[safe: index]?.image
  }

  /// Returns the duration at a particular index.
  ///
  /// - parameter index: The index of the duration.
  /// - returns: The duration of the given frame.
  func duration(at index: Int) -> TimeInterval {
	return animatedFrames[safe: index]?.duration ?? TimeInterval.infinity
  }

  /// Checks whether the frame should be changed and calls a handler with the results.
  ///
  /// - parameter duration: A `CFTimeInterval` value that will be used to determine whether frame should be changed.
  /// - parameter handler: A function that takes a `Bool` and returns nothing. It will be called with the frame change result.
  func shouldChangeFrame(with duration: CFTimeInterval, handler: (Bool) -> Void) {
    incrementTimeSinceLastFrameChange(with: duration)

    if currentFrameDuration > timeSinceLastFrameChange {
      handler(false)
    } else {
      resetTimeSinceLastFrameChange()
      incrementCurrentFrameIndex()
      handler(true)
    }
  }
}

private extension Animator {
  /// Whether preloading is needed or not.
  var preloadingIsNeeded: Bool {
    return preloadFrameCount < frameCount - 1
  }

  /// Optionally loads a single frame from an image source, resizes it if requierd, then returns an `UIImage`.
  ///
  /// - parameter index: The index of the frame to load.
  /// - returns: An optional `UIImage` instance.
  func loadFrame(at index: Int) -> UIImage? {
    guard let imageRef = CGImageSourceCreateImageAtIndex(imageSource, index, nil) else { return .none }
    let image = UIImage(cgImage: imageRef)
    let scaledImage: UIImage?

    if needsPrescaling {
      switch self.contentMode {
      case .scaleAspectFit: scaledImage = image.constrained(by: size)
      case .scaleAspectFill: scaledImage = image.filling(size)
      default: scaledImage = image.resized(to: size)
      }
    } else {
      scaledImage = image
    }

    return scaledImage
  }

  /// Updates the frames by preloading new ones and replacing the previous frame with a placeholder.
  func updatePreloadedFrames() {
    if !preloadingIsNeeded { return }
    animatedFrames[previousFrameIndex] = animatedFrames[previousFrameIndex].placeholderFrame

    preloadIndexes(withStartingIndex: currentFrameIndex).forEach { index in
      let currentAnimatedFrame = animatedFrames[index]
      if !currentAnimatedFrame.isPlaceholder { return }
      animatedFrames[index] = currentAnimatedFrame.animatedFrame(with: loadFrame(at: index))
    }
  }

  /// Increments the `timeSinceLastFrameChange` property with a given duration.
  ///
  /// - parameter duration: An `NSTimeInterval` value to increment the `timeSinceLastFrameChange` property with.
  func incrementTimeSinceLastFrameChange(with duration: TimeInterval) {
    timeSinceLastFrameChange += min(maxTimeStep, duration)
  }

  /// Ensures that `timeSinceLastFrameChange` remains accurate after each frame change by substracting the `currentFrameDuration`.
  func resetTimeSinceLastFrameChange() {
    timeSinceLastFrameChange -= currentFrameDuration
  }

  /// Increments the `currentFrameIndex` property.
  func incrementCurrentFrameIndex() {
    currentFrameIndex = increment(currentFrameIndex)
  }

  /// Increments a given frame index, taking into account the `frameCount` and looping when necessary.
  ///
  /// - parameter index: The `Int` value to increment.
  /// - parameter byValue: The `Int` value to increment with.
  /// - returns: A new `Int` value.
  func increment(_ index: Int, by value: Int = 1) -> Int {
    return (index + value) % frameCount
  }

  /// Returns the indexes of the frames to preload based on a starting frame index.
  ///
  /// - parameter index: Starting index.
  /// - returns: An array of indexes to preload.
  func preloadIndexes(withStartingIndex index: Int) -> [Int] {
    let nextIndex = increment(index)
    let lastIndex = increment(index, by: preloadFrameCount)

    if lastIndex >= nextIndex {
      return [Int](nextIndex...lastIndex)
    } else {
      return [Int](nextIndex..<frameCount) + [Int](0...lastIndex)
    }
  }

  /// Set up animated frames after resetting them if necessary.
  func setupAnimatedFrames() {
    resetAnimatedFrames()

    (0..<frameCount).forEach { index in
      let frameDuration = CGImageFrameDuration(with: imageSource, atIndex: index)
      animatedFrames += [AnimatedFrame(image: .none, duration: frameDuration)]

      if index > preloadFrameCount { return }
      animatedFrames[index] = animatedFrames[index].animatedFrame(with: loadFrame(at: index))
    }
  }

  /// Reset animated frames.
  func resetAnimatedFrames() {
    animatedFrames = []
  }
}
