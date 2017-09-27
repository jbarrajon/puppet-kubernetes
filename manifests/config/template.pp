#
define kubernetes::config::template (
  $template,
  $options = {},
  $path    = ''
) {

  validate_hash($options)
  validate_string($path)

  file { "${path}/${name}":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template($template),
  }

}
