
use strict;
use warnings;

use Test::More;

use FindBin qw($Bin);
use lib "$Bin/../lib";

use Catalyst::Test q(Iota::PCS);
use HTTP::Request::Common qw(GET POST DELETE PUT);

use Package::Stash;

use Iota::PCS::TestOnly::Mock::AuthUser;

my $schema = Iota::PCS->model('DB');
my $stash  = Package::Stash->new('Catalyst::Plugin::Authentication');
my $user   = Iota::PCS::TestOnly::Mock::AuthUser->new;

$Iota::PCS::TestOnly::Mock::AuthUser::_id    = 1;
@Iota::PCS::TestOnly::Mock::AuthUser::_roles = qw/ admin /;

$stash->add_symbol( '&user',  sub { return $user } );
$stash->add_symbol( '&_user', sub { return $user } );
my $seq = 0;
eval {
    $schema->txn_do(
        sub {
            my ( $res, $c );
            ( $res, $c ) = ctx_request(
                POST '/api/indicator',
                [   api_key                   => 'test',
                    'indicator.create.name'   => 'FooBar',
                ]
            );
            ok( !$res->is_success, 'invalid request' );
            is( $res->code, 400, 'invalid request' );

            ( $res, $c ) = ctx_request(
                POST '/api/indicator',
                [   api_key                         => 'test',
                    'indicator.create.name'         => 'Foo Bar',
                    'indicator.create.formula'      => '1',
                    'indicator.create.axis_id'      => '1',
                    'indicator.create.explanation'  => 'explanation',
                    'indicator.create.source'       => 'me',
                    'indicator.create.goal_source'  => '@fulano',
                    'indicator.create.chart_name'   => 'pie',
                    'indicator.create.goal_operator'=> '>=',
                    'indicator.create.tags'         => 'you,me,she',
                    'indicator.create.indicator_roles'  => '_prefeitura',
                    'indicator.create.observations' => 'lala'
                ]
            );
            ok( $res->is_success, 'indicator created!' );
            is( $res->code, 201, 'created!' );
            use JSON qw(from_json);
            my $indicator = eval{from_json( $res->content )};


            use URI;
            my $uri = URI->new( $res->header('Location') );

            ( $res, $c ) = ctx_request(
                GET $uri->path . '/network_config',
            );
            my $list = eval{from_json( $res->content )};
            is_deeply( $list->{network_configs}, [], 'empty list');

            ( $res, $c ) = ctx_request(
                POST $uri->path . '/network_config/1',
                [   api_key                                     => 'test',
                    'indicator.network_config.upsert.unfolded_in_home' => 1,
                ]
            );
            my $insert = eval{from_json( $res->content )};
            is_deeply( $insert, {
                indicator_id => $indicator->{id},
                network_id   => 1
            }, 'ok insert');


            ( $res, $c ) = ctx_request(
                POST $uri->path . '/network_config/2',
                [   api_key                                     => 'test',
                    'indicator.network_config.upsert.unfolded_in_home' => 1,
                ]
            );

            my $insert2 = eval{from_json( $res->content )};
            is_deeply( $insert2, {
                indicator_id => $indicator->{id},
                network_id   => 2
            }, 'ok insert 2');

            ( $res, $c ) = ctx_request(
                GET $uri->path . '/network_config',
            );
            $list = eval{from_json( $res->content )};
            is( @{$list->{network_configs}}, 2, '2 itens');

            is($_->{unfolded_in_home}, 1, 'ok') for @{$list->{network_configs}};


            ( $res, $c ) = ctx_request(
                POST $uri->path . '/network_config/2',
                [   api_key                                     => 'test',
                    'indicator.network_config.upsert.unfolded_in_home' => 0,
                ]
            );
            is_deeply(eval{from_json( $res->content )}, $insert2, 'same insert, same result');

            ( $res, $c ) = ctx_request(
                GET $uri->path . '/network_config/2',
            );

            my $item = eval{from_json( $res->content )};
            is_deeply($item, {
                unfolded_in_home => 0
            }, 'item updated !! ');


            ( $res, $c ) = ctx_request( GET $uri->path);

            ok( $res->is_success, 'listing ok!' );
            is( $res->code, 200, 'list 200' );

            my $list_ind = eval{from_json( $res->content )};
            is( @{$list_ind->{network_configs}}, 2, '2 network_configs in detais of indicator');


            for (1..2){
                ( $res, $c ) = ctx_request(
                    DELETE $uri->path . '/network_config/' . $_
                );
                ok( $res->is_success, 'indicator deleted' );
                is( $res->code, 204, 'indicator deleted - 204 no content' );
            }

            ( $res, $c ) = ctx_request(
                GET $uri->path . '/network_config',
            );
            $list = eval{from_json( $res->content )};
            is_deeply( $list->{network_configs}, [], 'empty list');


            die 'rollback';
        }
    );

};

die $@ unless $@ =~ /rollback/;

done_testing;
