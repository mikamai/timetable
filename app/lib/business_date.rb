module BusinessDate
  def business_dates_between start_date, end_date
    (start_date..end_date).to_a.reject &is_weekend
  end

  def is_weekend
    -> (date) { (date.wday % 7 == 0) || (date.wday % 7 == 6) }
  end
end
