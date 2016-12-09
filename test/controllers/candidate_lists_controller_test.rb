require 'test_helper'

class CandidateListsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @candidate_list = candidate_lists(:one)
  end

  test "should get index" do
    get candidate_lists_url
    assert_response :success
  end

  test "should get new" do
    get new_candidate_list_url
    assert_response :success
  end

  test "should create candidate_list" do
    assert_difference('CandidateList.count') do
      post candidate_lists_url, params: { candidate_list: {  } }
    end

    assert_redirected_to candidate_list_url(CandidateList.last)
  end

  test "should show candidate_list" do
    get candidate_list_url(@candidate_list)
    assert_response :success
  end

  test "should get edit" do
    get edit_candidate_list_url(@candidate_list)
    assert_response :success
  end

  test "should update candidate_list" do
    patch candidate_list_url(@candidate_list), params: { candidate_list: {  } }
    assert_redirected_to candidate_list_url(@candidate_list)
  end

  test "should destroy candidate_list" do
    assert_difference('CandidateList.count', -1) do
      delete candidate_list_url(@candidate_list)
    end

    assert_redirected_to candidate_lists_url
  end
end
