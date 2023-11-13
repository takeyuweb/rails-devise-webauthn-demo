require "test_helper"

class PasskeysControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get passkeys_index_url
    assert_response :success
  end
end
