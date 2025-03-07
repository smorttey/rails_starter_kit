# Rails Starter Project

This is a customized Ruby on Rails starter project based on Rails 8.0.1 and Ruby 3.3.6. It includes various pre-configurations to accelerate new project setup.

## Technology Stack

This starter kit includes the following technologies:

### Core
- **Ruby**: 3.3.6 - Modern Ruby version with performance improvements
- **Rails**: 8.0.1 - Latest Rails version with all modern features
- **PostgreSQL** - Powerful, open source object-relational database
- **Propshaft** - Modern asset pipeline for Rails 7+

### Frontend
- **Tailwind CSS** - Utility-first CSS framework
- **Hotwire** - Modern, HTML-over-the-wire approach:
  - **Turbo** - Adds SPA-like navigation without writing JavaScript
  - **Stimulus** - Small, focused JavaScript framework

### Authentication
- **Devise** - Flexible authentication solution
- **Custom styled auth views** - Tailwind-styled login/signup forms

### Development Tools
- **dotenv-rails** - Environment variable management
- **Run Script** - Convenient shell commands for development tasks
- **Project Renaming Script** - Automated project renaming

### Testing
- **RSpec** - Feature-rich testing framework
- **FactoryBot** - Fixtures replacement with straightforward definition syntax
- **Faker** - Generate realistic test data

### Code Quality
- **Rubocop** - Static code analyzer and formatter
  - With Rails and RSpec plugins
- **Brakeman** - Security vulnerability scanner
- **CI/CD** - GitHub Actions workflow configuration

## Inspiration

This starter kit was inspired by [nickjj/docker-rails-example](https://github.com/nickjj/docker-rails-example), which provides an excellent example of a production-ready Rails app with Docker. While this kit takes a different approach by not requiring Docker, it borrows several concepts like the `run` script and project renaming workflow. Many thanks to Nick Janetakis for his outstanding work!

## Getting Started

### 1. Clone the Repository

Start by cloning the starter kit repository and specifying your desired project folder name:

```bash
git clone https://github.com/smorttey/rails_starter_kit.git my_new_project
cd my_new_project
```

### 2. Rename the Project

Use the included script to rename all internal references within files:

```bash
# Make the script executable if needed
chmod +x bin/rename-project

# Run the rename script with your app's name
bin/rename-project my_app_name MyAppName
```

This script will:
- Replace all occurrences of "rails_starter_kit" and "rails_starter" with "my_app_name"
- Replace all occurrences of "RailsStarterKit" and "RailsStarter" with "MyAppName"
- Update database configuration
- Optionally initialize a new git repository

### 3. Set Up Your Application

After renaming the project, follow these steps:

```bash
# Copy and configure environment variables
cp .env.example .env
# Edit .env with your database credentials

# Install dependencies
bundle install

# Create and set up the database
rails db:create db:migrate db:seed

# Start the application (using the run script)
./run server
```

The `run` script provides many helpful commands for development. See all available commands with:

```bash
./run help
```

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

## Development Workflow

The `run` script provides shortcuts for common development tasks:

```bash
# Show all available commands
./run help

# Start the Rails server with Tailwind CSS watching
./run server

# Access the Rails console
./run console

# Run the test suite
./run test

# Run database migrations
./run db:migrate

# And many more commands...
```

## Frontend Development Notes

For frontend development with this starter kit:

- Tailwind CSS is configured and ready to use in your views
- The `run server` command automatically starts the Tailwind CSS compiler
- Styles are automatically applied to views using the included stylesheets
- If you update the Tailwind configuration, the watcher will automatically recompile CSS

## Authentication Usage

The project comes with Devise authentication configured:

- User model with email/password authentication
- Routes for registration, login, logout, and password management
- `before_action :authenticate_user!` can be added to any controller that requires authentication
- Helper methods: `user_signed_in?`, `current_user`

## Testing

Run the test suite with:
```
./run test
```

## Linting

Run code quality checks with:
```
./run lint
```

## Environment Variables

Create your own environment file by copying the example:

```bash
cp .env.example .env
```

Edit `.env` with your specific configuration. This file is gitignored to keep your secrets safe.

Common environment variables include:

```
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=postgres
DATABASE_HOST=localhost
DATABASE_PORT=5432
RAILS_MAX_THREADS=5
```

## License

This project is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Project Customization

### Renaming the Project

This starter kit comes with a handy script to rename the project:

```bash
# The script takes 2 arguments:
#
# The first is the lowercase version of your app's name (with underscores)
# The second is the PascalCase version for your app's module name
bin/rename-project myapp MyApp
```

The script will:
- Replace all occurrences of the default name in files
- Update the database configuration
- Optionally initialize a new git repository
- Guide you through next steps

### Development Workflow

Use the included `run` script for common development tasks:

```bash
# Show all available commands
./run help

# Start the Rails server with Tailwind CSS watching
./run server

# Access the Rails console
./run console

# Run the test suite
./run test

# Run database migrations
./run db:migrate

# And many more commands...
```

### Environment Variables

Copy the example environment file to create your own:

```bash
cp .env.example .env
```

Edit `.env` with your specific configuration. This file is gitignored to keep your secrets safe.
