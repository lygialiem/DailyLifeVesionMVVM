import UIKit

protocol ReadingCellDelegate: class {
  func didPressSeeMore(url: String)
}

class ContentCell: UITableViewCell {

  @IBOutlet var contentArticle: UITextView!
  @IBOutlet var imageArticle: UIImageView!
  @IBOutlet var authorArticle: UILabel!
  @IBOutlet var titleArticle: UILabel!

  let seeMore = "See more"
  weak var delegate: ReadingCellDelegate?

  override func awakeFromNib() {
    super.awakeFromNib()

    selectionStyle = UITableViewCell.SelectionStyle.none
    contentArticle.delegate = self

  }

  func configureContent(article: Article) {

    guard let urlToImage = article.urlToImage else {return}
    self.imageArticle.sd_setImage(with: URL(string: urlToImage), completed: nil)
    self.titleArticle.text = article.title?.capitalized
    self.authorArticle.text = article.author

    self.contentArticle.layer.cornerRadius = 7
    self.contentArticle.delegate = self

    let attributedOfString = [NSAttributedString.Key.foregroundColor: UIColor(white: 1, alpha: 1), NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 15)]

    guard let content = article.content else {return}

    let stringContent = "\(content) - \(self.seeMore)"
    let completedConent = stringContent.replacingOccurrences(of: "[", with: "(", options: String.CompareOptions.literal, range: nil)
    let completedConent1 = completedConent.replacingOccurrences(of: "+", with: "", options: String.CompareOptions.literal, range: nil)
    let finalContent = completedConent1.replacingOccurrences(of: "]", with: ")", options: String.CompareOptions.literal, range: nil)
    let attributedString = NSMutableAttributedString(string: finalContent, attributes: attributedOfString as [NSAttributedString.Key: Any])

    guard let url = article.url else {return}
    attributedString.setAsLink(textToFind: self.seeMore, urlString: url)

    self.contentArticle.attributedText = attributedString
  }
}
extension ContentCell: UITextViewDelegate {
  func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
    delegate?.didPressSeeMore(url: URL.absoluteString)
    return false
  }
}
