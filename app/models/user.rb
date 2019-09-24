class User < ApplicationRecord
    has_many :requests
    has_many :crns, through: :requests
end
