use utf8;
package RNSP::PCS::Schema::Result::IndicatorVariation;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

RNSP::PCS::Schema::Result::IndicatorVariation

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=item * L<DBIx::Class::TimeStamp>

=item * L<DBIx::Class::PassphraseColumn>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "PassphraseColumn");

=head1 TABLE: C<indicator_variations>

=cut

__PACKAGE__->table("indicator_variations");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'indicator_variations_id_seq'

=head2 indicator_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 0
  original: {data_type => "varchar"}

=head2 all_variables_are_required

  data_type: 'boolean'
  default_value: true
  is_nullable: 0

=head2 totalization_method

  data_type: 'text'
  default_value: 'sum'
  is_nullable: 1
  original: {data_type => "varchar"}

=head2 created_at

  data_type: 'timestamp'
  default_value: current_timestamp
  is_nullable: 1
  original: {default_value => \"now()"}

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "indicator_variations_id_seq",
  },
  "indicator_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "name",
  {
    data_type   => "text",
    is_nullable => 0,
    original    => { data_type => "varchar" },
  },
  "all_variables_are_required",
  { data_type => "boolean", default_value => \"true", is_nullable => 0 },
  "totalization_method",
  {
    data_type     => "text",
    default_value => "sum",
    is_nullable   => 1,
    original      => { data_type => "varchar" },
  },
  "created_at",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 1,
    original      => { default_value => \"now()" },
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 indicator

Type: belongs_to

Related object: L<RNSP::PCS::Schema::Result::Indicator>

=cut

__PACKAGE__->belongs_to(
  "indicator",
  "RNSP::PCS::Schema::Result::Indicator",
  { id => "indicator_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "RESTRICT" },
);

=head2 indicator_variables_variations

Type: has_many

Related object: L<RNSP::PCS::Schema::Result::IndicatorVariablesVariation>

=cut

__PACKAGE__->has_many(
  "indicator_variables_variations",
  "RNSP::PCS::Schema::Result::IndicatorVariablesVariation",
  { "foreign.indicator_variations" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-01-15 04:31:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:sLsydzw5XZG+G4OIIZ/i8g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
