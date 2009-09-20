=begin comments

Genfile::Grammar::Actions - ast transformations for Genfile

=end comments

class Genfile::Grammar::Actions;

method TOP($/) {
  our @nodes;
  make Genfile::File.new(:value(@nodes));
}

method nodes($/) {
  our @nodes;
  @nodes.push($($<node>));
}

method node($/, $key) {
  if($key) {
    make $($/{$key});
  }
}

method text($/) {
  make Genfile::Text.new( :text( ~$/) );
}

method identifier($/) {
  make Genfile::Identifier.new( :text( ~$<text> ));
}

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4:

