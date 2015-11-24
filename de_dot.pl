use strict;
use Search::Elasticsearch;
use Getopt::Long;

# Note that this doesn't handle external versioning, if you've used that on your docs
# See https://metacpan.org/pod/Search::Elasticsearch::Bulk#REINDEXING-DOCUMENTS for more info

# Source and destination nodes/indexes -- we'll use command line parameters to override
my @sourceNodes = ['127.0.0.1:9200'];
my $sourceIndexName = 'test';
my @destinationNodes = ['127.0.0.1:9200'];
my $destinationIndexName = 'test2';

GetOptions ("source=s" => \@sourceNodes,
              "destination=s" => \@destinationNodes,
              "verbose"  => \$verbose)
  or die(usage());

@destinationNodes = split(/,/,join(',',@destinationNodes));
@sourceNodes = split(/,/,join(',',@sourceNodes));

# Connect to source and destination
my $source = Search::Elasticsearch->new( nodes => @sourceNodes );
my $destination = Search::Elasticsearch->new( nodes => @destinationNodes );

# Recursively replace keys with . with an _
sub edit_source {
  my $self = shift;
  my $newHash = {};
  foreach my $k (keys %{$self}) {
    my $v = $self->{$k};
    if (ref($v) eq 'HASH') {
      $v = edit_source($v);
    }

    $k =~ tr/./_/;
    $newHash->{$k} = $v;
  }
  return $newHash;
}

# Use the bulk helper to reindex from the given source
$destination->bulk_helper(index => $destinationIndexName)->reindex(
  source => {
    es => $source,
    index => $sourceIndexName,
    size => 1000, # use 1000 docs at a time
    fields => ['_source','_parent','_routing'] # make sure to preserve source, parent, and routing values
    #, body => { query => { match => { field_name => 123 } } }
  },
  dest_index => $destinationIndexName,
  transform  => sub {
    my $doc = shift;
    my $source = $doc->{'_source'};
    my $newSource = edit_source($source);
    $doc->{'_source'} = $newSource;
    return $doc;
  }
);
