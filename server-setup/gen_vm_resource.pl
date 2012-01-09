#!/usr/bin/perl

print "class openvz::vm {\n";

while(<>) {

	next if ( $_ =~ /^#/);

        chomp;
        @ac = split(/\,/, $_);

        print "
        virt \{ \'$ac[1]\'\:
                ipaddr => ['$ac[2]'],
                ensure     => '$ac[10]',
                id       => $ac[0],
                os_template => '$ac[9]',
                virt_type  => 'openvz',
                autoboot   => 'false',
                ve_root => '$ac[3]/vz/root/\$VEID',
                ve_private => '$ac[3]/vz/private/\$VEID',
                configfile => 'vzsplit',
		resources_parameters => [\"VMGUARPAGES=$ac[4]\",\"OOMGUARPAGES=$ac[5]\",\"PRIVVMPAGES=$ac[6]\"],
		nameserver => '$ac[7]',
		diskspace => '$ac[8]',
        }\n";

}

print "}\n";

