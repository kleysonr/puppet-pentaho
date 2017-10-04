class pentaho::system {

  # Create user/group for pentaho

  group { $pentaho::group:
    ensure => 'present',
  }

  user { $pentaho::user:
    ensure           => "present",
    home             => "/home/${pentaho::user}",
    comment           => "Pentaho admin user",
    groups            => "${pentaho::group}",
    password         => "!!",
    password_max_age => "99999",
    password_min_age => "0",
    shell            => "/bin/bash",
    managehome => true,
    require => Group[$pentaho::group],
  }

  file { "/home/${pentaho::user}":
    mode => "0750",
    require => User[$pentaho::user],
  }

}
