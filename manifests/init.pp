class pentaho 
(
  $dist = $::pentaho::params::dist,
  $version = $::pentaho::params::version,
  $source = $::pentaho::params::source,
  $user = $::pentaho::params::user,
  $group = $::pentaho::params::group,
  $home = $::pentaho::params::home,
  $backup = $::pentaho::params::backup,
  $tmptemplatedir = $::pentaho::params::tmptemplatedir,

) inherits ::pentaho::params {

  anchor {'pentaho::begin' : } ->
  class { '::pentaho::setup' : } ->
  anchor {'pentaho::end' : }

}
