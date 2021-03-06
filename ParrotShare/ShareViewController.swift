import Cocoa
import Social

public final class ShareViewController: SLComposeServiceViewController {
    private var items = [String: [String]]()
    private var bleh: Any? = nil
    deinit {
        unsubscribe(self.bleh)
    }
    
    public override func loadView() {
        super.loadView()
        self.setValue(true, forKey: "showsAudiencePopUp")
        self.setValue(true, forKey: "showsProgressIndicator")
        self.title = NSLocalizedString("ParrotShare", comment: "Title of the Social Service")
        NSLog("Input Items = %@", self.extensionContext!.inputItems)
        
        publish(on: .system, Notification(name: Notification.Name("com.avaidyam.Parrot.Service.getConversations")))
        self.bleh = subscribe(on: .system, source: nil, Notification.Name("com.avaidyam.Parrot.Service.giveConversations")) {
            NSLog("got resp \($0)")
        }
        
    }
    
    public override func viewDidAppear() {
        super.viewDidAppear()
        self.view.superview?.appearance = NSAppearance(named: NSAppearanceNameVibrantDark)
        self.textView.textColor = NSColor.labelColor
        if let img = self.value(forKey: "imageView") as? NSImageView {
            img.imageFrameStyle = .none
        }
    }
    
    public override func didSelectPost() {
        let inputItem = self.extensionContext!.inputItems[0] as! NSExtensionItem
        let outputItem = inputItem.copy() as! NSExtensionItem
        outputItem.attributedContentText = NSAttributedString(string: self.contentText)
        self.extensionContext!.completeRequest(returningItems: [outputItem], completionHandler: nil)
    }
	
    public override func didSelectCancel() {
        let cancelError = NSError(domain: NSCocoaErrorDomain, code: NSUserCancelledError, userInfo: nil)
        self.extensionContext!.cancelRequest(withError: cancelError)
    }
	
    public override func isContentValid() -> Bool {
        return true
    }
}
