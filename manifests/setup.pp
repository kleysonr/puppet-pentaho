class pentaho::setup {

  if $pentaho::dist == 'ce' {

    include pentaho::ce

  }

  elsif $pentaho::dist == 'ee' {

    notify { "Installation for Pentaho EE not implemented yet": }

  }

  else {

    err( "pentaho::params::dist '${pentaho::dist}' not allowed. Choose only 'ce' or 'ee'." )

  }
}
