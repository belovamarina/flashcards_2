# This file should contain all the record creation needed to seed the database
# with its default values.
# The data can then be loaded with the rake db:seed
# (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.create(email: 'admin@example.com',
                   password: 'secret',
                   password_confirmation: 'secret',
                   locale: 'ru')
user.add_role :admin

Blazer::Query.create(creator_id: user.id,
                     name: 'Visits',
                     statement: %q(SELECT * FROM "visits" ORDER BY started_at DESC LIMIT 10),
                     data_source: 'main')

Blazer::Query.create(creator_id: user.id,
                     name: 'New visits',
                     statement: %q(SELECT date_trunc('week', started_at)::date AS week, COUNT(*) AS new_visits FROM visits GROUP BY week ORDER BY week),
                     data_source: 'main')

Blazer::Query.create(creator_id: user.id,
                     name: 'Landing page',
                     statement: %q(SELECT landing_page, COUNT(*) FROM visits GROUP BY 1),
                     data_source: 'main')

Blazer::Query.create(creator_id: user.id,
                     name: 'Events by user',
                     statement: %q(	SELECT name, users.email, COUNT(*) FROM ahoy_events INNER JOIN users ON users.id=ahoy_events.user_id GROUP BY 1, 2),
                     data_source: 'main')
