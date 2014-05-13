use strict;
use warnings;
use utf8;

use FindBin qw($Bin);
use lib "$Bin/../lib";

use Config::General;
use Template;

use Encode;
use JSON qw / decode_json /;

use Iota;
my $schema = Iota->model('DB')->schema;

use Iota::IndicatorData;

my $data = Iota::IndicatorData->new( schema => $schema );

my $min = shift;
my $to  = shift;
$data->upsert(
    regions_id => [
        306, 405, 295, 259, 464, 443, 359, 437, 403, 466, 478, 481, 358, 237, 258, 209, 224, 246, 439, 467,
        352, 301, 221, 239, 440, 468, 441, 427, 442, 423, 240, 198, 471, 474, 475, 426, 311, 245, 208, 472,
        445, 453, 473, 425, 446, 294, 476, 477, 451, 448, 315, 449, 454, 450, 263, 455, 457, 293, 298, 353,
        262, 273, 249, 253, 250, 193, 268, 299, 212, 305, 302, 214, 194, 231, 270, 286, 300, 312, 278, 217,
        274, 309, 205, 280, 282, 458, 213, 243, 225, 289, 255, 269, 267, 291, 236, 456, 223, 252, 292, 229,
        266, 211, 308, 297, 235, 304, 204, 234, 197, 276, 261, 196, 257, 192, 202, 265, 201, 314, 228, 200,
        465, 277, 248, 290, 272, 463, 220, 285, 219, 281, 288, 242, 284, 233, 207, 230, 226
    ],

);
