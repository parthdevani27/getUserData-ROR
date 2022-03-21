class User
  include Mongoid::Document
  field :firstName, type: String
  field :lastName, type: String
  field :email, type: String

  validates :firstName,:lastName ,presence: true
  validates :email ,presence: true, uniqueness: true
  validates_format_of :email,:with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/

end
