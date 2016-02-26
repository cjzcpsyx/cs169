class User < ActiveRecord::Base
  validates :username, :presence => true
  validate :username_format
  
  def username_format
    if self.username.nil?
      errors.add(:username, "Username can't be nil")
    elsif self.username.length < 10
      errors.add(:username, "Username can't be shorter than 10 characters")
    elsif self.username =~ /^[a-z]/i
      errors.add(:username, "Username should start with a letter")
    end
  end
  
end
