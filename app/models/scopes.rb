module Scopes
  scope :within, -> (date_range) {
    where(date: date_range)
  }

  scope :costs_within, -> (date_range) {
    within(date_range).sum("cost")
  }
end

