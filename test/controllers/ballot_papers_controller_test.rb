require 'test_helper'

class BallotPapersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ballot_paper = ballot_papers(:one)
  end

  test "should get index" do
    get ballot_papers_url
    assert_response :success
  end

  test "should get new" do
    get new_ballot_paper_url
    assert_response :success
  end

  test "should create ballot_paper" do
    assert_difference('BallotPaper.count') do
      post ballot_papers_url, params: { ballot_paper: { vote: @ballot_paper.vote } }
    end

    assert_redirected_to ballot_paper_url(BallotPaper.last)
  end

  test "should show ballot_paper" do
    get ballot_paper_url(@ballot_paper)
    assert_response :success
  end

  test "should get edit" do
    get edit_ballot_paper_url(@ballot_paper)
    assert_response :success
  end

  test "should update ballot_paper" do
    patch ballot_paper_url(@ballot_paper), params: { ballot_paper: { vote: @ballot_paper.vote } }
    assert_redirected_to ballot_paper_url(@ballot_paper)
  end

  test "should destroy ballot_paper" do
    assert_difference('BallotPaper.count', -1) do
      delete ballot_paper_url(@ballot_paper)
    end

    assert_redirected_to ballot_papers_url
  end
end
