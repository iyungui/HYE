import Foundation
#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(DeveloperToolsSupport)
import DeveloperToolsSupport
#endif

#if SWIFT_PACKAGE
private let resourceBundle = Foundation.Bundle.module
#else
private class ResourceBundleClass {}
private let resourceBundle = Foundation.Bundle(for: ResourceBundleClass.self)
#endif

// MARK: - Color Symbols -

@available(iOS 11.0, macOS 10.13, tvOS 11.0, *)
extension ColorResource {

    /// The "mainColor" asset catalog color resource.
    static let main = ColorResource(name: "mainColor", bundle: resourceBundle)

}

// MARK: - Image Symbols -

@available(iOS 11.0, macOS 10.7, tvOS 11.0, *)
extension ImageResource {

    /// The "image01" asset catalog image resource.
    static let image01 = ImageResource(name: "image01", bundle: resourceBundle)

    /// The "image02" asset catalog image resource.
    static let image02 = ImageResource(name: "image02", bundle: resourceBundle)

    /// The "image03" asset catalog image resource.
    static let image03 = ImageResource(name: "image03", bundle: resourceBundle)

    /// The "image04" asset catalog image resource.
    static let image04 = ImageResource(name: "image04", bundle: resourceBundle)

    /// The "image05" asset catalog image resource.
    static let image05 = ImageResource(name: "image05", bundle: resourceBundle)

    /// The "image06" asset catalog image resource.
    static let image06 = ImageResource(name: "image06", bundle: resourceBundle)

    /// The "image07" asset catalog image resource.
    static let image07 = ImageResource(name: "image07", bundle: resourceBundle)

}

// MARK: - Color Symbol Extensions -

#if canImport(AppKit)
@available(macOS 10.13, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    /// The "mainColor" asset catalog color.
    static var main: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .main)
#else
        .init()
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    /// The "mainColor" asset catalog color.
    static var main: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .main)
#else
        .init()
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Color {

    /// The "mainColor" asset catalog color.
    static var main: SwiftUI.Color { .init(.main) }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

    /// The "mainColor" asset catalog color.
    static var main: SwiftUI.Color { .init(.main) }

}
#endif

// MARK: - Image Symbol Extensions -

#if canImport(AppKit)
@available(macOS 10.7, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    /// The "image01" asset catalog image.
    static var image01: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .image01)
#else
        .init()
#endif
    }

    /// The "image02" asset catalog image.
    static var image02: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .image02)
#else
        .init()
#endif
    }

    /// The "image03" asset catalog image.
    static var image03: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .image03)
#else
        .init()
#endif
    }

    /// The "image04" asset catalog image.
    static var image04: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .image04)
#else
        .init()
#endif
    }

    /// The "image05" asset catalog image.
    static var image05: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .image05)
#else
        .init()
#endif
    }

    /// The "image06" asset catalog image.
    static var image06: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .image06)
#else
        .init()
#endif
    }

    /// The "image07" asset catalog image.
    static var image07: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .image07)
#else
        .init()
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    /// The "image01" asset catalog image.
    static var image01: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .image01)
#else
        .init()
#endif
    }

    /// The "image02" asset catalog image.
    static var image02: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .image02)
#else
        .init()
#endif
    }

    /// The "image03" asset catalog image.
    static var image03: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .image03)
#else
        .init()
#endif
    }

    /// The "image04" asset catalog image.
    static var image04: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .image04)
#else
        .init()
#endif
    }

    /// The "image05" asset catalog image.
    static var image05: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .image05)
#else
        .init()
#endif
    }

    /// The "image06" asset catalog image.
    static var image06: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .image06)
#else
        .init()
#endif
    }

    /// The "image07" asset catalog image.
    static var image07: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .image07)
#else
        .init()
#endif
    }

}
#endif

// MARK: - Thinnable Asset Support -

@available(iOS 11.0, macOS 10.13, tvOS 11.0, *)
@available(watchOS, unavailable)
extension ColorResource {

    private init?(thinnableName: String, bundle: Bundle) {
#if canImport(AppKit) && os(macOS)
        if AppKit.NSColor(named: NSColor.Name(thinnableName), bundle: bundle) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIColor(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(AppKit)
@available(macOS 10.13, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    private convenience init?(thinnableResource: ColorResource?) {
#if !targetEnvironment(macCatalyst)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    private convenience init?(thinnableResource: ColorResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Color {

    private init?(thinnableResource: ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

    private init?(thinnableResource: ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}
#endif

@available(iOS 11.0, macOS 10.7, tvOS 11.0, *)
@available(watchOS, unavailable)
extension ImageResource {

    private init?(thinnableName: String, bundle: Bundle) {
#if canImport(AppKit) && os(macOS)
        if bundle.image(forResource: NSImage.Name(thinnableName)) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIImage(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(AppKit)
@available(macOS 10.7, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    private convenience init?(thinnableResource: ImageResource?) {
#if !targetEnvironment(macCatalyst)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    private convenience init?(thinnableResource: ImageResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

// MARK: - Backwards Deployment Support -

/// A color resource.
struct ColorResource: Hashable {

    /// An asset catalog color resource name.
    fileprivate let name: String

    /// An asset catalog color resource bundle.
    fileprivate let bundle: Bundle

    /// Initialize a `ColorResource` with `name` and `bundle`.
    init(name: String, bundle: Bundle) {
        self.name = name
        self.bundle = bundle
    }

}

/// An image resource.
struct ImageResource: Hashable {

    /// An asset catalog image resource name.
    fileprivate let name: String

    /// An asset catalog image resource bundle.
    fileprivate let bundle: Bundle

    /// Initialize an `ImageResource` with `name` and `bundle`.
    init(name: String, bundle: Bundle) {
        self.name = name
        self.bundle = bundle
    }

}

#if canImport(AppKit)
@available(macOS 10.13, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    /// Initialize a `NSColor` with a color resource.
    convenience init(resource: ColorResource) {
        self.init(named: NSColor.Name(resource.name), bundle: resource.bundle)!
    }

}

protocol _ACResourceInitProtocol {}
extension AppKit.NSImage: _ACResourceInitProtocol {}

@available(macOS 10.7, *)
@available(macCatalyst, unavailable)
extension _ACResourceInitProtocol {

    /// Initialize a `NSImage` with an image resource.
    init(resource: ImageResource) {
        self = resource.bundle.image(forResource: NSImage.Name(resource.name))! as! Self
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    /// Initialize a `UIColor` with a color resource.
    convenience init(resource: ColorResource) {
#if !os(watchOS)
        self.init(named: resource.name, in: resource.bundle, compatibleWith: nil)!
#else
        self.init()
#endif
    }

}

@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    /// Initialize a `UIImage` with an image resource.
    convenience init(resource: ImageResource) {
#if !os(watchOS)
        self.init(named: resource.name, in: resource.bundle, compatibleWith: nil)!
#else
        self.init()
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Color {

    /// Initialize a `Color` with a color resource.
    init(_ resource: ColorResource) {
        self.init(resource.name, bundle: resource.bundle)
    }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Image {

    /// Initialize an `Image` with an image resource.
    init(_ resource: ImageResource) {
        self.init(resource.name, bundle: resource.bundle)
    }

}
#endif