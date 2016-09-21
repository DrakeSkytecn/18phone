// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift

import Foundation
import Rswift
import UIKit

/// This `R` struct is code generated, and contains references to static resources.
struct R: Rswift.Validatable {
  static func validate() throws {
    try intern.validate()
  }
  
  /// This `R.color` struct is generated, and contains static references to 0 color palettes.
  struct color {
    private init() {}
  }
  
  /// This `R.file` struct is generated, and contains static references to 2 files.
  struct file {
    /// Resource file `LICENSE`.
    static let lICENSE = FileResource(bundle: _R.hostingBundle, name: "LICENSE", pathExtension: "")
    /// Resource file `ringtone.wav`.
    static let ringtoneWav = FileResource(bundle: _R.hostingBundle, name: "ringtone", pathExtension: "wav")
    
    /// `bundle.URLForResource("LICENSE", withExtension: "")`
    static func lICENSE(_: Void) -> NSURL? {
      let fileResource = R.file.lICENSE
      return fileResource.bundle.URLForResource(fileResource)
    }
    
    /// `bundle.URLForResource("ringtone", withExtension: "wav")`
    static func ringtoneWav(_: Void) -> NSURL? {
      let fileResource = R.file.ringtoneWav
      return fileResource.bundle.URLForResource(fileResource)
    }
    
    private init() {}
  }
  
  /// This `R.font` struct is generated, and contains static references to 0 fonts.
  struct font {
    private init() {}
  }
  
  /// This `R.image` struct is generated, and contains static references to 34 images.
  struct image {
    /// Image `answer`.
    static let answer = ImageResource(bundle: _R.hostingBundle, name: "answer")
    /// Image `backup`.
    static let backup = ImageResource(bundle: _R.hostingBundle, name: "backup")
    /// Image `Brand Assets`.
    static let brandAssets = ImageResource(bundle: _R.hostingBundle, name: "Brand Assets")
    /// Image `call`.
    static let call = ImageResource(bundle: _R.hostingBundle, name: "call")
    /// Image `call_in_connected`.
    static let call_in_connected = ImageResource(bundle: _R.hostingBundle, name: "call_in_connected")
    /// Image `call_in_unconnected`.
    static let call_in_unconnected = ImageResource(bundle: _R.hostingBundle, name: "call_in_unconnected")
    /// Image `call_out_connected`.
    static let call_out_connected = ImageResource(bundle: _R.hostingBundle, name: "call_out_connected")
    /// Image `call_out_unconnected`.
    static let call_out_unconnected = ImageResource(bundle: _R.hostingBundle, name: "call_out_unconnected")
    /// Image `delete`.
    static let delete = ImageResource(bundle: _R.hostingBundle, name: "delete")
    /// Image `delete_all`.
    static let delete_all = ImageResource(bundle: _R.hostingBundle, name: "delete_all")
    /// Image `dial`.
    static let dial = ImageResource(bundle: _R.hostingBundle, name: "dial")
    /// Image `dial_down`.
    static let dial_down = ImageResource(bundle: _R.hostingBundle, name: "dial_down")
    /// Image `dial_plate`.
    static let dial_plate = ImageResource(bundle: _R.hostingBundle, name: "dial_plate")
    /// Image `dial_tab`.
    static let dial_tab = ImageResource(bundle: _R.hostingBundle, name: "dial_tab")
    /// Image `dial_tab_selected`.
    static let dial_tab_selected = ImageResource(bundle: _R.hostingBundle, name: "dial_tab_selected")
    /// Image `dial_up`.
    static let dial_up = ImageResource(bundle: _R.hostingBundle, name: "dial_up")
    /// Image `hang_up`.
    static let hang_up = ImageResource(bundle: _R.hostingBundle, name: "hang_up")
    /// Image `head_photo_default`.
    static let head_photo_default = ImageResource(bundle: _R.hostingBundle, name: "head_photo_default")
    /// Image `is_register`.
    static let is_register = ImageResource(bundle: _R.hostingBundle, name: "is_register")
    /// Image `male`.
    static let male = ImageResource(bundle: _R.hostingBundle, name: "male")
    /// Image `message`.
    static let message = ImageResource(bundle: _R.hostingBundle, name: "message")
    /// Image `message_selected`.
    static let message_selected = ImageResource(bundle: _R.hostingBundle, name: "message_selected")
    /// Image `more`.
    static let more = ImageResource(bundle: _R.hostingBundle, name: "more")
    /// Image `paste`.
    static let paste = ImageResource(bundle: _R.hostingBundle, name: "paste")
    /// Image `qrcode`.
    static let qrcode = ImageResource(bundle: _R.hostingBundle, name: "qrcode")
    /// Image `shop`.
    static let shop = ImageResource(bundle: _R.hostingBundle, name: "shop")
    /// Image `shop_selected`.
    static let shop_selected = ImageResource(bundle: _R.hostingBundle, name: "shop_selected")
    /// Image `speaker`.
    static let speaker = ImageResource(bundle: _R.hostingBundle, name: "speaker")
    /// Image `user`.
    static let user = ImageResource(bundle: _R.hostingBundle, name: "user")
    /// Image `video_call`.
    static let video_call = ImageResource(bundle: _R.hostingBundle, name: "video_call")
    /// Image `video_icon`.
    static let video_icon = ImageResource(bundle: _R.hostingBundle, name: "video_icon")
    /// Image `voice_call`.
    static let voice_call = ImageResource(bundle: _R.hostingBundle, name: "voice_call")
    /// Image `voice_icon`.
    static let voice_icon = ImageResource(bundle: _R.hostingBundle, name: "voice_icon")
    /// Image `yellowlight`.
    static let yellowlight = ImageResource(bundle: _R.hostingBundle, name: "yellowlight")
    
    /// `UIImage(named: "answer", bundle: ..., traitCollection: ...)`
    static func answer(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.answer, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "backup", bundle: ..., traitCollection: ...)`
    static func backup(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.backup, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "Brand Assets", bundle: ..., traitCollection: ...)`
    static func brandAssets(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.brandAssets, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "call", bundle: ..., traitCollection: ...)`
    static func call(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.call, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "call_in_connected", bundle: ..., traitCollection: ...)`
    static func call_in_connected(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.call_in_connected, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "call_in_unconnected", bundle: ..., traitCollection: ...)`
    static func call_in_unconnected(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.call_in_unconnected, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "call_out_connected", bundle: ..., traitCollection: ...)`
    static func call_out_connected(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.call_out_connected, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "call_out_unconnected", bundle: ..., traitCollection: ...)`
    static func call_out_unconnected(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.call_out_unconnected, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "delete", bundle: ..., traitCollection: ...)`
    static func delete(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.delete, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "delete_all", bundle: ..., traitCollection: ...)`
    static func delete_all(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.delete_all, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "dial", bundle: ..., traitCollection: ...)`
    static func dial(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.dial, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "dial_down", bundle: ..., traitCollection: ...)`
    static func dial_down(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.dial_down, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "dial_plate", bundle: ..., traitCollection: ...)`
    static func dial_plate(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.dial_plate, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "dial_tab", bundle: ..., traitCollection: ...)`
    static func dial_tab(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.dial_tab, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "dial_tab_selected", bundle: ..., traitCollection: ...)`
    static func dial_tab_selected(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.dial_tab_selected, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "dial_up", bundle: ..., traitCollection: ...)`
    static func dial_up(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.dial_up, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "hang_up", bundle: ..., traitCollection: ...)`
    static func hang_up(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.hang_up, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "head_photo_default", bundle: ..., traitCollection: ...)`
    static func head_photo_default(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.head_photo_default, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "is_register", bundle: ..., traitCollection: ...)`
    static func is_register(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.is_register, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "male", bundle: ..., traitCollection: ...)`
    static func male(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.male, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "message", bundle: ..., traitCollection: ...)`
    static func message(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.message, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "message_selected", bundle: ..., traitCollection: ...)`
    static func message_selected(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.message_selected, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "more", bundle: ..., traitCollection: ...)`
    static func more(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.more, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "paste", bundle: ..., traitCollection: ...)`
    static func paste(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.paste, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "qrcode", bundle: ..., traitCollection: ...)`
    static func qrcode(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.qrcode, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "shop", bundle: ..., traitCollection: ...)`
    static func shop(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.shop, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "shop_selected", bundle: ..., traitCollection: ...)`
    static func shop_selected(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.shop_selected, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "speaker", bundle: ..., traitCollection: ...)`
    static func speaker(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.speaker, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "user", bundle: ..., traitCollection: ...)`
    static func user(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.user, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "video_call", bundle: ..., traitCollection: ...)`
    static func video_call(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.video_call, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "video_icon", bundle: ..., traitCollection: ...)`
    static func video_icon(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.video_icon, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "voice_call", bundle: ..., traitCollection: ...)`
    static func voice_call(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.voice_call, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "voice_icon", bundle: ..., traitCollection: ...)`
    static func voice_icon(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.voice_icon, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "yellowlight", bundle: ..., traitCollection: ...)`
    static func yellowlight(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.yellowlight, compatibleWithTraitCollection: traitCollection)
    }
    
    private init() {}
  }
  
  private struct intern: Rswift.Validatable {
    static func validate() throws {
      try _R.validate()
    }
    
    private init() {}
  }
  
  /// This `R.nib` struct is generated, and contains static references to 2 nibs.
  struct nib {
    /// Nib `CallConView`.
    static let callConView = _R.nib._CallConView()
    /// Nib `DialView`.
    static let dialView = _R.nib._DialView()
    
    /// `UINib(name: "CallConView", bundle: ...)`
    static func callConView(_: Void) -> UINib {
      return UINib(resource: R.nib.callConView)
    }
    
    /// `UINib(name: "DialView", bundle: ...)`
    static func dialView(_: Void) -> UINib {
      return UINib(resource: R.nib.dialView)
    }
    
    private init() {}
  }
  
  /// This `R.reuseIdentifier` struct is generated, and contains static references to 9 reuse identifiers.
  struct reuseIdentifier {
    /// Reuse identifier `backup_cell_a`.
    static let backup_cell_a: ReuseIdentifier<UITableViewCell> = ReuseIdentifier(identifier: "backup_cell_a")
    /// Reuse identifier `contact`.
    static let contact: ReuseIdentifier<ContactCell> = ReuseIdentifier(identifier: "contact")
    /// Reuse identifier `detail_phone_cell`.
    static let detail_phone_cell: ReuseIdentifier<UITableViewCell> = ReuseIdentifier(identifier: "detail_phone_cell")
    /// Reuse identifier `dial_1`.
    static let dial_1: ReuseIdentifier<DialNumberCell> = ReuseIdentifier(identifier: "dial_1")
    /// Reuse identifier `dial_2`.
    static let dial_2: ReuseIdentifier<DialIconCell> = ReuseIdentifier(identifier: "dial_2")
    /// Reuse identifier `dial_3`.
    static let dial_3: ReuseIdentifier<DialNumberCell> = ReuseIdentifier(identifier: "dial_3")
    /// Reuse identifier `dial_a`.
    static let dial_a: ReuseIdentifier<DialNumberCell> = ReuseIdentifier(identifier: "dial_a")
    /// Reuse identifier `dial_b`.
    static let dial_b: ReuseIdentifier<DialIconCell> = ReuseIdentifier(identifier: "dial_b")
    /// Reuse identifier `log_a`.
    static let log_a: ReuseIdentifier<CallLogACell> = ReuseIdentifier(identifier: "log_a")
    
    private init() {}
  }
  
  /// This `R.segue` struct is generated, and contains static references to 2 view controllers.
  struct segue {
    /// This struct is generated for `ContactViewController`, and contains static references to 1 segues.
    struct contactViewController {
      /// Segue identifier `contactDetailViewController`.
      static let contactDetailViewController: StoryboardSegueIdentifier<UIStoryboardSegue, ContactViewController, ContactDetailViewController> = StoryboardSegueIdentifier(identifier: "contactDetailViewController")
      
      /// Optionally returns a typed version of segue `contactDetailViewController`.
      /// Returns nil if either the segue identifier, the source, destination, or segue types don't match.
      /// For use inside `prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)`.
      static func contactDetailViewController(segue segue: UIStoryboardSegue) -> TypedStoryboardSegueInfo<UIStoryboardSegue, ContactViewController, ContactDetailViewController>? {
        return TypedStoryboardSegueInfo(segueIdentifier: R.segue.contactViewController.contactDetailViewController, segue: segue)
      }
      
      private init() {}
    }
    
    /// This struct is generated for `RootViewController`, and contains static references to 2 segues.
    struct rootViewController {
      /// Segue identifier `callLogViewController`.
      static let callLogViewController: StoryboardSegueIdentifier<UIStoryboardSegue, RootViewController, CallLogViewController> = StoryboardSegueIdentifier(identifier: "callLogViewController")
      /// Segue identifier `contactViewController`.
      static let contactViewController: StoryboardSegueIdentifier<UIStoryboardSegue, RootViewController, ContactViewController> = StoryboardSegueIdentifier(identifier: "contactViewController")
      
      /// Optionally returns a typed version of segue `callLogViewController`.
      /// Returns nil if either the segue identifier, the source, destination, or segue types don't match.
      /// For use inside `prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)`.
      static func callLogViewController(segue segue: UIStoryboardSegue) -> TypedStoryboardSegueInfo<UIStoryboardSegue, RootViewController, CallLogViewController>? {
        return TypedStoryboardSegueInfo(segueIdentifier: R.segue.rootViewController.callLogViewController, segue: segue)
      }
      
      /// Optionally returns a typed version of segue `contactViewController`.
      /// Returns nil if either the segue identifier, the source, destination, or segue types don't match.
      /// For use inside `prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)`.
      static func contactViewController(segue segue: UIStoryboardSegue) -> TypedStoryboardSegueInfo<UIStoryboardSegue, RootViewController, ContactViewController>? {
        return TypedStoryboardSegueInfo(segueIdentifier: R.segue.rootViewController.contactViewController, segue: segue)
      }
      
      private init() {}
    }
    
    private init() {}
  }
  
  /// This `R.storyboard` struct is generated, and contains static references to 2 storyboards.
  struct storyboard {
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()
    /// Storyboard `Main`.
    static let main = _R.storyboard.main()
    
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void) -> UIStoryboard {
      return UIStoryboard(resource: R.storyboard.launchScreen)
    }
    
    /// `UIStoryboard(name: "Main", bundle: ...)`
    static func main(_: Void) -> UIStoryboard {
      return UIStoryboard(resource: R.storyboard.main)
    }
    
    private init() {}
  }
  
  /// This `R.string` struct is generated, and contains static references to 0 localization tables.
  struct string {
    private init() {}
  }
  
  private init() {}
}

struct _R: Rswift.Validatable {
  static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap(NSLocale.init) ?? NSLocale.currentLocale()
  static let hostingBundle = NSBundle(identifier: "com.kratos.18phone") ?? NSBundle.mainBundle()
  
  static func validate() throws {
    try storyboard.validate()
  }
  
  struct nib {
    struct _CallConView: NibResourceType {
      let bundle = _R.hostingBundle
      let name = "CallConView"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [NSObject : AnyObject]? = nil) -> CallConView? {
        return instantiateWithOwner(ownerOrNil, options: optionsOrNil)[0] as? CallConView
      }
      
      private init() {}
    }
    
    struct _DialView: NibResourceType {
      let bundle = _R.hostingBundle
      let name = "DialView"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [NSObject : AnyObject]? = nil) -> UIView? {
        return instantiateWithOwner(ownerOrNil, options: optionsOrNil)[0] as? UIView
      }
      
      private init() {}
    }
    
    private init() {}
  }
  
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      try main.validate()
    }
    
    struct launchScreen: StoryboardResourceWithInitialControllerType {
      typealias InitialController = UIViewController
      
      let bundle = _R.hostingBundle
      let name = "LaunchScreen"
      
      private init() {}
    }
    
    struct main: StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = KTabBarController
      
      let backupViewController = StoryboardViewControllerResource<BackupViewController>(identifier: "BackupViewController")
      let bundle = _R.hostingBundle
      let detailMenuViewController = StoryboardViewControllerResource<DetailMenuViewController>(identifier: "DetailMenuViewController")
      let dialViewController = StoryboardViewControllerResource<DialView1Controller>(identifier: "DialViewController")
      let incomingCallViewController = StoryboardViewControllerResource<IncomingCallViewController>(identifier: "IncomingCallViewController")
      let incomingVideoViewController = StoryboardViewControllerResource<IncomingVideoViewController>(identifier: "IncomingVideoViewController")
      let name = "Main"
      let outgoingCallViewController = StoryboardViewControllerResource<OutgoingCallViewController>(identifier: "OutgoingCallViewController")
      
      func backupViewController(_: Void) -> BackupViewController? {
        return UIStoryboard(resource: self).instantiateViewController(backupViewController)
      }
      
      func detailMenuViewController(_: Void) -> DetailMenuViewController? {
        return UIStoryboard(resource: self).instantiateViewController(detailMenuViewController)
      }
      
      func dialViewController(_: Void) -> DialView1Controller? {
        return UIStoryboard(resource: self).instantiateViewController(dialViewController)
      }
      
      func incomingCallViewController(_: Void) -> IncomingCallViewController? {
        return UIStoryboard(resource: self).instantiateViewController(incomingCallViewController)
      }
      
      func incomingVideoViewController(_: Void) -> IncomingVideoViewController? {
        return UIStoryboard(resource: self).instantiateViewController(incomingVideoViewController)
      }
      
      func outgoingCallViewController(_: Void) -> OutgoingCallViewController? {
        return UIStoryboard(resource: self).instantiateViewController(outgoingCallViewController)
      }
      
      static func validate() throws {
        if UIImage(named: "dial_tab_selected") == nil { throw ValidationError(description: "[R.swift] Image named 'dial_tab_selected' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIImage(named: "call") == nil { throw ValidationError(description: "[R.swift] Image named 'call' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIImage(named: "dial") == nil { throw ValidationError(description: "[R.swift] Image named 'dial' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIImage(named: "answer") == nil { throw ValidationError(description: "[R.swift] Image named 'answer' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIImage(named: "dial_plate") == nil { throw ValidationError(description: "[R.swift] Image named 'dial_plate' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIImage(named: "shop") == nil { throw ValidationError(description: "[R.swift] Image named 'shop' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIImage(named: "dial_tab") == nil { throw ValidationError(description: "[R.swift] Image named 'dial_tab' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIImage(named: "video_icon") == nil { throw ValidationError(description: "[R.swift] Image named 'video_icon' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIImage(named: "more") == nil { throw ValidationError(description: "[R.swift] Image named 'more' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIImage(named: "message") == nil { throw ValidationError(description: "[R.swift] Image named 'message' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIImage(named: "voice_icon") == nil { throw ValidationError(description: "[R.swift] Image named 'voice_icon' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIImage(named: "hang_up") == nil { throw ValidationError(description: "[R.swift] Image named 'hang_up' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIImage(named: "speaker") == nil { throw ValidationError(description: "[R.swift] Image named 'speaker' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIImage(named: "shop_selected") == nil { throw ValidationError(description: "[R.swift] Image named 'shop_selected' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIImage(named: "user") == nil { throw ValidationError(description: "[R.swift] Image named 'user' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIImage(named: "message_selected") == nil { throw ValidationError(description: "[R.swift] Image named 'message_selected' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIImage(named: "qrcode") == nil { throw ValidationError(description: "[R.swift] Image named 'qrcode' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIImage(named: "delete_all") == nil { throw ValidationError(description: "[R.swift] Image named 'delete_all' is used in storyboard 'Main', but couldn't be loaded.") }
        if _R.storyboard.main().detailMenuViewController() == nil { throw ValidationError(description:"[R.swift] ViewController with identifier 'detailMenuViewController' could not be loaded from storyboard 'Main' as 'DetailMenuViewController'.") }
        if _R.storyboard.main().backupViewController() == nil { throw ValidationError(description:"[R.swift] ViewController with identifier 'backupViewController' could not be loaded from storyboard 'Main' as 'BackupViewController'.") }
        if _R.storyboard.main().dialViewController() == nil { throw ValidationError(description:"[R.swift] ViewController with identifier 'dialViewController' could not be loaded from storyboard 'Main' as 'DialView1Controller'.") }
        if _R.storyboard.main().outgoingCallViewController() == nil { throw ValidationError(description:"[R.swift] ViewController with identifier 'outgoingCallViewController' could not be loaded from storyboard 'Main' as 'OutgoingCallViewController'.") }
        if _R.storyboard.main().incomingCallViewController() == nil { throw ValidationError(description:"[R.swift] ViewController with identifier 'incomingCallViewController' could not be loaded from storyboard 'Main' as 'IncomingCallViewController'.") }
        if _R.storyboard.main().incomingVideoViewController() == nil { throw ValidationError(description:"[R.swift] ViewController with identifier 'incomingVideoViewController' could not be loaded from storyboard 'Main' as 'IncomingVideoViewController'.") }
      }
      
      private init() {}
    }
    
    private init() {}
  }
  
  private init() {}
}