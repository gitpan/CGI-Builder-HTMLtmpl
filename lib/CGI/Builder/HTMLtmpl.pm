package CGI::Builder::HTMLtmpl ;
$VERSION = 1.01 ;

; use strict
; use HTML::Template
; $Carp::Internal{'HTML::Template'}++
; $Carp::Internal{+__PACKAGE__}++

; use Object::props
      ( { name       => 'ht'
        , default    => sub{ shift()->ht_new(@_) }
        }
      , { name       => 'page_suffix'
        , default    => '.tmpl'
        }
      , { name       => 'page_content'
        , default    => sub{ $_[0]->ht->output() }
        }
      )
      
; use Object::groups
      ( { name       => 'ht_new_args'
        , default    =>  sub
                          { return
                            { filename => $_[0]->page_name
                                        . $_[0]->page_suffix
                            , path     => [ $_[0]->page_path ]
                            }
                          }
        }
      )

; sub ht_new
   { HTML::Template->new( %{$_[0]->ht_new_args} )
   }

; 1
   
__END__

=head1 NAME

CGI::Builder::HTMLtmpl - CGI::Builder and HTML::Template integration

=head1 VERSION 1.01

To have the complete list of all the extensions of the CBF, see L<CGI::Builder/"Extensions List">

=head1 INSTALLATION

=over

=item Prerequisites

    CGI::Builder    >= 1.0
    HTML::Template  >= 2.6

=item CPAN

    perl -MCPAN -e 'install Apache::CGI::Builder'

You have also the possibility to use the Bundle to install all the extensions and prerequisites of the CBF in just one step. Please, notice that the Bundle will install A LOT of modules that you might not need, so use it specially if you want to extensively try the CBF.

    perl -MCPAN -e 'install Bundle::CGI::Builder::Complete'

=item Standard installation

From the directory where this file is located, type:

    perl Makefile.PL
    make
    make test
    make install

=back

=head1 SYNOPSIS

    use CGI::Builder
    qw| CGI::Builder::HTMLtmpl
        ...
      |;

=head1 DESCRIPTION

This module transparently integrates C<CGI::Builder> and C<HTML::Template> in a very handy and flexible framework that can save you some coding. It provides you a mostly automatic template system based on HTML::Template: usually you will have just to supply the run time values to the object and this extension will manage automatically all the other tasks of the page production process (such as generating the output and setting the C<page_content> property).

B<Note>: With this extension you don't need to explicitly set the C<page_content> to the output of your template object (C<< ht->output() >>) in your Page Handlers, because it will be automatically set. You should explicitly set the C<page_content> property just in case you want to bypass the template system:
   
    # in order to produce the output with the template 'myPage.tmpl',
    # usually you just need to pass the param to the object
    sub PH_myPage {
        my $s = shift;
        $s->ht->param( something => 'something' );
    }
    
    # but if you want to completely bypass the template system
    # just set the page_content
    sub PH_myPage {
        my $s = shift;
        $s->page_content = 'some content';
    }

B<Note>: This extension is not as magic and memory saving as the L<CGI::Builder::Magic|CGI::Builder::Magic> template extension, because HTML::Template requires a specific input data structure (i.e. does not allow call back subs unless you use the HTML::Template::Expr), and does not allow to print the output during the process. On the other hand it should be some milliseconds faster than CGI::Builder::Magic in producing the output.

=head2 Useful links

=over

=item *

A simple and useful navigation system between the various CBF extensions is available at this URL: L<http://perl.4pro.net>

=item *

More practical topics are probably discussed in the mailing list at this URL: L<http://lists.sourceforge.net/lists/listinfo/cgi-builder-users>

=back

=head1 EXAMPLES

=head2 Simple CBB (all defaults)

This is a complete CBB that uses all the default to load the './tm/index.tmpl'template and fill it with a couple of run time values and automatically send the C<page_content> to the client.

    package My::WebApp
    use CGI::Builder
    qw| CGI::Builder::HTMLtmpl
      |;
      
    sub PH_index {
        my $s = shift;
        $s->ht->param( myVar      => 'my Variable',
                       myOtherVar => 'other Variable');
    }
    
    1;

=head2 More complex CBB (overriding defaults)

This is a more complex complete CBB that will automatically send the C<page_content> to the client:

    package My::WebApp
    use CGI::Builder
    qw| CGI::Builder::HTMLtmpl
      |;
    
    # this will init some properties overriding the default
    # and adding some option to the ht creation
    sub OH_init {
        my $s = shift;
        $s->page_suffix = '.html';               # override defaults
        $s->ht_new_args( path => '/my/path',     # override defaults
                         die_on_bad_params => 0,
                         cache => 1 );
    }
    
    # this will be called for page 'index' or if no page is specified
    # it will load the '/my/path/index.html' file (since page_suffix is '.html')
    # and will fill it with the following variables and send the output()
    sub PH_index {
        my $s = shift;
        $s->ht->param( myVar => 'my Variable',
                       myOtherVar => 'other Variable');
    }
    
    # this will override the default template for this handler
    # (i.e. '/my/path/specialPage.html') so loading '/my/path/special.tmp'
    # template, filling and sending the output as usual
    sub PH_specialPage {
        my $s = shift;
        $s->ht_new_args( filename => 'special.tmp')     # override defaults
        $s->ht->param( mySomething => 'something' );
    }
    
    1;

=head1 PROPERTY and GROUP ACCESSORS

This module adds some template properties (all those prefixed with 'ht_') to the standard CBF properties. The default of these properties are usually smart enough to do the right job for you, but you can fine-tune the behaviour of your CBB by setting them to the value you need.

=head2 ht

This property returns the internal C<HTML::Template> object that is automatically created just before you use it. Use it to address all the HTML::Template methods.

B<Note>: You can change the default arguments that are internally used to create the object by using the C<ht_new_args> group accessor, or you can completely override the creation of the internal object by overriding the C<ht_new()> method.

=head2 ht_new_args( arguments )

This property group accessor handles the HTML::Template constructor arguments that are used in the creation of the internal HTML::Template object. Use it to change or add the argument you need to the creation of the new object.

It uses the following defaults:

=over

=item * filename

This option is set to the C<page_name> value plus the C<page_suffix> value.

    filename => $s->page_name.$s->page_suffix
    
    # when the page_name is 'myPage'
    # and the page_suffix is the default '.tmpl'
    # it will be expanded to;
    filename => 'myPage.tmpl'

=item * path

This option is set to the C<page_path> value.

   path => $s->page_path

=back

In order to change the parameter for the new C<ht>, you can use this accessor before using the C<ht> (e.g. pass them to the new() method or set them in a C<OH_init>, or even using it inside the same Page Handler).

    # set args in the new instance statement
    my $webapp = My::WebApp
                ->new( ht_new_args => { path => '/my/path',    # override defaults
                                        die_on_bad_params => 0,
                                        cache => 1
                                      }
                       .....
                     );
                                 
    # or in the OH_init handler
    sub OH_init {
        my $s = shift;
        $s->ht_new_args( path => '/my/path',     # override defaults
                         die_on_bad_params => 0,
                         cache => 1 );
    }
    
    # and/or in a Page Handler
    sub PH_specialPage {
        my $s = shift;
        $s->ht_new_args( filename => 'special.tmp')     # override defaults
        $s->ht->param( mySomething => 'something' );
    }


B<Note>: You can completely override the creation of the internal object by overriding the C<ht_new()> method.

=head2 CBF changed property defaults

=head3 CBF page_suffix

This module sets the default of the C<page_suffix> to the traditional '.tmpl'. You can override it by just setting another suffix of your choice.

=head3 CBF page_content

This module sets the default of the C<page_content> to the template output produced by using the internal C<< ht->output() >>. If you want to bypass the template system in any Page Handler, just explicitly set the C<page_content> to the content you want to send.

=head1 METHODS

=head2 ht_new()

This method is not intended to be used directly in your CBB. It is used internally to initialize and returns the C<HTML::Template> object, but you need to know how it does its job.  If you need some more customization you can redefine the method in your CBB.

=head1 AVOIDING MISTAKES

=over

=item *

Don't use the C<ht_new_args> in all the Page Handlers: it is intended to be used once e.g. in an OH_init OR as an exceptional case in any Page Handler just to allow overriding (e.g. a different filename just for that particular Page Handler).

=item *

Don't explicitly set the C<page_content> property unless you want to bypass the template system: this extension set it for you.

=back

=head1 SUPPORT

Support for all the modules of the CBF is via the mailing list. The list is used for general support on the use of the CBF, announcements, bug reports, patches, suggestions for improvements or new features. The API to the CBF is stable, but if you use the CBF in a production environment, it's probably a good idea to keep a watch on the list.

You can join the CBF mailing list at this url:

L<http://lists.sourceforge.net/lists/listinfo/cgi-builder-users>

=head1 AUTHOR and COPYRIGHT

© 2004 by Domizio Demichelis (L<http://perl.4pro.net>)

All Rights Reserved. This module is free software. It may be used, redistributed and/or modified under the same terms as perl itself.

