require 'test_helper'

class ElectionProtocolsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @election_protocol = election_protocols(:one)
  end

  test "should get index" do
    get election_protocols_url
    assert_response :success
  end

  test "should get new" do
    get new_election_protocol_url
    assert_response :success
  end

  test "should create election_protocol" do
    assert_difference('ElectionProtocol.count') do
      post election_protocols_url, params: { election_protocol: {  } }
    end

    assert_redirected_to election_protocol_url(ElectionProtocol.last)
  end

  test "should show election_protocol" do
    get election_protocol_url(@election_protocol)
    assert_response :success
  end

  test "should get edit" do
    get edit_election_protocol_url(@election_protocol)
    assert_response :success
  end

  test "should update election_protocol" do
    patch election_protocol_url(@election_protocol), params: { election_protocol: {  } }
    assert_redirected_to election_protocol_url(@election_protocol)
  end

  test "should destroy election_protocol" do
    assert_difference('ElectionProtocol.count', -1) do
      delete election_protocol_url(@election_protocol)
    end

    assert_redirected_to election_protocols_url
  end
end
