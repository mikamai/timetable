SELECT time_entries.*
FROM time_entries
WHERE time_entries.executed_on >= date_trunc('week', now())::date
  AND time_entries.executed_on <= (date_trunc('week', now()) + '6 days'::interval)::date
