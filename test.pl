###########################################
# Test Suite for Log::Log4perl
# Mike Schilli, 2002 (m@perlmeister.com)
########################################### 

use warnings;
use strict;

#########################
# change 'tests => 1' to 'tests => last_test_to_print';
#########################
use Test;
BEGIN { plan tests => 3 };

use Log::Log4perl;
use Log::Log4perl::Layout;
use Log::Log4perl::Layout::XMLLayout;
use Log::Log4perl::Level;
use Log::Log4perl::Appender::TestBuffer;
use File::Spec;

my $app = Log::Log4perl::Appender->new(
    "Log::Log4perl::Appender::TestBuffer");

ok(1); # If we made it this far, we're ok.

my $logger = Log::Log4perl->get_logger("abc.def.ghi");
$logger->add_appender($app);
#########################################################
# Log with LocationInfo
#########################################################
my $layout = Log::Log4perl::Layout::XMLLayout->new(
    { LocationInfo => { value => 'TRUE' },
      Encoding     => { value => 'iso8859-1'}});
      
$app->layout($layout);
$logger->debug("That's the message");
my($regexp)= qr(<\?xml version = "1.0" encoding = "iso8859-1"\?>$
<log4j:event logger="abc.def.ghi"$
\ttimestamp="[0-9]+"$
\tlevel="DEBUG"$
\tthread="[0-9]+">$
\t<log4j:message><!\[CDATA\[That's the message\]\]></log4j:message>$
\t<log4j:NDC><!\[CDATA\[undef\]\]></log4j:NDC>$
\t<log4j:locationInfo class="main"$
\t\tmethod="main"$
\t\tfile="test.pl"$
\t\tline="[0-9]+">$
\t</log4j:locationInfo>$
</log4j:event>$);

ok($app->buffer() =~ m/$regexp/m); 

#########################################################
# Log with LocationInfo and without Encoding
#########################################################
$layout = Log::Log4perl::Layout::XMLLayout->new(
    { LocationInfo => { value => 'TRUE' } });
      
$app->layout($layout);
$logger->debug("That's the message");
$regexp= qr(<log4j:event logger="abc.def.ghi"$
\ttimestamp="[0-9]+"$
\tlevel="DEBUG"$
\tthread="[0-9]+">$
\t<log4j:message><!\[CDATA\[That's the message\]\]></log4j:message>$
\t<log4j:NDC><!\[CDATA\[undef\]\]></log4j:NDC>$
\t<log4j:locationInfo class="main"$
\t\tmethod="main"$
\t\tfile="test.pl"$
\t\tline="[0-9]+">$
\t</log4j:locationInfo>$
</log4j:event>$);

ok($app->buffer() =~ m/$regexp/m); 

############################################################
# Log without LocationInfo
############################################################
$app->buffer("");
$layout = Log::Log4perl::Layout::XMLLayout->new(
    { LocationInfo => { value => 'FALSE' },
      Encoding     => { value => 'iso8859-1'}});
      
$app->layout($layout);
$logger->debug("That's the message");
$regexp= qr(<\?xml version = "1.0" encoding = "iso8859-1"\?>$
<log4j:event logger="abc.def.ghi"$
\ttimestamp="[0-9]+"$
\tlevel="DEBUG"$
\tthread="[0-9]+">$
\t<log4j:message><!\[CDATA\[That's the message\]\]></log4j:message>$
\t<log4j:NDC><!\[CDATA\[undef\]\]></log4j:NDC>$
</log4j:event>$);

ok($app->buffer() =~ m/$regexp/m); 


############################################################
# Log without Encoding and without LocationInfo
############################################################
$app->buffer("");
$layout = Log::Log4perl::Layout::XMLLayout->new(
    { LocationInfo => { value => 'FALSE' } });
      
$app->layout($layout);
$logger->debug("That's the message");
$regexp= qr(<log4j:event logger="abc.def.ghi"$
\ttimestamp="[0-9]+"$
\tlevel="DEBUG"$
\tthread="[0-9]+">$
\t<log4j:message><!\[CDATA\[That's the message\]\]></log4j:message>$
\t<log4j:NDC><!\[CDATA\[undef\]\]></log4j:NDC>$
</log4j:event>$);

ok($app->buffer() =~ m/$regexp/m); 
