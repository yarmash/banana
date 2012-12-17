package BananaDuck::API::Method;

use Mojo::Base -base;
use BananaDuck::Utils qw(get_salt get_password_hash);
use BananaDuck::Constants 'AUTH_TOKEN';
use BananaDuck::Message;
use File::Path 'mkpath';
use File::Basename 'dirname';

has auth_level => AUTH_TOKEN;
has params_info => sub { +{} }; # no parameters required/allowed by default
has 'ctx';

# shortcuts for backward compatibility
# TODO: replace these with calls to ctx
has schema => sub {
    my ($self) = @_;
    $self->ctx->schema;
};

has user => sub {
    my ($self) = @_;
    $self->ctx->user;
};

# validates incoming parameters
# on error throws the BananaDuck::Exception::API exception
sub validate_params {
    my ($self, $params) = @_;

    my $params_info = $self->params_info;

    while (my ($k, $v) = each $params) {
        if (! exists $params_info->{$k}) {
            BananaDuck::Exception::OAuth::InvalidRequest->throw(
                error_description => $self->format_message('exception.invalidRequest.unknownParameter', $k)
            );
        }

        if ($v eq "" && $params_info->{$k}{blank}) {
            undef $params->{$k}; # treat "" as NULL. TODO: this should probably be done at the model
            next;
        }

        if (my $validate = $params_info->{$k}{validate}) {
            my $error;

            if (!ref $validate) {
                my $class = "BananaDuck::Validation::Rule::$validate";
                $error = $class->new->validate($self->schema, $v);
            }
            elsif (ref $validate eq 'ARRAY') {
                my ($name, $args) = @$validate;
                my $class = "BananaDuck::Validation::Rule::$name";
                $error = $class->new($args)->validate($self->schema, $v);
            }
            else {
                die "Don't know how to validate $k with $validate";
            }

            if ($error) { # BananaDuck::Message
                my $error_description = $self->format_message('exception.invalidRequest.invalidParameterValue',
                    $k, $error->format($self->ctx->lang));

                BananaDuck::Exception::OAuth::InvalidRequest->throw(
                    error_description => $error_description,
                );
            }
        }
    }

    while (my ($k, $v) = each $params_info) {
        if ($v->{required} && !exists $params->{$k}) {
            BananaDuck::Exception::OAuth::InvalidRequest->throw(
                error_description => $self->format_message('exception.invalidRequest.missingParameter', $k),
            );
        }
    }

    return 1;
}

sub save_file {
    my ($self, $asset, $file_url) = @_;

    my $abs_path = $self->url2path($file_url);
    mkpath( dirname($abs_path) );

    $asset->move_to($abs_path);
}

sub delete_file {
    my ($self, $url) = @_; # url is relative with absolute path

    my $path = $self->url2path($url);
    unlink $path or warn "Could not unlink $path: $!";

    if (my @previews = $self->schema->resultset('Preview')->search({ image_url => $url })) {
        for my $preview (@previews) {
            my $preview_path = $self->url2path($preview->preview_url);
            unlink $preview_path or warn "Could not unlink $preview_path: $!";
            $preview->delete;
        }
    }

    return $path;
}

# converts an absolute path to a relative url with the absolute path
sub path2url {
    my ($self, $path) = @_;
    (my $url = $path) =~ s{^.*/public(?=/)}{};
    return $url;
}

sub url2path {
    my ($self, $url) = @_;
    return $self->ctx->home->rel_file("public$url");
}

# get result objects for a single page out of a resultset
sub get_result_page {
    my ($self, $rs, $offset, $limit) = @_;

    my $count = $rs->count;

    $offset //= 0;
    $limit //= 20;

    my @objects = $count > 0 ? $rs->search(undef, { offset => $offset, rows => $limit }) : ();

    return(\@objects, { offset => $offset, limit => $limit, total => $count });
}

# get object by source + pk_value
# throws the BananaDuck::Exception::API exception if not found
sub find_object {
    my ($self, $source, $pk_value) = @_;

    my $object = ref $pk_value ? $self->schema->resultset($source)->single($pk_value)
        : $self->schema->resultset($source)->find($pk_value);

    if (!defined $object) {
        BananaDuck::Exception::API->throw(
            error             => 'invalid_usage',
            error_description => $self->format_message('exception.invalidUsage.notFound'), # create separate messages for different objects
        );
    }
    return $object;
}

sub create_user {
    my ($self, $params) = @_;

    if (defined $params->{password}) {
        my $salt = get_salt;
        my $password = get_password_hash($salt, $params->{password});

        @$params{qw( salt password )} = ($salt, $password);
    }

    my $user = $self->schema->resultset('User')->create($params);

    # update the object with the actual values from the database
    $user->discard_changes;
    return $user;
}

sub format_message {
    my ($self, $id, @args) = @_;
    return BananaDuck::Message->new(id => $id, args => \@args)->format($self->ctx->lang);
}

sub enqueue_event_publication {
    my ($self, $event) = @_;

    my $response = $self->ctx->resque->push(published_events => {
        class => 'BananaDuck::Queue::Task::PublishEvent',
        args => [ $event->id ]
    });
    $self->ctx->log->debug(sprintf "Queued publishing the event %d, redis response: $response", $event->id);
}

1;
