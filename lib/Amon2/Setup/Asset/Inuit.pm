package Amon2::Setup::Asset::Inuit;
use strict;
use warnings;
use 5.008001;
use File::Spec::Functions;

my ($vol, $dir, $file) = File::Spec->splitpath($INC{"Amon2/Setup/Asset/Inuit.pm"});

sub inuit_path {
    return catdir($dir, "inuit");
}



1;
__END__

=encoding utf8

=head1 NAME

Amon2::Setup::Asset::Inuit -

=head1 SYNOPSIS

  use Amon2::Setup::Asset::Inuit;

=head1 DESCRIPTION

Amon2::Setup::Asset::Inuit is

=head1 AUTHOR

Kazuhiro Shibuya E<lt>stevenlabs at gmail dot comE<gt>

=head1 SEE ALSO

=head1 LICENSE

Copyright (C) Kazuhiro Shibuya

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
