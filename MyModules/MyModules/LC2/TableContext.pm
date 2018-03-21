package TableBuilder;
use Moose::Role;
requires 'build';

package MyModules::LC2::TableContext;
use Moose;
has 'strategy' => (
  is      => 'rw',
  isa     => 'TableBuilder',
  #isa     => 'MyModules::LC2::TableBuilder',
  handles => [ 'build' ],
);

no Moose;
__PACKAGE__->meta->make_immutable;
