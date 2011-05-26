package Amon2::Setup::Asset::Spine;
use strict;
use warnings;
use 5.008001;
use File::Slurp;
use File::Spec::Functions;

my ($vol, $dir, $file) = File::Spec->splitpath($INC{"Amon2/Setup/Asset/Spine.pm"});

sub spine {
    my $text = read_file(catdir($dir, "spine", "spine.js"));
    return $text;
}

sub spine_min {
    my $text = read_file(catdir($dir, "spine", "spine.min.js"));
    return $text;
}

sub spine_list {
    my $text = read_file(catdir($dir, "spine", "lib", "spine.list.js"));
    return $text;
}

sub spine_model_local {
    my $text = read_file(catdir($dir, "spine", "lib", "spine.model.local.js"));
    return $text;
}

sub spine_tabs {
    my $text = read_file(catdir($dir, "spine", "lib", "spine.tabs.js"));
    return $text;
}

sub spine_manager {
    my $text = read_file(catdir($dir, "spine", "lib", "spine.manager.js"));
    return $text;
}

sub spine_route {
    my $text = read_file(catdir($dir, "spine", "lib", "spine.route.js"));
    return $text;
}

sub spine_tmpl {
    my $text = read_file(catdir($dir, "spine", "lib", "spine.tmpl.js"));
    return $text;
}

sub spine_model_ajax {
    my $text = read_file(catdir($dir, "spine", "lib", "spine.model.ajax.js"));
    return $text;
}

sub spine_route_shim {
    my $text = read_file(catdir($dir, "spine", "lib", "spine.route.shim.js"));
    return $text;
}

1;
__END__

=encoding utf8

=head1 NAME

Amon2::Setup::Asset::Spine -

=head1 SYNOPSIS

  use Amon2::Setup::Asset::Spine;

=head1 DESCRIPTION

Amon2::Setup::Asset::Spine is

=head1 AUTHOR

Kazuhiro Shibuya E<lt>stevenlabs at gmail dot comE<gt>

=head1 SEE ALSO

=head1 LICENSE

Copyright (C) Kazuhiro Shibuya

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
