require 'test_helper'

class BallotBoxesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ballot_box = ballot_boxes(:one)
  end

  test "should get index" do
    get ballot_boxes_url
    assert_response :success
  end

  test "should get new" do
    get new_ballot_box_url
    assert_response :success
  end

  test "should create ballot_box" do
    assert_difference('BallotBox.count') do
      post ballot_boxes_url, params: { ballot_box: {  } }
    end

    assert_redirected_to ballot_box_url(BallotBox.last)
  end

  test "should show ballot_box" do
    get ballot_box_url(@ballot_box)
    assert_response :success
  end

  test "should get edit" do
    get edit_ballot_box_url(@ballot_box)
    assert_response :success
  end

  test "should update ballot_box" do
    patch ballot_box_url(@ballot_box), params: { ballot_box: {  } }
    assert_redirected_to ballot_box_url(@ballot_box)
  end

  test "should destroy ballot_box" do
    assert_difference('BallotBox.count', -1) do
      delete ballot_box_url(@ballot_box)
    end

    assert_redirected_to ballot_boxes_url
  end
end
