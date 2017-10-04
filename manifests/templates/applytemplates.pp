class pentaho::templates::applytemplates {

  # Copy templates to pentaho folder

  exec { "Apply Templates":
    command     => "cp -R ${pentaho::tmptemplatedir}/* ${pentaho::home}/ 2>/dev/null || :",
    path        => ['/bin'],
    cwd         => '/tmp/',
  }

  exec { "Clean Temp Template":
    command     => "rm -rf ${pentaho::tmptemplatedir}",
    path        => ['/bin'],
    cwd         => '/tmp/',
    require     => Exec["Apply Templates"],
  }

}
