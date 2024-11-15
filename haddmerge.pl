#!/usr/bin/perl -w
#
# Merge .root files with matching name bases by adding histograms
# they contain, using the ROOT utility hadd. Note that the paths
# in the names of output files are relative to the directory "output/".
#
# This script is distributed under the GNU Public Licence
# version 2 or newer, as chosen by the user.
#
# Copyright (c) 2006 Marek SZUBA, LBNL / WUT
#
# $Id: haddmerge.pl,v 1.7 2007/09/10 22:23:29 cyberman Exp $
#

use strict;

my ($workdir, $step) = @ARGV;
$workdir = "output/to_merge/" unless $workdir;
$step = 10 unless $step;
my ($allsets, $status) = ( 0, 0 );
my %filesets;

chdir "$workdir" || die "Cannot chdir to $workdir: $!";

opendir(IN, ".") || die "Cannot open directory: $!";
while ($_ = readdir(IN)) {
	push @{$filesets{$1}}, $_ if (m/(.+)_(\d+)_(\d+)_ana.root$/);
}
closedir(IN);

# Just to make things easier for tracking multiple merges in one log file
print "\nMerge started on ", scalar gmtime, " on host $ENV{HOSTNAME}\n\n";

while (my ($setid, $list) = each %filesets) {
	my $stage = 0;
	my $outfile = "${setid}_full.root";

	$list = mergestep($step, $setid, $list, ++$stage) while (@{$list} > 1);

	rename "tmpf_${setid}_${stage}_0.root", "$outfile";
	if ( -e "$outfile" ) {
		print "Output file $outfile successfully created in $stage passes\n\n";
#		unlink <tmpf_${setid}_*.root>;
	} else {
		++$status;
	}
	++$allsets;
}
print "There were $status failures for $allsets merge sets\n";
exit $status;


sub mergestep
{
	my ($step, $setid, $files, $stage) = @_;
	$stage = 0 unless defined $stage;
	my @newlist;
	my $idx = 0;

	while (my @segment = splice @$files, 0, $step) {
		my $newf;
		if (@segment == 1) {
			$newf = $segment[0];
		} else {
			$newf = "tmpf_${setid}_${stage}_$idx.root";
			++$idx;
			if (! -e "$newf") {
				system("hadd", "-f", "$newf", @segment);
				print "\n";
			}
		}
		push @newlist, $newf;
	}
	return \@newlist;
}
