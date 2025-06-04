require "test_helper"

class KitchensControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get kitchens_edit_url
    assert_response :success
  end

  test "should get update" do
    get kitchens_update_url
    assert_response :success
  end
end
