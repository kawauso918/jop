class Contact < ApplicationRecord
  enum subject: { other: 0, work: 1, recruit: 2, othermethod: 3 }
end
