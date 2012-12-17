package BananaDuck;

use Mojo::Base 'Mojolicious';
use BananaDuck::Schema;
use BananaDuck::Config;
use Data::Dumper;
use Resque;

has schema => sub {
    BananaDuck::Schema->connect;
};

has resque => sub {
    Resque->new;
};

# preload few namespaces
BEGIN {
    require Mojo::Loader;
    my $loader = Mojo::Loader->new;
    my @namespaces = qw(
        BananaDuck::API::Method
        BananaDuck::API::Result
        BananaDuck::Validation::Rule
        BananaDuck::Exception::OAuth
    );

    for my $ns (@namespaces) {
        for my $module (@{$loader->search($ns)}) {
            my $e = $loader->load($module);
            die $e if ref $e;
        }
    }
}

# This method will run once at server start
sub startup {
    my $self = shift;

    my $config = BananaDuck::Config->instance->config;

    $self->sessions->default_expiration($config->{session}{default_expiration});
    $self->sessions->cookie_name($config->{session}{cookie_name});

    $self->secret('c58ed91d3b9adaf151bccafc637be22b');

    $self->config($config);

    $self->helper(db => sub { return $self->schema });
    $self->helper(resque => sub { return $self->resque });

    $self->plugin('authentication' => { # Mojolicious::Plugin::Authentication
        autoload_user => 1,

        load_user => sub {
            my ($app, $user_id) = @_;
            my $user = $app->db->resultset('User')->find($user_id);
            return $user;
        },

        validate_user => sub {
            my ($app, $username, $password, $extradata) = @_;

            my $user = $app->db->resultset('User')->by_credentials($username, $password);

            return $user ? $user->id : undef;
        },
    });

    $self->hook(before_dispatch => sub { # set lang from Accept-Language
        my ($c) = @_;
        $self->log->debug("Session: ".Dumper($c->session));

        my $accept_language = $c->req->headers->accept_language;
        my $lang;

        if (defined $accept_language and ($lang) = $accept_language =~ /(\w+)/) {
            $c->stash(lang => $lang);
        }
        $self->log->debug(sprintf "Detected lang: %s (header: %s)", map $_ // 'none', $lang, $accept_language);
    });

    # Routes
    my $r = $self->routes;
    $r->namespace('BananaDuck::Controller');

    $r->route('/')->to('home#index');
    $r->route('/login')->to('login#process');
    $r->route('/logout')->to('logout#process');

    $r->route('/image/resize')->to('API#resize_image');

    my $api = $r->route('/api')->to(controller => 'API', action => 'call_api');

    # Older versions of Mojolicious don't like the 'method' stash value, so it's 'api_method'.
    # Methods that change the underlying data are called via POST.

    # Methods that're called via GET
    $api->route('/*api_method', api_method => [qw(
        checkEmail
        checkLogin
        country/codes
        cuisine/list
        dish/comments
        dish/search
        ping
        place/search
        place/types
        user/dishes
        user/favorites
        user/feed
        user/info
        user/likes
        user/places
        user/postedEvents
        user/profile
    )])->via('get');
    # Combine some similar methods
    $api->route('/user/:member_type', member_type => [qw(followers followees)])
        ->via('get')->to(api_method => 'user/network');

    # Methods that're called via POST
    $api->route('/*api_method', api_method => [qw(
        comment/add
        cuisine/add
        cuisine/delete
        dish/add
        dish/delete
        dish/flag
        dish/update
        image/resize
        login
        loginViaFB
        logout
        place/add
        place/addType
        place/delete
        place/deleteType
        place/update
        user/changePassword
        user/connectFB
        user/delete
        user/deleteAvatar
        user/disconnectFB
        user/register
        user/resetPassword
        user/update
        user/updateAvatar
        user/updatePostedEvents
    )])->via('post');
    # Combine some similar methods
    $api->route('/user/:operation', operation => [qw(follow unfollow)]) # 'action' is reserved
        ->via('post')->to(api_method => 'user/follow');
    $api->route('/dish/:operation', operation => [qw(favorite unfavorite)])
        ->via('post')->to(api_method => 'dish/favorite');
    $api->route('/dish/:operation', operation => [qw(like unlike)])
        ->via('post')->to(api_method => 'dish/like');

    #my $fb_auth_bridge = $r->bridge->to('facebook#authorize');
    #$fb_auth_bridge->route('/registration/facebook')->to(controller => 'Registration::Facebook', action => 'process');

    my $registration = $r->route('/registration')->to(controller => 'registration');

    $registration->route('/')->to(action => 'process');  # registration on the site
    $registration->bridge->to('facebook#authorize')->route('/facebook')->to(controller => 'Registration::Facebook', action => 'process');
    $registration->route('/twitter/:action', action => [qw(process callback)])->to(controller => "Registration::Twitter", action => 'process');

    $registration->route('/confirm/:code')->to(action => 'confirm')->name('email_confirmation');
    $registration->route('/email-confirmed')->to(action => 'email_confirmed')->name('email_confirmed');
    $registration->route('/welcome')->to(action => 'welcome');
    $registration->route('/check-login')->to(action => 'check_login_availability');
    $registration->route('/check-email')->to(action => 'check_email_availability');

    $r->route('/resetpw/:code')->to('users#resetpw');

    my $auth_bridge = $r->bridge->to('auth#check');
    $auth_bridge->route('/users')->to('users#list'); # only visible to logged in users

    $auth_bridge->bridge->to('facebook#authorize')->route('/facebook/:operation', operation => [qw(connect disconnect)])->to('users#connect_facebook');
}

1;
