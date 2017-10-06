#
# Export the variable FACTER_PENTAHO_ENV on the agent to set the facter pentaho_env on the server
#   export FACTER_PENTAHO_ENV=dev
#

node default {
  class { pentaho:
    backup => false,
  }
}
