#!/usr/bin/perl
use LWP::Simple;
use Switch;

# this script needs a readonly user for The Foreman
my $credentials = 'nagios:password';

$hosts = get("https://$credentials\@localhost/api/hosts?per_page=1000");
my @hosts = ( $hosts =~ /"name":"(\w+.\w+.\w+)"/g );
my $number_of_hosts = $#hosts;

my $ok = 0;
my $warning = 0;
my $critical = 0;
my $unknown = 0;

foreach ( @hosts ) {

	$status = get("https://$credentials\@localhost/api/hosts/$_/status");
	die "Couldn't get it!" unless defined $status;

	switch ($status) {
		case /No changes/       { $ok++; }
		case /Active/           { $warning++; }
		case /Out of sync/      { $warning++; }
		case /Pending/          { $warning++; }
		case /Error/            { $critical++; }
		else                    { print "who am i\n"; }
	}

}

my $performance_data = "|ok:$ok warning:$warning critical:$critical";

if ( $critical > 0 ) {
	print "CRITICAL - $critical/$number_of_hosts failed their last run|$performance_data";
	exit 2;
} elsif ( $warning > 0 ) {
	print "WARNING - $warning/$number_of_hosts have pending changes, have not reported for more than 4 hours or changed on their last run|$performance_data";
	exit 1;
} elsif ( $ok > 0 ) {
	print "$OK - $ok/$number_of_hosts are fine|$performance_data";
	exit 0;
} else {
	print "UNKNOWN - I have no idea how you got here, did the password expire?|$performance_data";
	exit 3;
}
