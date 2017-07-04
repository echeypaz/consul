require_dependency Rails.root.join('app', 'models', 'user').to_s

class User
  include VerificationImproved

  has_many :failed_person_calls
end
