class Link < ApplicationRecord
 validates :original, :shortned, url: { allow_nil: false }
end


