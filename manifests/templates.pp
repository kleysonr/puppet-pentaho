class pentaho::templates {

  anchor {'pentaho::templates::begin' : } ->
  class { '::pentaho::templates::fetchtemplates' : } ->
  class { '::pentaho::templates::applytokens' : } ->
  class { '::pentaho::templates::applytemplates' : } ->
  anchor {'pentaho::templates::end' : }

}
