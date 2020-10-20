From: Apollon Oikonomopoulos <apoikos@debian.org>
Subject: [PATCH] scripts/checkpatch.pl: escape literal left braces
Date: Tue, 20 Oct 2020 14:55:41 +0300
Message-ID: <20201020115541.184675-3-apoikos@debian.org>
References: <20201020115541.184675-1-apoikos@debian.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stgt-owner@vger.kernel.org>
In-Reply-To: <20201020115541.184675-1-apoikos@debian.org>
List-ID: <stgt.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: stgt@vger.kernel.org
Cc: Apollon Oikonomopoulos <apoikos@debian.org>

Since Perl 5.22.0, left braces in regexps should be escaped.

Signed-off-by: Apollon Oikonomopoulos <apoikos@debian.org>
---
 scripts/checkpatch.pl | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index b1281ac..30fc77f 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2397,8 +2397,8 @@ sub process {
 
 # function brace can't be on same line, except for #defines of do while,
 # or if closed on same line
-		if (($line=~/$Type\s*$Ident\(.*\).*\s{/) and
-		    !($line=~/\#\s*define.*do\s{/) and !($line=~/}/)) {
+		if (($line=~/$Type\s*$Ident\(.*\).*\s\{/) and
+		    !($line=~/\#\s*define.*do\s\{/) and !($line=~/\}/)) {
 			ERROR("OPEN_BRACE",
 			      "open brace '{' following function declarations go on the next line\n" . $herecurr);
 		}
@@ -2673,8 +2673,8 @@ sub process {
 ## 		}
 
 #need space before brace following if, while, etc
-		if (($line =~ /\(.*\){/ && $line !~ /\($Type\){/) ||
-		    $line =~ /do{/) {
+		if (($line =~ /\(.*\)\{/ && $line !~ /\($Type\){/) ||
+		    $line =~ /do\{/) {
 			ERROR("SPACING",
 			      "space required before the open brace '{'\n" . $herecurr);
 		}
@@ -2964,7 +2964,7 @@ sub process {
 			    $dstat !~ /^for\s*$Constant$/ &&				# for (...)
 			    $dstat !~ /^for\s*$Constant\s+(?:$Ident|-?$Constant)$/ &&	# for (...) bar()
 			    $dstat !~ /^do\s*{/ &&					# do {...
-			    $dstat !~ /^\({/)						# ({...
+			    $dstat !~ /^\(\{/)						# ({...
 			{
 				$ctx =~ s/\n*$//;
 				my $herectx = $here . "\n";
-- 
2.28.0

