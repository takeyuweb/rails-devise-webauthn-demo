require "test_helper"

class MyPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get my_pages_show_url
    assert_response :success
  end
end
