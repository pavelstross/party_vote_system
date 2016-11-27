require 'test_helper'

class BallotPaperTest < ActiveSupport::TestCase
  test "should not save BallotPaper without vote" do
    paper = BallotPaper.new
    paper.vote = nil
    assert_not paper.save
  end

  test "should not save BallotPaper with blank vote" do
    paper = BallotPaper.new
    paper.vote = "  \n\t "
    assert_not paper.save
  end
end
