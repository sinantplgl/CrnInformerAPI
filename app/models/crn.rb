class Crn < ApplicationRecord
    has_many :requests
    has_many :users, through: :requests
end
