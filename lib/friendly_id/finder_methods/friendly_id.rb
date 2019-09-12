FriendlyId::FinderMethods.module_eval do
  # Original method of FriendlyID was overwritten to custom the error message if not found:
  # The name of the model was included, can be customized in locales.
  def find(*args)
    id = args.first
    return super if args.count != 1 || id.unfriendly_id?
    first_by_friendly_id(id).tap {|result| return result unless result.nil?}
    return super if potential_primary_key?(id)
    raise_not_found
  end

  def find_by_friendly_id(id)
    first_by_friendly_id(id) or raise_not_found
  end

  private

  def raise_not_found
    raise ActiveRecord::RecordNotFound, I18n.t('activerecord.friendly_id.not_found', resource: self.name)
  end
end
