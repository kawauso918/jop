class Seminar < ApplicationRecord
   default_scope -> { order(starts_at: :asc) }

   validate  :start_end_check

   #時間の矛盾を防ぐ
   def start_end_check
     if self.starts_at.present? && self.ends_at.present?
       errors.add(:ends_at, "が開始時刻を上回っています。正しく記入してください。") if self.starts_at > self.ends_at
     end
   end
end
