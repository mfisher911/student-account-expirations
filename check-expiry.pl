#!/usr/local/bin/perl

# Based on a list of student account names and IDs, report on the
# number of current (or close-to-current) courses to extend accounts.

use strict;
use warnings;
use ISIS_Feed;
use Text::CSV;
use IO::File;
use Data::Dumper;

my $src = 'expiring-urids.csv';

my $csv = Text::CSV->new( { binary => 1 } );
open my $fh, "<", $src or die "$src: $!";
readline($fh);    # skip Microsoft header row
$csv->column_names( $csv->getline($fh) );

# add header row
my @results = ( [ 'samaccountname', 'urid', 'course_count' ], );

while ( my $row = $csv->getline_hr($fh) ) {
    my $courses = find_user_courses( $row->{'URID'} );
    my $count   = 0;
    foreach my $i (@$courses) {
        # As of 2015-09-06, the STUDENROLL_ISIS file at least includes
        # 2015SPRING, 2015SUMMER, 2015FALL enrollments. Assume that any
        # of these should be counted; but this might need to be narrowed.
        if ( $i->{'crs_name'} =~ m{201[56]} ) {
            $count++;
        }
    }
    my $record = [ $row->{'samaccountname'}, $row->{'URID'}, $count ];
    push @results, $record;
    print Dumper($record);    # show some progress
}

close $fh;

$csv->eol("\r\n");
$fh = new IO::File "> expiring-urid-counts.csv";
foreach my $row (@results) {
    $csv->print( $fh, $row );
}
$fh->close;
