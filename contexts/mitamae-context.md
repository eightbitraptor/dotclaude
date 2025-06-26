# Mitamae Configuration Management Context

## Key Concepts

- **mitamae**: Fast, single-binary configuration management tool with Chef-like DSL, powered by mruby
- **Recipe**: Ruby DSL file defining system configuration state (`.rb` files)
- **Resource**: Declaration of desired system state (package, file, service, etc.)
- **Attribute**: Properties defining resource behavior and configuration
- **Node**: Target system being configured, with associated attributes
- **Action**: Operation performed on a resource (:install, :create, :start, etc.)
- **Guard**: Conditional execution via `only_if` or `not_if`
- **Handler**: Plugin extending mitamae functionality
- **mruby**: Embedded Ruby implementation allowing single-binary deployment
- **Specinfra**: Backend library for cross-platform system operations
- **Local mode**: Apply recipes directly on target machine
- **Dry-run**: Preview changes without applying them

## Common Patterns

### Basic Recipe Structure
```ruby
# packages.rb
package 'nginx' do
  action :install
end

package 'vim' do
  action :install
  version '8.2'
end

service 'nginx' do
  action [:enable, :start]
end
```
**When to use**: Standard package installation and service management
**Expected output**: Packages installed, services running

### Multi-Distribution Package Management
```ruby
# Cross-platform package installation
case node[:platform]
when 'arch'
  package 'nginx' do
    action :install
  end
when 'void'
  package 'nginx' do
    action :install
    options '--yes'
  end
when 'fedora', 'redhat'
  package 'nginx' do
    action :install
  end
when 'ubuntu', 'debian'
  package 'nginx' do
    action :install
    options '-y'
  end
when 'darwin'
  execute 'install nginx' do
    command 'brew install nginx'
    not_if 'brew list nginx'
  end
end
```
**When to use**: Supporting multiple Linux distributions and macOS
**Expected output**: Package installed using distribution-specific commands

### Node Attributes and Data-Driven Configuration
```ruby
# Using node attributes from JSON
execute "set hostname" do
  command "hostnamectl set-hostname #{node[:hostname]}"
  not_if "hostname | grep -q #{node[:hostname]}"
end

# node.json
{
  "hostname": "web-server-01",
  "packages": ["nginx", "postgresql", "redis"],
  "users": {
    "deploy": {
      "uid": 1001,
      "groups": ["wheel", "docker"]
    }
  }
}

# Or use YAML format (node.yml)
hostname: desktop
user: myuser
dotfiles:
  git:
    email: user@example.com
    name: Full Name
packages:
  - neovim
  - tmux
  - ripgrep
features:
  docker: true
  firewall: false

# Apply with: mitamae local recipe.rb -j node.json
# Or: mitamae local recipe.rb -y node.yml
```
**When to use**: Managing multiple machines with different configurations
**Expected output**: System configured based on node-specific data

### File and Template Management
```ruby
# Static file
file '/etc/motd' do
  content "Welcome to #{node[:hostname]}\n"
  mode '644'
  owner 'root'
  group 'root'
end

# Template with variables
template '/etc/nginx/sites-available/app' do
  source 'templates/nginx-site.erb'
  mode '644'
  variables(
    server_name: node[:fqdn],
    app_port: node[:app][:port],
    ssl_cert: node[:ssl][:cert_path]
  )
  notifies :reload, 'service[nginx]'
end

# Remote file download
remote_file '/tmp/installer.sh' do
  source 'https://example.com/installer.sh'
  mode '755'
  checksum 'sha256:abcd1234...'
end
```
**When to use**: Managing configuration files and downloading resources
**Expected output**: Files created/updated with proper permissions

### User and Group Management
```ruby
# Create group
group 'deploy' do
  gid 1001
end

# Create user with specific attributes
user 'deploy' do
  uid 1001
  gid 'deploy'
  home '/home/deploy'
  shell '/bin/bash'
  password '$6$salt$encrypted_password_hash'
  create_home true
end

# Add user to additional groups
node[:users].each do |username, attrs|
  user username do
    uid attrs[:uid]
    groups attrs[:groups]
    action :create
  end
end
```
**When to use**: Managing system users and groups
**Expected output**: Users and groups created with specified attributes

### Service Management with Guards
```ruby
# Conditional service restart
file '/etc/myapp/config.yml' do
  content node[:myapp][:config].to_yaml
  notifies :restart, 'service[myapp]', :delayed
end

service 'myapp' do
  action :nothing
  only_if 'systemctl is-enabled myapp'
end

# Start service only if config valid
service 'nginx' do
  action :start
  only_if 'nginx -t'
end
```
**When to use**: Managing services with conditional logic
**Expected output**: Services managed based on system state

### Custom Resources and Definitions
```ruby
# Define reusable resource for dotfiles
define :dotfile, source: nil do
  source_path = params[:source] || params[:name]
  link File.join(ENV['HOME'], params[:name]) do
    to File.expand_path("files/#{source_path}", __dir__)
    force true
  end
end

# Use the custom resource
dotfile '.vimrc'
dotfile '.tmux.conf'
dotfile '.config/nvim/init.vim' => 'nvim/init.vim'

# Define resource with template support
define :dotfile_template, source: nil, variables: {} do
  template_path = "#{ENV['HOME']}/#{params[:name]}"
  
  directory File.dirname(template_path) do
    owner ENV['USER']
  end
  
  template template_path do
    source "templates/#{params[:source]}"
    owner ENV['USER']
    variables params[:variables].merge(
      hostname: node[:hostname],
      user: ENV['USER']
    )
  end
end

# Use template resource
dotfile_template '.gitconfig' do
  source 'gitconfig.erb'
  variables(
    email: node[:git][:email],
    name: node[:git][:name]
  )
end
```
**When to use**: Reusable patterns for dotfiles and configs
**Expected output**: Consistent file deployment across machines

### Development Environment Setup
```ruby
# Developer workstation setup
include_recipe 'base.rb'

%w[git vim tmux zsh].each do |pkg|
  package pkg
end

git '/home/dev/dotfiles' do
  repository 'https://github.com/user/dotfiles.git'
  user 'dev'
  not_if 'test -d /home/dev/dotfiles'
end

execute 'install oh-my-zsh' do
  command 'sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
  user 'dev'
  not_if 'test -d /home/dev/.oh-my-zsh'
end
```
**When to use**: Standardizing development environments
**Expected output**: Consistent developer workstation configuration

### Multi-Machine Management with Node Attributes
```ruby
# Use node attributes to handle machine-specific configs
# node-desktop.json
{
  "hostname": "desktop",
  "packages": ["firefox", "thunderbird", "libreoffice"],
  "graphics": "nvidia"
}

# node-server.json  
{
  "hostname": "server",
  "packages": ["nginx", "postgresql", "redis"],
  "firewall": true
}

# main.rb - Single recipe handling all machines
node[:packages].each do |pkg|
  package pkg
end

if node[:graphics] == 'nvidia'
  package 'nvidia-driver'
end

if node[:firewall]
  service 'firewalld' do
    action [:enable, :start]
  end
end

# Deploy: mitamae local main.rb -j node-desktop.json
```
**When to use**: Managing few machines with different configurations
**Expected output**: Machine-specific settings applied via node attributes

## Implementation Details

### Installation and Setup
```bash
# Download mitamae binary
curl -L https://github.com/itamae-kitchen/mitamae/releases/latest/download/mitamae-x86_64-linux.tar.gz | tar xvz
chmod +x mitamae-x86_64-linux
sudo mv mitamae-x86_64-linux /usr/local/bin/mitamae

# macOS installation
curl -L https://github.com/itamae-kitchen/mitamae/releases/latest/download/mitamae-x86_64-darwin.tar.gz | tar xvz
chmod +x mitamae-x86_64-darwin
sudo mv mitamae-x86_64-darwin /usr/local/bin/mitamae
```
**Validation**: `mitamae version` shows version number
**Common errors**: `Permission denied` = add execute permission with chmod +x

### Local Execution
```bash
# Basic execution
mitamae local recipe.rb

# With node attributes
mitamae local recipe.rb --node-json=node.json

# Dry run to preview changes
mitamae local recipe.rb --dry-run

# With debug output
mitamae local recipe.rb --log-level=debug

# Multiple recipes
mitamae local base.rb packages.rb services.rb
```
**Validation**: Check exit code 0 and review output
**Common errors**: `Recipe not found` = check file path

### Recipe Organization
```bash
# Simple directory structure
recipes/
├── main.rb          # Main recipe file
├── packages.rb      # Package installations
├── dotfiles.rb      # Dotfile management
└── services.rb      # Service configuration

templates/           # Template files
├── nginx.conf.erb
└── config.yml.erb

files/              # Static files
└── motd

# Include recipes
include_recipe 'packages.rb'
include_recipe 'dotfiles.rb'
include_recipe File.expand_path('../services.rb', __FILE__)
```
**Validation**: Recipes load without syntax errors
**Common errors**: `LoadError` = check relative paths

### Resource Execution Flow
```ruby
# Understanding execution order
execute 'apt-get update' do
  action :run
end

package 'nginx' do
  action :install
  notifies :restart, 'service[nginx]', :immediately
end

service 'nginx' do
  action [:enable, :start]
end

# Resources execute in order unless using notifications
```
**Validation**: Resources apply in expected sequence
**Common errors**: `Service not found` = ensure package installed first

### Testing Recipes
```ruby
# Simple validation
execute 'validate nginx config' do
  command 'nginx -t'
  action :nothing
  subscribes :run, 'template[/etc/nginx/nginx.conf]'
end

# Using serverspec for testing
describe package('nginx') do
  it { should be_installed }
end

describe service('nginx') do
  it { should be_enabled }
  it { should be_running }
end
```
**Validation**: Tests pass after recipe execution
**Common errors**: `Command failed` = check syntax and dependencies

### Advanced Patterns
```ruby
# Enhanced platform detection
node.reverse_merge!(
  platform: node[:platform] || `uname -s`.strip.downcase,
  hostname: node[:hostname] || `hostname -s`.strip,
  arch: `uname -m`.strip
)

# Detect specific distributions
if node[:platform] == 'linux'
  if File.exist?('/etc/arch-release')
    node[:distro] = 'arch'
  elsif File.exist?('/etc/void-release')
    node[:distro] = 'void'
  elsif File.exist?('/etc/fedora-release')
    node[:distro] = 'fedora'
  elsif File.exist?('/etc/lsb-release')
    node[:distro] = 'ubuntu'
  end
end

# Package manager selection
case node[:distro]
when 'arch'
  define :install_package, name: nil do
    execute "install #{params[:name]}" do
      command "pacman -S --noconfirm #{params[:name]}"
      not_if "pacman -Q #{params[:name]}"
    end
  end
when 'void'
  define :install_package, name: nil do
    execute "install #{params[:name]}" do
      command "xbps-install -y #{params[:name]}"
      not_if "xbps-query #{params[:name]}"
    end
  end
end

# Dynamic resource creation
node[:packages].each do |pkg_name, pkg_config|
  package pkg_name do
    version pkg_config[:version] if pkg_config[:version]
    action pkg_config[:action] || :install
  end
end

# Local Ruby blocks for complex logic
local_ruby_block 'process config' do
  block do
    config = YAML.load_file('/tmp/config.yml')
    File.write('/etc/app/processed.conf', config.to_json)
  end
end
```
**Validation**: Platform correctly detected and resources created
**Common errors**: `undefined method` = check mruby limitations

### Plugin System
```bash
# Install mitamae plugins
mkdir -p plugins
git clone https://github.com/itamae-plugins/mitamae-plugin-resource-cron plugins/mitamae-plugin-resource-cron
git clone https://github.com/itamae-plugins/mitamae-plugin-resource-deploy_revision plugins/mitamae-plugin-resource-deploy_revision

# Plugins are auto-loaded from ./plugins directory
mitamae local recipe.rb  # Automatically finds ./plugins/*
```
**Validation**: Plugins load without errors
**Common errors**: `Plugin not found` = ensure plugins directory exists

### Using Plugins in Recipes
```ruby
# With cron plugin installed
cron 'backup' do
  minute '0'
  hour '3'
  command '/usr/local/bin/backup.sh'
  user 'backup'
end

# With deploy_revision plugin
deploy_revision '/var/www/app' do
  repo 'https://github.com/user/app.git'
  revision 'master'
  user 'deploy'
end
```
**Validation**: Resource types available after plugin install
**Common errors**: `undefined method` = check plugin installed correctly

### Installation Wrapper Script
```bash
#!/bin/bash
# install.sh - Download mitamae and run recipes

MITAMAE_VERSION="1.14.0"
MITAMAE_ARCH="x86_64"

# Detect OS
case "$(uname)" in
  "Linux")  MITAMAE_OS="linux" ;;
  "Darwin") MITAMAE_OS="darwin" ;;
  *) echo "Unsupported OS"; exit 1 ;;
esac

# Download mitamae if not present
if [ ! -f "bin/mitamae" ]; then
  mkdir -p bin
  curl -fL "https://github.com/itamae-kitchen/mitamae/releases/download/v${MITAMAE_VERSION}/mitamae-${MITAMAE_ARCH}-${MITAMAE_OS}.tar.gz" | tar xvz -C bin
fi

# Detect hostname for node file
HOSTNAME=$(hostname -s)
NODE_FILE="nodes/${HOSTNAME}.json"

# Use default node file if host-specific doesn't exist
[ ! -f "$NODE_FILE" ] && NODE_FILE="nodes/default.json"

# Run mitamae
if [ "$1" = "-n" ]; then
  bin/mitamae local recipes/main.rb -j "$NODE_FILE" --dry-run
else
  bin/mitamae local recipes/main.rb -j "$NODE_FILE"
fi
```
**Validation**: Script downloads mitamae and runs recipes
**Common errors**: `curl failed` = check internet connection

## Troubleshooting

### Recipe Syntax Errors
**Symptoms**: `SyntaxError` during execution
**Cause**: Invalid Ruby syntax or mruby limitations
**Fix**: Validate syntax with `ruby -c recipe.rb`, check mruby compatibility

### Resource Not Found
**Symptoms**: `NoMethodError: undefined method 'resource_name'`
**Cause**: Resource type not available or typo
**Fix**: Check available resources, verify spelling

### Service Management Failures
**Symptoms**: Service fails to start or enable
**Cause**: Systemd/init system differences, missing dependencies
**Fix**: Use platform-specific service commands, ensure packages installed

### Permission Denied
**Symptoms**: `Errno::EACCES: Permission denied`
**Cause**: Insufficient privileges for system changes
**Fix**: Run with sudo: `sudo mitamae local recipe.rb`

### Template Rendering Errors
**Symptoms**: `NameError` in template
**Cause**: Missing variables in template context
**Fix**: Ensure all variables passed to template:
```ruby
template '/etc/config' do
  variables(
    required_var: 'value',
    another_var: node[:attribute]
  )
end
```

### Cross-Platform Issues
**Symptoms**: Recipe works on one OS but fails on another
**Cause**: Platform-specific commands or paths
**Fix**: Use node[:platform] conditionals:
```ruby
package node[:platform] == 'debian' ? 'apache2' : 'httpd'
```

### Node Attribute Missing
**Symptoms**: `NoMethodError: undefined method '[]' for nil`
**Cause**: Accessing nested attributes that don't exist
**Fix**: Use safe navigation or defaults:
```ruby
port = node[:app] && node[:app][:port] || 3000
# or
port = node.dig(:app, :port) || 3000
```

### Handler Loading Failures
**Symptoms**: Handler not executing
**Cause**: Incorrect handler path or structure
**Fix**: Use absolute paths: `--handler=/path/to/handler.rb`

## Authoritative References

- [Official mitamae Repository](https://github.com/itamae-kitchen/mitamae)
- [Itamae Documentation](https://github.com/itamae-kitchen/itamae)
- [Itamae Wiki - Resources](https://github.com/itamae-kitchen/itamae/wiki/Resources)
- [Itamae Wiki - Node Attributes](https://github.com/itamae-kitchen/itamae/wiki/Node-Attributes)
- [mruby Official Site](https://mruby.org/)
- [Specinfra Repository](https://github.com/mizzy/specinfra)