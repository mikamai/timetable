module BusinessDate
  def business_dates_between start_date, end_date
    start_date = Date.parse(start_date) if start_date.class == String
    end_date = Date.parse(end_date) if end_date.class == String
    (start_date..end_date).to_a.reject &is_weekend
  rescue
    nil
  end

  def is_weekend
    -> (date) { (date.wday % 7 == 0) || (date.wday % 7 == 6) }
  end
end
