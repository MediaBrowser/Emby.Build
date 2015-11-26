#!/usr/bin/perl
# Copyyright imagemagick LCC
# under imagemagick license

print "<h1>ImageMagick Changelog</h1>\n";
print "<dl>";
while (<>)
{
  chomp();
  s/\&(?!amp;)/\&amp;/g;
  s/</\&lt;/g;
  s/>/\&gt;/g;
  if (/^[^ ]/)
    {
      print "<dt>$_</dt>\n  <dd>";
      $_=<>;
      chomp();
      s/^ *\*//;
      s/\&(?!(?:amp|lt|gt);)/\&amp;/g;
      s/</\&lt;/g;
      s/>/\&gt;/g;
      print;
      next;
    }
  if (/^$/)
    {
      print "</dd>\n";
      next;
    }
  print "</dd>\n  <dd>" if /^ *\*/;
  s/^ *\*//;
  print "$_";
}
print "</dd></dl>";
