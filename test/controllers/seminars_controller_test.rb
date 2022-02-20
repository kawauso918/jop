require 'test_helper'

class SeminarsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get seminars_index_url
    assert_response :success
  end

end
