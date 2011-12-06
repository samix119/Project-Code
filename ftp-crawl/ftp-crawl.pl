use Net::FTP::File;

use strict;

my $ftp = Net::FTP->new("someserver", Debug => 0)
      or die "Cannot connect to some.host.name: $@";

$ftp->login("user",'pass')
      or die "Cannot login ", $ftp->message;

my @remote_files = $ftp->ls();
crawl_tree(\@remote_files,'/');

$ftp->quit;

=pod
This recursive function adapted by the excellent documentation by Gerard Lanois
http://www.foo.be/docs/tpj/issues/vol4_4/tpj0404-0009.html
sub crawl_tree {

      Get a list of all directories and files in the current directory;

      for (each item in the list) {
          if (item is a directory) {
              Save the current FTP remote working directory;
              Change into the directory called "item";
              crawl_tree();
              Restore the remote working directory to what it was before;
          }
      }
  }
=cut

sub crawl_tree {

        my($ref_remote_files,$oldpwd) = @_;

        my @array_list = @$ref_remote_files;

        foreach(@array_list) {
                if($ftp->isdir($_)) {
                #       print "$_ is a directory\n";
                        my $oldpwd = $ftp->pwd;
                #       print "oldpwd is $oldpwd, now decending into $_\n";
                        $ftp->cwd($_);
                        @remote_files = $ftp->ls();
                        crawl_tree(\@remote_files,$oldpwd);
                        $ftp->cwd($oldpwd);
                }
                print "$oldpwd",$ftp->pwd,"/$_\n" if($ftp->isfile($_));

        }
}

