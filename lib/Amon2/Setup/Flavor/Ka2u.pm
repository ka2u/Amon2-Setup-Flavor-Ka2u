package Amon2::Setup::Flavor::Ka2u;
use strict;
use warnings;
use 5.008001;
our $VERSION = '0.01';

use parent qw(Amon2::Setup::Flavor::Minimum);
use Amon2::Setup::Asset::Spine;
use Amon2::Setup::Asset::Inuit;
use File::Copy;
use Data::Dumper;

sub run {
    my $self = shift;

    $self->SUPER::run();

    $self->mkpath('htdocs/static/img/');
    $self->mkpath('htdocs/static/js/');
    $self->mkpath('log/');
    $self->mkpath('db/');

    $self->write_file('lib/<<PATH>>.pm', <<'...');
package <% $module %>;
use strict;
use warnings;
use parent qw/Amon2/;
our $VERSION='0.01';
use 5.008001;

use <% $module %>::DB;
use Log::Dispatch;

# __PACKAGE__->load_plugin(qw/DBI/);

sub db {
    my $self = shift;
    $self->{db} //= do {
        my $conf = $self->config->{teng} or die "missing db connection";
        <% $module %>::DB->new($conf);
    };
}

sub log {
    my $self = shift;
    $self->{log} //= do {
        Log::Dispatch->new(
            outputs => [
                ['File', min_level => 'debug', filename => 'log/development.log'],
            ],
        );
    };
}
1;
...

    $self->write_file('lib/<<PATH>>/Web.pm', <<'...');
package <% $module %>::Web;
use strict;
use warnings;
use parent qw/<% $module %> Amon2::Web/;
use File::Spec;

# load all controller classes
use Module::Find ();
Module::Find::useall("<% $module %>::Web::C");

# dispatcher
use <% $module %>::Web::Dispatcher;
sub dispatch {
    return <% $module %>::Web::Dispatcher->dispatch($_[0]) or die "response is not generated";
}

# setup view class
use Text::Xslate;
{
    my $view_conf = __PACKAGE__->config->{'Text::Xslate'} || +{};
    unless (exists $view_conf->{path}) {
        $view_conf->{path} = [ File::Spec->catdir(__PACKAGE__->base_dir(), 'tmpl') ];
    }
    my $view = Text::Xslate->new(+{
        'syntax'   => 'TTerse',
        'module'   => [ 'Text::Xslate::Bridge::TT2Like' ],
        'function' => {
            c => sub { Amon2->context() },
            uri_with => sub { Amon2->context()->req->uri_with(@_) },
            uri_for  => sub { Amon2->context()->uri_for(@_) },
        },
        %$view_conf
    });
    sub create_view { $view }
}

# load plugins
use HTTP::Session::Store::File;
__PACKAGE__->load_plugins(
    'Web::FillInFormLite',
    'Web::NoCache', # do not cache the dynamic content by default
    'Web::CSRFDefender',
    'Web::HTTPSession' => {
        state => 'Cookie',
        store => HTTP::Session::Store::File->new(
            dir => File::Spec->tmpdir(),
        )
    },
);

# for your security
__PACKAGE__->add_trigger(
    AFTER_DISPATCH => sub {
        my ( $c, $res ) = @_;
        $res->header( 'X-Content-Type-Options' => 'nosniff' );
    },
);

__PACKAGE__->add_trigger(
    BEFORE_DISPATCH => sub {
        my ( $c ) = @_;
        # ...
        return;
    },
);

1;
...

    $self->write_file("lib/<<PATH>>/Web/Dispatcher.pm", <<'...');
package <% $module %>::Web::Dispatcher;
use strict;
use warnings;
use Amon2::Web::Dispatcher::Lite;

any '/' => sub {
    my ($c) = @_;
    $c->render('index.tt');
};

1;
...

    $self->write_file("lib/<<PATH>>/DB.pm", <<'...');
package <% $module %>::DB;
use strict;
use warnings;
use parent 'Teng';
1;
...

    $self->write_file("lib/<<PATH>>/DB/Schema.pm", <<'...');
package <% $module %>::DB::Schema;
use Teng::Schema::Declare;
table {
    name '';
    pk '';
    columns qw();
};
1;
...

    $self->write_file("config/development.pl", <<'...');
+{
    teng => +{ 
        'connect_info' => [
            'dbi:SQLite:dbname=development.db',
            '',
            '',
            +{
                sqlite_unicode => 1,
            }
        ],
    }
};
...

    $self->write_file("config/production.pl", <<'...');
+{
    teng => +{ 
        'connect_info' => [
            'dbi:SQLite:dbname=production.db',
            '',
            '',
            +{
                sqlite_unicode => 1,
            }
        ],
    }
};
...

    $self->write_file("config/test.pl", <<'...');
+{
    teng => +{ 
        'connect_info' => [
            'dbi:SQLite:dbname=test.db',
            '',
            '',
            +{
                sqlite_unicode => 1,
            }
        ],
    }
};
...

    $self->write_file("sql/my.sql", '');
    $self->write_file("sql/sqlite3.sql", <<'...');
CREATE TABLE table (id INTEGER PRIMARY KEY ASC, );
INSERT INTO table () VALUES ();
...

    $self->write_file('tmpl/index.tt', <<'...');
[% WRAPPER 'include/layout.tt' %]

<hr class="space">

<h1>Template</h1>

<hr class="space">

[% END %]
...

    $self->{jquery_min_basename} = Amon2::Setup::Asset::jQuery->jquery_min_basename();
    $self->write_file('tmpl/include/layout.tt', <<'...');
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <title>[% title || '<%= $dist %>' %]</title>
    <meta http-equiv="Content-Style-Type" content="text/css" />  
    <meta http-equiv="Content-Script-Type" content="text/javascript" />  
    <meta name="viewport" content="width=device-width, minimum-scale=1.0, maximum-scale=1.0"]]>
    <meta name="format-detection" content="telephone=no" />
    <link href="[% uri_for('/static/inuit/inuit.css') %]" rel="stylesheet" type="text/css" media="screen" />
    <link href="[% uri_for('/static/inuit/style.css') %]" rel="stylesheet" type="text/css" media="screen" />
    <script src="[% uri_for('/static/js/<% $jquery_min_basename %>') %]"></script>
    <script src="[% uri_for('/static/spine/spine.js') %]"></script>
</head>
<body[% IF bodyID %] class="[% bodyID %]"[% END %]>
    <div class="container">
        <header>
            header
        </header>
        <div id="main">
            [% content %]
        </div>
        <footer>
            2011 learn2crawl.org
        </footer>
    </div>
</body>
</html>
...

    $self->write_file('htdocs/static/js/' . Amon2::Setup::Asset::jQuery->jquery_min_basename(), Amon2::Setup::Asset::jQuery->jquery_min_content());
    $self->_cp(Amon2::Setup::Asset::Spine->spine_path, 'htdocs/static/');
    $self->_cp(Amon2::Setup::Asset::Inuit->inuit_path, 'htdocs/static/');

#    $self->write_file('htdocs/static/css/main.css', <<'...');
#
#html {
#    color: #3d3d3d;
#    backgroundcolor: #ffffff;
#	background:-moz-linear-gradient(-90deg,#ffffff,#ffffff) fixed;
#	background:-webkit-gradient(linear,left top,left bottom,from(#ffffff),to(#ffffff)) fixed;
#}
#header {
#    height: 50px;
#    font-size: 36px;
#    padding: 2px; }
#    header a {
#        color: black;
#        font-weight: bold;
#        text-decoration: none; }
#
#footer {
#    padding-right: 10px;
#    padding-top: 2px; }
#    footer a {
#        text-decoration: none;
#        color: black;
#        font-weight: bold;
#    }
#
#/* smart phones */
#@media screen and (max-device-width: 480px) {
#}
#...

    $self->write_file("t/00_compile.t", <<'...');
use strict;
use warnings;
use Test::More;

use_ok $_ for qw(
    <% $module %>
    <% $module %>::Web
    <% $module %>::Web::Dispatcher
);

done_testing;
...

    $self->write_file("xt/02_perlcritic.t", <<'...');
use strict;
use Test::More;
eval q{
	use Perl::Critic 1.113;
	use Test::Perl::Critic 1.02 -exclude => [
		'Subroutines::ProhibitSubroutinePrototypes',
		'Subroutines::ProhibitExplicitReturnUndef',
		'TestingAndDebugging::ProhibitNoStrict',
		'ControlStructures::ProhibitMutatingListFunctions',
	];
};
plan skip_all => "Test::Perl::Critic 1.02+ and Perl::Critic 1.113+ is not installed." if $@;
all_critic_ok('lib');
...

    $self->write_file('.gitignore', <<'...');
Makefile
inc/
MANIFEST
*.bak
*.old
nytprof.out
nytprof/
development.db
test.db
...
}

sub _cp {
    my ($self, $from, $to) = @_;
    system("cp -Rp $from $to") == 0
        or die "external cp command status was $?";
}

1;
__END__

=encoding utf8

=head1 NAME

Amon2::Setup::Flavor::Ka2u -

=head1 SYNOPSIS

  use Amon2::Setup::Flavor::Ka2u;

=head1 DESCRIPTION

Amon2::Setup::Flavor::Ka2u is

=head1 AUTHOR

Kazuhiro Shibuya E<lt>stevenlabs at gmail dot comE<gt>

=head1 SEE ALSO

=head1 LICENSE

Copyright (C) Kazuhiro Shibuya

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
