#!/usr/bin/perl

package openvz;
use warnings;
use strict;

## function to return a hash of arrays, with the vpid as the key and status, ip, hostname as the values
sub list_vm {

        my @vpid_tuple;
        my %vpid_list;
        ## Get the list of vm's that we have on this box and thier related information
        open(VZLIST,"/usr/sbin/vzlist -H |");

        while(<VZLIST>) {
                chomp;
                $_ =~ s/\ +/\ /g ;
                $_ =~ s/^\ //g ;
                @vpid_tuple = split(/\ /,$_);
                $vpid_list{"$vpid_tuple[0]"} = [$vpid_tuple[4], $vpid_tuple[3], $vpid_tuple[2]];

        }

=pod
	## code to display the contents of the hash
        foreach my $group (sort {$a <=> $b} keys %vpid_list) {
        print "The members of $group are\n";
                foreach (@{$vpid_list{$group}}) {
                        print "\t$_\n";
                }
        }
=cut
        ## Return the hash reference
        return \%vpid_list;

}

## function that takes one argument, a vpid and then stops the vpid if it is running
sub stop_vm {

        my ($vpid) = @_;

        my $return_string = `/usr/sbin/vzctl stop $vpid`;
        return $return_string;
}

## function that takes one argument, a vpid and then restarts the vpid if it is running
sub restart_vm {

        my ($vpid) = @_;

        my $return_string = `/usr/sbin/vzctl restart $vpid`;
        return $return_string;
}

## function that takes one argument, a vpid and then starts the vpid if it is indeed stopped
sub start_vm {

        my ($vpid) = @_;

        my $return_string = `/usr/sbin/vzctl start $vpid`;
        return $return_string;
}

sub status_vm {

        my($vpid) = @_;
        my $status;

        my $return_string = `/usr/sbin/vzlist -ostatus $vpid -H`;

        if ($return_string =~ /running/) {
                $status = 1;
        }
        elsif ($return_string =~ /stopped/) {
                $status = 0;
        } else {
                $status = -1;
        }

        return ($status,$return_string);
}
1;

