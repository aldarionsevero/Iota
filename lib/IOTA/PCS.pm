package IOTA::PCS;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

# Set flags and add plugins for the application.
#
# Note that ORDERING IS IMPORTANT here as plugins are initialized in order,
# therefore you almost certainly want to keep ConfigLoader at the head of the
# list if you're using it.
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/
    ConfigLoader
    Static::Simple
    Unicode::Encoding
    Params::Nested

    Authentication
    Authorization::Roles

    +CatalystX::Plugin::Logx

/;

extends 'Catalyst';

our $VERSION = '0.01';

# Configure the application.
#
# Note that settings in iota_pcs.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config(
    name => 'IOTA::PCS',
    encoding => 'UTF-8',

    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,
    enable_catalyst_header                      => 1,    # Send X-Catalyst header

    private_path => 'root/static/user',
    public_url   => '/static/user',

);

after 'setup_components' => sub {
    my $app = shift;
    for ( keys %{ $app->components } ) {
        if ( $app->components->{$_}->can('initialize_after_setup') ) {
            $app->components->{$_}->initialize_after_setup($app);
        }
    }



};

after setup_finalize => sub {
    my $app = shift;

    for ( $app->registered_plugins  ) {
        if ( $_->can('initialize_after_setup') ) {
            $_->initialize_after_setup($app);
        }
    }
};



# Start the application
__PACKAGE__->setup();

=head1 NAME

IOTA::PCS - Catalyst based application

=head1 SYNOPSIS

    script/iota_pcs_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<IOTA::PCS::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Thiago Rondon

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;