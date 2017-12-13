/* global $ */

$(() => {
  const $userSelect = $('#available-users-for-project');
  const $usersTable = $('#project-members-form-table');
  const allUsers = $('option', $userSelect).clone();

  const fetchSelectedUserIds = () => (
    $('tbody .project-member-id', $usersTable).map((i, el) => $(el).val()).toArray()
  );

  const updateAvailableUsers = () => {
    const selectedUserIds = fetchSelectedUserIds();
    const availableUsers = allUsers.filter((i, el) => (
      selectedUserIds.indexOf($(el).val()) === -1
    ));
    if (availableUsers.length > 0) {
      $userSelect.empty().removeAttr('disabled').append(availableUsers);
      $('.add_fields', $usersTable).removeClass('disabled');
    } else {
      $userSelect.empty().attr('disabled', 'true').append('<option>No more users in your organization</option>');
      $('.add_fields', $usersTable).addClass('disabled');
    }
  };

  $usersTable
    .on('cocoon:before-insert', (e, insertedItem) => {
      const $selectedUserOption = $('option:selected', $userSelect);
      $('.project-member-name', insertedItem).text($selectedUserOption.text());
      $('.project-member-email', insertedItem).text($selectedUserOption.data('email'));
      $('.project-member-id', insertedItem).val($selectedUserOption.val());
    })
    .on('cocoon:after-insert', () => {
      updateAvailableUsers();
    })
    .on('cocoon:after-remove', () => {
      updateAvailableUsers();
    });

  updateAvailableUsers();
});
