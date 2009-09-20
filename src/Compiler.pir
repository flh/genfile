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

.sub 'pir' :method
    .param pmc source
    .param pmc adverbs :slurpy :named

    $P0 = new ['CodeString']
    $P0 = <<'PIRCODE'
.sub 'main' :anon
    $S0 = <<'PIR'
PIRCODE
    $P0 .= source
    $P0 .= <<'PIRCODE'
PIR

    .return($S0)
.end
PIRCODE
    .return ($P0)
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
    $P1 = self.'mappings'($P0)
    $S0 = $P1[$P0]
    .return (code)
.end

.sub 'emit_node' :method :multi(_, ['Genfile'; 'File'])
    .param pmc past
    .local pmc code, nodes, it

    code = new ['CodeString']
    nodes = past.'value'()
    it = iter nodes

  iter_loop:
    unless it goto iter_end
    $P0 = shift it
    $P1 = self.'emit_node'($P0)
    code .= $P1
    goto iter_loop

  iter_end:
    .return (code)
.end

.sub 'emit' :method
    .param pmc past
    .local pmc code, nodes, it

    code = new ['CodeString']
    nodes = past.'value'()

    it = iter nodes

  iter_loop:
    unless it goto iter_end
    $P0 = shift it
    $P1 = self.'emit_node'($P0)
    code .= $P1
    goto iter_loop

  iter_end:
    .return (code)
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

