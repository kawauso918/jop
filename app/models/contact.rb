class Contact < ApplicationRecord
  enum subject: { other: 0, work: 1, othermethod: 2 }
end
