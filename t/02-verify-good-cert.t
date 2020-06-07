use Test::More;
use Crypt::OpenSSL::Verify;
use Crypt::OpenSSL::X509 1.807;
use File::Slurp qw(read_file);

my $v = Crypt::OpenSSL::Verify->new('t/cacert.pem');
isa_ok($v, 'Crypt::OpenSSL::Verify');

my $text = read_file('t/cert.pem');
like($text, qr/E1dSkFDk4Jix1M19WqRGMla8/, "seems to be a pem");

my $cert = Crypt::OpenSSL::X509->new_from_string($text);
isa_ok($cert, 'Crypt::OpenSSL::X509');

my $ret = $v->verify($cert);
ok($ret, "t/cert.pem verified");

$v = Crypt::OpenSSL::Verify->new(
    CAfile => 't/cacert.pem',
    CApath => '/etc/ssl/certs',
    noCAfile => 0,
    noStore => 0,
    );
ok($v);

$ret = $v->verify($cert);
ok($ret);

done_testing;
