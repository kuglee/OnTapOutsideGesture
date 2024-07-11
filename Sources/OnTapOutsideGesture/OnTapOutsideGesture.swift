import SwiftUI

extension View {
  /// Adds an action to perform when this view recognizes a tap outside gesture.
  ///
  /// Use this method to perform the specified `action` when the user clicks
  /// or taps outside the view or container.
  ///
  /// > Note: The action is performed simultaneously with other gestures.
  ///
  /// In the example below, the color of the heart images changes to a random
  /// color from the `colors` array whenever the user clicks or taps outside the
  /// view:
  ///
  ///     struct TapOutsideGestureExample: View {
  ///         let colors: [Color] = [.gray, .red, .orange, .yellow,
  ///                                .green, .blue, .purple, .pink]
  ///         @State private var fgColor: Color = .gray
  ///
  ///         var body: some View {
  ///             Image(systemName: "heart.fill")
  ///                 .resizable()
  ///                 .frame(width: 200, height: 200)
  ///                 .foregroundColor(fgColor)
  ///                 .onTapOutsideGesture {
  ///                     fgColor = colors.randomElement()!
  ///                 }
  ///         }
  ///     }
  ///
  /// - Parameters:
  ///    - action: The action to perform.
  public func onTapOutsideGesture(perform action: @escaping () -> Void) -> some View {
    self.modifier(OnTapOutsideGestureModifier(perform: action))
  }
}

struct OnTapOutsideGestureModifier: ViewModifier {
  let action: () -> Void

  @State var contentFrame: CGRect = .zero
  @State var eventMonitor: Any? = nil

  init(perform action: @escaping () -> Void) { self.action = action }

  func body(content: Content) -> some View {
    content.onGeometryFrameChange { self.contentFrame = $0 }
      .onWindowChange { window in
        if let window { self.addEventMonitor(window: window) } else { self.removeMonitor() }
      }
  }

  func onEnded(gestureLocation: CGPoint) {
    if !contentFrame.contains(gestureLocation) { self.action() }
  }

  #if canImport(UIKit)
    @MainActor func addEventMonitor(window: UIWindow) {
      self.eventMonitor = window.addGestureRecognizer {
        self.onEnded(gestureLocation: $0.location(in: window))
      }
    }
  #elseif canImport(AppKit)
    @MainActor func addEventMonitor(window: NSWindow) {
      self.eventMonitor = NSEvent.addLocalMonitorForEvents(matching: [
        .leftMouseDown, .rightMouseDown, .otherMouseDown,
      ]) {
        if let location = $0.location(in: window.contentView!) {
          self.onEnded(gestureLocation: location)
        }

        return $0
      }
    }
  #endif

  @MainActor func removeMonitor() {
    #if canImport(UIKit)
      if let gestureRecognizer = self.eventMonitor as? UIGestureRecognizer,
        let view = gestureRecognizer.view
      {
        view.removeGestureRecognizer(gestureRecognizer)
      }
    #elseif canImport(AppKit)
      if let eventMonitor { NSEvent.removeMonitor(eventMonitor) }
    #endif

    self.eventMonitor = nil
  }
}
