require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @incomplete_valid_user = User.new(facebook_id: '10573829204',
                                email: 'johndoe@example.com',
                                name: 'John Doe')
    @incomplete_invalid_user = User.new(facebook_id: '4385094832',
                                        name: 'Max Smith',
                                        gender: 'Male',
                                        age_range: 'min21')
  end

  test 'valid user' do
    user = users(:one)
    assert user.valid?
  end

  test 'User needs only email and facebook id' do
    user = @incomplete_valid_user
    assert user.valid?
  end

  test 'facebook id, email, and name are required' do
    user = @incomplete_invalid_user
    assert_not user.valid?
  end

  test 'user can follow other user' do
    user = users(:one)
    other_user = users(:two)
    followers_count = other_user.following.count
    user.follow(other_user)
    assert user.following?(other_user)
    assert other_user.followers.count == followers_count + 1
  end

  test 'user can follow and unfollow other user' do
    user = users(:one)
    other_user = users(:two)
    user.follow(other_user)
    assert other_user.followers.count == 1
    user.unfollow(other_user)
    assert other_user.followers.count == 0
  end



end
#name: 'John Doe',
#first_name: 'John',
#last_name: 'Doe',
