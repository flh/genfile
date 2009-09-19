=head1 TITLE

genfile.pir - A generator for build files.

=head2 Description

=head2 Functions

=over 4

=item onload()

Creates the Genfile compiler using a C<PCT::HLLCompiler> object.

=cut

.HLL '_genfile'

.sub '' :anon :load :init
    load_bytecode 'PCT.pbc'
    .local pmc parrotns, cns, exports

    parrotns = get_root_namespace ['parrot']
    cns = get_hll_namespace
    exports = split ' ', 'PAST PCT PGE'
    parrotns.'export_to'(cns, exports)
.end

.include 'Compiler.pir'
.include 'Node.pir'

.sub '' :anon :load :init
    .local pmc p6meta
    p6meta = new 'P6metaclass'
    p6meta.'new_class'('Genfile::Compiler', 'parent'=>'PCT::HLLCompiler')

    $P0 = get_hll_global ['Genfile'], 'Compiler'
    $P1 = $P0.'new'()
    $P1.'language'('Genfile')

    $P2 = get_hll_namespace ['Genfile'; 'Grammar']
    $P1.'parsegrammar'($P2)
    $P2 = get_hll_namespace ['Genfile'; 'Grammar'; 'Actions']
    $P1.'parseactions'($P2)
.end

.include 'genfile_grammar.pir'
.include 'genfile_actions.pir'

=item main(args :slurpy)  :main

Start compilation by passing any command line C<args>
to the Genfile compiler.

=cut

.namespace []
.sub 'main' :main
    .param pmc args

    $P0 = compreg 'Genfile'
    .tailcall $P0.'command_line'(args)
.end

=back

=cut

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

