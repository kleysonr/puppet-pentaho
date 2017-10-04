class pentaho::ce {

  notify { "Installing pentaho-${pentaho::dist}-${pentaho::version} ...": }

  anchor {'pentaho::ce::begin' : } ->
  class { '::pentaho::deploy' : } ->
  class { '::pentaho::templates' : } ->
  anchor {'pentaho::ce::end' : }

}
