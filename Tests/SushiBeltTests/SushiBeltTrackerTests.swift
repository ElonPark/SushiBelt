import XCTest
@testable import SushiBelt

final class SushiBeltTrackerTests: XCTestCase {
  
  private var scrollView: UIScrollViewStub!
  private var panGestureRecognizer: UIPanGestureRecognizerStub!
  private var sushiBeltTrackerDataSource: SushiBeltTrackerDataSourceStub!
  private var sushiBeltTrackerDelegate: SushiBeltTrackerDelegateSpy!
  
  override func setUp() {
    super.setUp()
    self.scrollView = UIScrollViewStub()
    self.panGestureRecognizer = UIPanGestureRecognizerStub()
    self.sushiBeltTrackerDataSource = SushiBeltTrackerDataSourceStub()
    self.sushiBeltTrackerDelegate = SushiBeltTrackerDelegateSpy()
  }
  
  private func createTracker() -> SushiBeltTracker {
    return SushiBeltTracker(
      scrollView: self.scrollView,
      dataSource: self.sushiBeltTrackerDataSource,
      delegate: self.sushiBeltTrackerDelegate
    )
  }
}

// MARK: - scroll direction

extension SushiBeltTrackerTests {
  
  func test_scrollDirection_should_return_default_scroll_direction_on_zero_velocity() {
    // given
    let tracker = self.createTracker()
    tracker.defaultScrollDirection = .left
    
    self.scrollView.panGestureRecognizerStub = self.panGestureRecognizer
    self.panGestureRecognizer.velocityStub = .zero
    
    // when
    let direction = tracker.scrollDrection()
    
    // then
    XCTAssertEqual(direction, .left)
  }
  
  func test_scrollDirection_should_return_recent_scroll_direction_on_zero_velocity() {
    // given
    let tracker = self.createTracker()
    tracker.defaultScrollDirection = .left
    tracker.recentScrollDirection = .right
    
    self.scrollView.panGestureRecognizerStub = self.panGestureRecognizer
    self.panGestureRecognizer.velocityStub = .zero
    
    // when
    let direction = tracker.scrollDrection()
    
    // then
    XCTAssertEqual(direction, .right)
  }

  func test_scrollDirection_should_return_up() {
    // given
    let tracker = self.createTracker()
    self.scrollView.panGestureRecognizerStub = self.panGestureRecognizer
    self.panGestureRecognizer.velocityStub = .init(x: 0.0, y: -100.0)
    
    // when
    let direction = tracker.scrollDrection()
    
    // then
    XCTAssertEqual(direction, .up)
  }
  
  func test_scrollDirection_should_return_down() {
    // given
    let tracker = self.createTracker()
    self.scrollView.panGestureRecognizerStub = self.panGestureRecognizer
    self.panGestureRecognizer.velocityStub = .init(x: 0.0, y: 100.0)
    
    // when
    let direction = tracker.scrollDrection()
    
    // then
    XCTAssertEqual(direction, .down)
  }
  
  func test_scrollDirection_should_return_left() {
    // given
    let tracker = self.createTracker()
    self.scrollView.panGestureRecognizerStub = self.panGestureRecognizer
    self.panGestureRecognizer.velocityStub = .init(x: 100.0, y: 0.0)
    
    // when
    let direction = tracker.scrollDrection()
    
    // then
    XCTAssertEqual(direction, .left)
  }
  
  func test_scrollDirection_should_return_right() {
    // given
    let tracker = self.createTracker()
    self.scrollView.panGestureRecognizerStub = self.panGestureRecognizer
    self.panGestureRecognizer.velocityStub = .init(x: -100.0, y: 0.0)
    
    // when
    let direction = tracker.scrollDrection()
    
    // then
    XCTAssertEqual(direction, .right)
  }
  
  func test_scrollDirection_not_support_diagonal_direction() {
    // given
    let tracker = self.createTracker()
    self.scrollView.panGestureRecognizerStub = self.panGestureRecognizer
    self.panGestureRecognizer.velocityStub = .init(x: 100.0, y: 100.0)
    
    // when
    let direction = tracker.scrollDrection()
    
    // then
    XCTAssertNil(direction)
  }
}
