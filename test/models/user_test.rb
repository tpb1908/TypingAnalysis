require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
  	@user = User.new(name: "Example User", username:"Example user",  email: "user@example.com", password:"123456", password_confirmation: "123456")
  end

  test "should be valid" do
  	assert @user.valid?
  end

  test "name should be present" do
  	@user.name = "	"
  	assert_not @user.valid?
  end

  test "email should present" do
  	@user.email = "	"
  	assert_not @user.valid?
  end

  test "name should not be too long" do
  	@user.name = "a" *51
  	assert_not @user.valid?
  end

  test "email should not be too long" do
  	@user.email = "a" * 244 + "@example.com"
  	assert_not @user.valid?
  end

  test "email validation should accept valid emails" do
  	valid_addresses = %w[user2@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
    	@user.email = valid_address
    	assert @user.valid?, "#{valid_address.inspect} should be valid" 
    end
  end

  test "email validation should reject invalid emails" do
  	invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
    	@user.email = invalid_address
    	assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
  	duplicate_user = @user.dup
  	duplicate_user.email = @user.email.upcase
  	@user.save
  	assert_not duplicate_user.valid?
  end

  test "usernames should be unique" do 
    duplicate_user = @user.dup
    duplicate_user.username = @user.username
    @user.save
    assert_not duplicate_user.valid?
  end

  test "usernames should not be the same as emails" do
    duplicate_user = @user.dup
    duplicate_user.username = "user@user.com"
    duplicate_user.email = "user@'user.com"
    assert_not duplicate_user.valid?
  end

  test "email should be saved as downcase" do
  	@user.email = @user.email.upcase
  	@user.save
  	assert @user.email == @user.email.downcase
  end

  test "password should be present" do
  	@user.password = @user.password_confirmation = " " * 6
  	assert_not @user.valid?
  end

  test "pasword should have minimum length" do
  	@user.password = @user.password_confirmation = " " *5
  	assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  


end