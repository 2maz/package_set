#
# Orocos Specific ignore rules
#
# Ignore log files generated from the orocos/orogen components
ignore(/\.log$/, /\.ior$/, /\.idx$/)
# Ignore all text files except CMakeLists.txt
ignore(/(^|\/)(?!CMakeLists)[^\/]+\.txt$/)
# We don't care about the manifest being changed, as autoproj *will* take
# dependency changes into account
ignore(/manifest\.xml$/)
# Ignore vim swap files
ignore(/\.sw?$/)
# Ignore the numerous backup files
ignore(/~$/)
configuration_option 'ROCK_FLAVOR', 'string',
    :default => 'stable',
    :values => ['stable', 'next', 'master'],
    :doc => [
        "Which flavor of Rock do you want to use ?",
        "The 'stable' flavor is not updated often, but will contain well-tested code",
        "The 'next' flavor is updated more often, and might contain less tested code",
        "it is updated from 'master' to test new features before they get pushed in 'stable'",
        "Finally, 'master' is where the development takes place. It should generally be in",
        "a good state, but will break every once in a while",
        "",
        "See http://rock-robotics.org/startup/releases.html for more information"]

if ENV['ROCK_FORCE_FLAVOR']
    Autoproj.change_option('ROCK_FLAVOR', ENV['ROCK_FORCE_FLAVOR'])
end

# Setup handling to override the list of default packages in next and stable
#
# The actual lists are created in overrides.rb
@default_packages = Hash.new
@default_packages['next'] = Hash.new
@default_packages['stable'] = Hash.new
def only_in_next
    flavor = Autoproj.user_config('ROCK_FLAVOR')
    yield if flavor == 'next'
end
def enable_in_next(*packages)
    @default_packages['next'][current_package_set.name] ||= Set.new
    @default_packages['next'][current_package_set.name] |= packages.to_set
end

def only_in_stable(*package_names)
    flavor = Autoproj.user_config('ROCK_FLAVOR')
    yield if flavor == 'stable'
end
def enable_in_stable(*packages)
    @default_packages['stable'][current_package_set.name] ||= Set.new
    @default_packages['stable'][current_package_set.name] |= packages.to_set
end

