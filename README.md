# Rails Starter Project

This is a customized Ruby on Rails starter project based on Rails 8.0.1 and Ruby 3.3.6. It includes various pre-configurations to accelerate new project setup.

## Customizations from Standard Rails

This starter project includes the following customizations beyond a standard Rails installation:

### Core Configuration
- **Ruby Version**: 3.3.6
- **Rails Version**: 8.0.1
- Uses Propshaft as the modern asset pipeline
- Configured with TailwindCSS for styling

### Database
- PostgreSQL configured as the default database
- Environment variable-based database configuration
- Simplified production database setup

### Authentication
- Devise integrated for user authentication
- Basic User model with name field
- Ready-to-use signup, login, and account management
- User dropdown menu with Stimulus.js controller

### User Interface
- Mobile-responsive landing page with feature overview
- Dashboard view for authenticated users
- About and Contact static pages
- TailwindCSS components and layouts
- Interactive dropdown menu with JavaScript
- SVG icons and modern design elements

### Environment Variables
- dotenv-rails for managing environment variables
- .env.example file with documented variables

### Testing Framework
- RSpec instead of the default Minitest
- FactoryBot for test fixtures
- Faker for generating test data
- Configured support directory with FactoryBot integration

### Code Quality
- Rubocop with Rails and RSpec plugins
- Brakeman for security vulnerability scanning

### Continuous Integration
- GitHub Actions workflow for automated testing
- Linting and security scanning
- PostgreSQL service for integration tests

## Authentication Customization

This starter kit includes Devise for authentication with user registration enabled by default. Depending on your application's requirements, you may want to adjust these settings:

### Disabling Public User Registration

If you want to prevent public sign-ups (e.g., for admin-only applications or invite-only systems):

1. Edit `config/routes.rb` to modify Devise routes:

```ruby
devise_for :users, skip: [:registrations]
devise_scope :user do
  get '/users/edit' => 'devise/registrations#edit', as: 'edit_user_registration'
  put '/users' => 'devise/registrations#update', as: 'user_registration'
end
```

This keeps profile editing available to existing users while disabling public registration.

2. Alternatively, keep registrations but make them admin-only:

```ruby
# In app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  before_action :authenticate_user!
end

# Then in app/controllers/home_controller.rb
class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
end
```

### Adding Admin-Only User Creation

To allow only admins to create new users:

1. Create an admin interface for user management:

```ruby
# In app/controllers/admin/users_controller.rb
class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path, notice: "User created successfully."
    else
      render :new
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end
  
  def authenticate_admin!
    redirect_to root_path unless current_user&.admin?
  end
end
```

### Other Common Authentication Customizations

- **Email confirmation**: Enable in `config/initializers/devise.rb` with `config.confirm_within = 2.days`
- **Account lockout**: Configure in Devise initializer with `config.lock_strategy` and `config.maximum_attempts`
- **Password requirements**: Set in Devise initializer with `config.password_length` and `config.password_regex`
- **Session timeout**: Set with `config.timeout_in = 30.minutes`

For more details, see the [Devise documentation](https://github.com/heartcombo/devise).

Remember to update your application's security settings based on your specific requirements.

## Getting Started

### Prerequisites
- Ruby 3.3.6
- PostgreSQL
- Node.js and npm

### Installation

1. Clone this repository
```
git clone https://github.com/smorttey/rails-starter-kit.git
cd rails-starter
```

2. Install dependencies
```
bundle install
```

3. Set up environment variables
```
cp .env.example .env
# Edit .env with your database credentials
```

4. Create and migrate the database
```
rails db:create
rails db:migrate
```

5. Install the Devise User model
```
rails generate devise User name:string
rails db:migrate
```

6. Start the Rails server with Tailwind CSS processing
```
# In one terminal, run the Tailwind CSS compiler
rails tailwindcss:watch

# In another terminal, start the Rails server
rails server

# Alternatively, you can use Foreman to run both processes (included in Gemfile)
# First, create a Procfile.dev:
# web: bin/rails server -p 3000
# css: bin/rails tailwindcss:watch

# Then run:
# foreman start -f Procfile.dev
```

### Frontend Development Notes

For frontend development with this starter kit:

- Tailwind CSS is configured and ready to use in your views
- The Tailwind CSS compiler must be running (`rails tailwindcss:watch`) for style changes to take effect
- Styles are automatically applied to views using the included stylesheets
- If you update the Tailwind configuration, the watcher will automatically recompile CSS
- For production, Tailwind CSS is automatically compiled during asset precompilation

## Authentication Usage

The project comes with Devise authentication configured:

- User model with email/password authentication
- Routes for registration, login, logout, and password management
- `before_action :authenticate_user!` can be added to any controller that requires authentication
- Helper methods: `user_signed_in?`, `current_user`

## UI Components

The starter kit includes several pre-built UI components:

- Navigation bar with responsive design
- User dropdown menu (powered by Stimulus.js)
- Feature cards on the homepage
- Dashboard layout for authenticated users
- Static pages (About, Contact)

## JavaScript Enhancement

Stimulus.js controllers are included for enhanced interactivity:

- `dropdown_controller.js` - Toggle dropdowns with click-outside detection
- More controllers can be added in the `app/javascript/controllers` directory

## Testing

Run the test suite with:
```
bundle exec rspec
```

## Linting

Run code quality checks with:
```
bundle exec rubocop
```

## Environment Variables

The following environment variables can be configured in your `.env` file:

```
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=your_password
DATABASE_HOST=localhost
RAILS_MAX_THREADS=5
```

## License

This project is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
