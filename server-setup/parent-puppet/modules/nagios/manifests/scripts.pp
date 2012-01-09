class nagios::scripts {

        define put_scripts($ensure) {
                notify {"Procesing: $name":}

                file {"/usr/lib64/nagios/plugins/${name}":
                        source => "puppet:///modules/nagios/${name}",
                        owner => root,
                        group => root,
                        ensure => $ensure,
                }
        }
}

