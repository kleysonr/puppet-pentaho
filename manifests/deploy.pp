class pentaho::deploy {

  $tmpPentahoSoftware = '/tmp/pentaho-sw.zip'

  if $pentaho::source == "" {
    fail("pentaho::params::source not defined.")
  }

  include pentaho::system

  $timestamp = generate('/bin/date', '+%Y%m%d%H%M%S')
  $bkpdir = "${pentaho::home}_${timestamp}" 

  # Backup old installation

  if $pentaho::backup {

    exec { "Backup Pentaho Home":
      command     => "mv ${pentaho::home} ${bkpdir} 2>/dev/null",
      path        => ['/bin'],
      cwd         => '/tmp/',
    }

  } else {

    exec { "Clean Pentaho Home":
      command     => "rm -rf ${pentaho::home}",
      path        => ['/bin'],
      cwd         => '/tmp/',
    }

  }

  # Install new package

  #file { "$pentaho::source":
  file { $tmpPentahoSoftware:
    ensure => file,
    source => $pentaho::source, 
  }

  file { $pentaho::home:
    ensure => directory,
    owner  => $pentaho::user,
    group  => $pentaho::group,
    mode   => "0750",
  }

  exec { "Unzip Pentaho Package":
    #command     => "unzip -o ${pentaho::source} -d ${pentaho::home}",
    command     => "unzip -o ${tmpPentahoSoftware} -d ${pentaho::home}",
    #require     => [ File[$pentaho::source], File[$pentaho::home] ],
    require     => [ File[$tmpPentahoSoftware], File[$pentaho::home] ],
    path        => ['/usr/bin', '/usr/sbin'],
    cwd         => '/tmp/',
  }

}
