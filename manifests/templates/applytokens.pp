class pentaho::templates::applytokens {

  notify { "Replace tokens on the template files.": }

  # If PENTAHO_ENV facter null, set a default value
  if $facts['pentaho_env'] {
    $_pentaho_env = $::pentaho_env
  } 
  else {
    $_pentaho_env = '-'
  }

  $templates = getTemplatesList([
               "puppet:///modules/pentaho/fs/files",
               "puppet:///modules/pentaho/fs/${pentaho::dist}/files",
               "puppet:///modules/pentaho/fs/${pentaho::dist}/${pentaho::version}/files",
               "puppet:///modules/pentaho/fs/${pentaho::dist}/${pentaho::version}/${fqdn}/files",
               "puppet:///modules/pentaho/fs/${pentaho::dist}/${pentaho::version}/${_pentaho_env}/files",
               "puppet:///modules/pentaho/fs/${pentaho::dist}/${pentaho::version}/${fqdn}/${_pentaho_env}/files",
  ])

  # function call with lambda:

  $templates.each |Array $template| {

    $file = "${$pentaho::tmptemplatedir}/${template[1]}"

    file {$file:
      ensure => file,
      content => template("${template[0]}/${template[1]}"),
    }
  }

}
