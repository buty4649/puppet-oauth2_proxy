# == Class: oauth2_proxy
#
class oauth2_proxy(
  String $user                       = $::oauth2_proxy::params::user,
  Boolean $manage_user               = $::oauth2_proxy::params::manage_user,
  String $group                      = $::oauth2_proxy::params::group,
  Boolean $manage_group              = $::oauth2_proxy::params::manage_group,
  Stdlib::Absolutepath $install_root = $::oauth2_proxy::params::install_root,
  String $source                     = $::oauth2_proxy::params::source,
  String $checksum                   = $::oauth2_proxy::params::checksum,
  Stdlib::Absolutepath $systemd_path = $::oauth2_proxy::params::systemd_path,
  Stdlib::Absolutepath $shell        = $::oauth2_proxy::params::shell,
  String $provider                   = $::oauth2_proxy::params::provider,
) inherits oauth2_proxy::params {

  if $manage_user {
    user { $user:
      gid    => $group,
      system => true,
      home   => '/',
      shell  => $shell,
    }
  }

  if $manage_group {
    group { $group:
      ensure => present,
      system => true,
    }
  }

  anchor { '::oauth2_proxy::begin': }
    -> class { '::oauth2_proxy::install': }
      ~> Oauth2_proxy::Instance<| |>
        -> anchor { '::oauth2_proxy::end': }
}
