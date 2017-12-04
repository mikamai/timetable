json.(@organization_membership, :id, :admin)
json.user(@organization_membership.user, :email)
json.tableItem render(@organization_membership, formats: [:html])
