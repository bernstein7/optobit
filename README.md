# Optobit

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/optobit`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'optobit'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install optobit

## Usage

Say you've got User class which is ActiveRecord model and you need to store some binary preferences like a role or the way user wants to be nofified.

First of all your model should have numeric column in database table

```
rake g migration add-role-to-users role:integer
rake g migration add-notification_preference-to-users notification_preference:integer
```

```ruby
class AddRoleToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :role, :integer, null: false, default: 0
  end
end

class AddNotificationPreferenceToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :notification_preference, :integer, null: false, default: 0
  end
end
```

Next, include include `Optobit::Field` in your model, define options field and available options for it.

For example:

```ruby
class User < ApplicationRecord
  include Optobit::Field

  has_options_field :role, with_values: [:developer, :maintainer, :reporter]
  has_options_field :notification_preference, with_values: [:sms, :email, :push]

  has_secure_password
  validates :email, presence: true
end
```

Now you can treat your roles and notification preference as collections while they are being saved as single number.

For example:

```ruby
user = User.last
  User Load (0.6ms)  SELECT  "users".* FROM "users" ORDER BY "users"."id" DESC LIMIT $1  [["LIMIT", 1]]
 => #<User id: 1, email: "clapandslap@gmail.com", password_digest: "$2a$10$IjojJEGWzpERqwlnmpkz3OnhfG0S5.g5UQuE1HC4EFq...", created_at: "2019-09-05 15:57:20", updated_at: "2019-09-06 10:56:30", role: 0, notification_preference: 0>
 
user.roles
=> []
 
user.notification_preferences
=> []

user.roles << :developer
=> [:developer]

user.role
=> 4 

user.notification_preferences << :sms
=> [:sms]
user.notification_preferences << :email
=> [:sms, :email]

user.notification_preference
=> 6

u.save
   (0.4ms)  BEGIN
  SQL (0.5ms)  UPDATE "users" SET "updated_at" = $1, "role" = $2, "notification_preference" = $3 WHERE "users"."id" = $4  [["updated_at", "2019-09-06 11:39:20.112416"], ["role", 4], ["notification_preference", 6], ["id", 1]]
   (1.0ms)  COMMIT
 => true

user.reload
  User Load (0.3ms)  SELECT  "users".* FROM "users" WHERE "users"."id" = $1 LIMIT $2  [["id", 1], ["LIMIT", 1]]
 => #<User id: 1, email: "clapandslap@gmail.com", password_digest: "$2a$10$IjojJEGWzpERqwlnmpkz3OnhfG0S5.g5UQuE1HC4EFq...", created_at: "2019-09-05 15:57:20", updated_at: "2019-09-06 11:31:05", role: 4, notification_preference: 6>

user.roles
=> [:developer]

> user.notification_preferences
=> [:sms, :email]
```

## Development

### Todos:
* Tests
* Options verification
* Ability to search by options (e.g. `User.where(role: User.roles(:developer, :mainainer))` produces SQL query like `SELECT  users.* FROM users WHERE users.role = 5`)

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/optobit. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Optobit project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/optobit/blob/master/CODE_OF_CONDUCT.md).
