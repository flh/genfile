# Copyright (C) 2006-2009, Parrot Foundation.
# $Id: skeleton.pir 38369 2009-04-26 12:57:09Z fperrad $

=head1 Genfile::Compiler

=head2 Description

=head2 Methods

=over

=cut

.namespace ['Genfile'; 'Compiler']

.sub 'mappings' :method
    .param pmc value :optional
    .param int has_value :opt_flag
    .tailcall self.'attr'('mappings', value, has_value)
.end

.sub 'emit_node' :method :multi(_, ['Genfile'; 'Text'])
    .param pmc past
    .local pmc code

    code = new ['CodeString']
    code = past.'text'()
    .return (code)
.end

.sub 'emit_node' :method :multi(_, ['Genfile'; 'Identifier'])
    .param pmc past
    .local pmc code

    code = new ['CodeString']
    $P0 = past.'text'()
    code = self.'mappings'($P0)
    .return (code)
.end

.sub 'emit' :method
    .param pmc nodes

    .local pmc code, iter
    code = new 'CodeString'
    iter = nodes.'iterator'()
  iter_loop:
    unless iter goto iter_end
    .local pmc cpast
    cpast = shift iter
    $P0 = self.'emit'(cpast)
    $I0 = elements $P0
    unless $I0 goto iter_loop
    code .= $P0
    goto iter_loop

  iter_end:
    .return (code)
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

