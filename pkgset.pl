#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

# get the packages you want to have installed on the system
sub get_declared_packages()
{
    my @pkg;
    if ( -d "/etc/pkgset.conf.d/" ) {
        my @result = `cat /etc/pkgset.conf.d/*`;
        push @pkg, @result;
    }
    if ( -f "/etc/pkgset.conf" ) {
        my @result = `cat /etc/pkgset.conf`;
        push @pkg, @result;
    }
    for (@pkg) {
        chomp;
        if ($_ !~ m/--/) {
            $_ .= "--";
        }
    }
    push @pkg, "quirks--"; #mandatory package

    # remove duplicates
    my %hash = map { $_, 1 } @pkg;
    return keys %hash;
}

# check what is currently installed
sub get_installed_packages()
{
    my @pkg = `pkg_info -mz`;
    for (@pkg) {
        chomp;
        if ($_ !~ m/--/) {
            $_ .= "--";
        }
    }
    return @pkg;
}

my @installed = get_installed_packages;
my @wanted = get_declared_packages;

my @autoinstall;
my @toinstall;

# check for installed
FIRST: for my $current (@installed) {
    SECOND: for my $w (@wanted) {
        if ($w eq $current) {
            next FIRST;
        }
    }
    push @autoinstall, $current;
}

# check for missing packages to install
FIRST: for my $w (@wanted) {
    SECOND: for my $current (@installed) {
        if ($w eq $current) {
            next FIRST;
        }
    }
    push @toinstall, $w;
}

for my $pkg (@autoinstall) {
    print "Marking $pkg as auto installed\n";
    `pkg_add -aa $pkg`;
}
for my $pkg (@toinstall) {
    print "Installing $pkg\n";
    `pkg_add -I $pkg`;
}

print "Running pkg_delete -a to delete unused dependencies (if any)\n";
`pkg_delete -a`;
print "Done\n";
