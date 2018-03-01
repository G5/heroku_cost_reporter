#frozen_string_literal: true

Fabricator(:invoice, from: 'Heroku::Invoice') do
  charges_total { 0 }
  credits_total { 0 }
  number { 3721524 }
  period_end { "2014-11-01" }
  period_start { "2014-10-01" }
  state { 1 }
  total { 28136 }
end
