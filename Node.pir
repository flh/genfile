# Copyright (C) 2006-2009, Parrot Foundation.
# $Id: skeleton.pir 38369 2009-04-26 12:57:09Z fperrad $

=head1 Genfile AST - Genfile abstract syntax tree

=head2 Description

=cut

.namespace ['Genfile'; 'Node']

.sub 'onload' :anon :load :init
    .local pmc p6meta, base
    p6meta = new 'P6metaclass'
    base = p6meta.'new_class'('Genfile::Node', 'parent'=>'PAST::Node')

    p6meta.'new_class'('Genfile::Text', 'parent'=>base)
    p6meta.'new_class'('Genfile::Identifier', 'parent'=>base)
.end

.sub 'text' :method
    .param pmc value           :optional
    .param int has_value       :opt_flag
    .tailcall self.'attr'('text', value, has_value)
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

