class pentaho::templates::fetchtemplates {

  # Fetch all the template files

  # If PENTAHO_ENV facter null, set a default value
  if $facts['pentaho_env'] {
    $_pentaho_env = $::pentaho_env
  }
  else {
    $_pentaho_env = '-'
  }

  file { $pentaho::tmptemplatedir:
    ensure => present,
    recurse => true,
    sourceselect => "all",
    source => [
               "puppet:///modules/pentaho/fs/files",
               "puppet:///modules/pentaho/fs/${pentaho::dist}/files",
               "puppet:///modules/pentaho/fs/${pentaho::dist}/${pentaho::version}/files",
               "puppet:///modules/pentaho/fs/${pentaho::dist}/${pentaho::version}/${fqdn}/files",
               "puppet:///modules/pentaho/fs/${pentaho::dist}/${pentaho::version}/${_pentaho_env}/files",
               "puppet:///modules/pentaho/fs/${pentaho::dist}/${pentaho::version}/${fqdn}/${_pentaho_env}/files",
    ],
    owner  => $pentaho::user,
    group  => $pentaho::group,
  }

}
