import UIKit

class HomeVC: UIViewController {

  @IBOutlet var sideContainer: UIView!
  @IBOutlet var mainContainer: UIView!

  var isSideMenuOpen = false
  @IBOutlet var sideLeadingConstraint: NSLayoutConstraint!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    sideLeadingConstraint.constant = -self.view.frame.width
    
    NotificationCenter.default.addObserver(self, selector: #selector(openSideMenu), name: .OpenOrCloseSideMenu, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(handleCloseSideMenuByPan(notification:)), name: .CloseSideMenyByEdgePan, object: nil)

    configureOpenSideMenuByPanEdge()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle{
    return .lightContent
  }
  
  func configureOpenSideMenuByPanEdge(){
    let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePan(gesture:)))
    edgePan.edges = .left
    mainContainer.addGestureRecognizer(edgePan)
  }
  
  @objc func handleCloseSideMenuByPan(notification: Notification){
    let gesture = notification.userInfo?["data"] as! UIPanGestureRecognizer
    let gestureTranslationX = gesture.translation(in: view).x
    
    self.sideContainer.frame.origin.x = gestureTranslationX
    self.mainContainer.frame.origin.x = view.frame.width + gestureTranslationX
    
    UIView.animate(withDuration: 0.2) {
      if gesture.state == .ended {
        if self.mainContainer.frame.origin.x < 300 {
          self.sideContainer.frame.origin.x = -self.view.frame.width
          self.mainContainer.frame.origin.x = 0
          self.isSideMenuOpen = false
        } else {
          self.sideContainer.frame.origin.x = 0
          self.mainContainer.frame.origin.x = self.view.frame.width
          self.isSideMenuOpen = true
        }
      }
    }
  }
  
  @objc func handleEdgePan(gesture: UIScreenEdgePanGestureRecognizer){
    mainContainer.frame.origin.x = gesture.translation(in: view).x
    sideContainer.frame.origin.x = 0 - self.view.frame.width + gesture.translation(in: view).x

    UIView.animate(withDuration: 0.2) {
      if gesture.state == .ended{
        if self.mainContainer.frame.origin.x > 70 {
          self.sideContainer.frame.origin.x = 0
          self.mainContainer.frame.origin.x = self.view.frame.width
          self.isSideMenuOpen = true
        } else {
          self.sideContainer.frame.origin.x = -self.view.frame.width
          self.mainContainer.frame.origin.x = 0
          self.isSideMenuOpen = false
        }
        self.view.layoutIfNeeded()
      }
    }
  }
  
  @objc func openSideMenu(){
    UIView.animate(withDuration: 0.2) {
      if self.isSideMenuOpen {
        self.sideContainer.frame.origin.x = -self.view.frame.width
        self.mainContainer.frame.origin.x = 0
        self.isSideMenuOpen = false
      } else {
        self.sideContainer.frame.origin.x = 0
        self.mainContainer.frame.origin.x = self.view.frame.width
        self.isSideMenuOpen = true
      }
    }
  }
}

