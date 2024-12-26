#if canImport(UIKit)
  import UIKit

  extension UIView {
    @objc func addGestureRecognizer(action: @escaping (UITapGestureRecognizer) -> Void) -> Any? {
      let recognizer = UITapGestureRecognizer { action($0) }
      recognizer.requiresExclusiveTouchType = false
      recognizer.cancelsTouchesInView = false

      self.addGestureRecognizer(recognizer)

      return recognizer
    }
  }

  // from: https://stackoverflow.com/a/58901875/13162032
  extension UITapGestureRecognizer {
    typealias Action = ((UITapGestureRecognizer) -> Void)

    private struct Keys { @MainActor static var actionKey = "ActionKey" }

    private var block: Action? {
      set {
        if let newValue = newValue {
          // Computed properties get stored as associated objects
          withUnsafePointer(to: &Keys.actionKey) {
            objc_setAssociatedObject(
              self,
              $0,
              newValue,
              objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN
            )
          }
        }
      }
      get {
        withUnsafePointer(to: &Keys.actionKey) {
          let action = objc_getAssociatedObject(self, $0) as? Action
          return action
        }
      }
    }

    @objc func handleAction(recognizer: UITapGestureRecognizer) { block?(recognizer) }

    convenience init(block: @escaping ((UITapGestureRecognizer) -> Void)) {
      self.init()
      self.block = block
      self.addTarget(self, action: #selector(handleAction(recognizer:)))
    }
  }
#endif

#if canImport(AppKit)
  import AppKit

  extension NSEvent {
    @MainActor func location(in view: NSView) -> CGPoint? {
      if let appWindow = view.window, let window = self.window, appWindow == window {
        view.convert(self.locationInWindow, from: nil)
      } else {
        nil
      }
    }
  }
#endif
