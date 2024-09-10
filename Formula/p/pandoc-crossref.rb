class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.17.1c.tar.gz"
  version "0.3.17.1c"
  sha256 "1c1d00d356c74749d530b508db2e6aca6fe9f5ae3a283af58d25bedc99293977"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "01e7513a56be2b5dec66d477b6892cab548cee120e29fa913fd336c6b8ffabf5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c94edf93c9f715b57577df9412dcdba0051b921304ff1885d880ddf7f049ec8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "971e09c4acbb7f0331738d28b7f23ef905e444aa1ce7bcd2001dd84b8d5565b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09f58513da6d5c759db7726f2a58de805bb58b23e8797bd882d159066e0795dd"
    sha256 cellar: :any_skip_relocation, sonoma:         "3dc0f52abfeeb9fa1d1d12d1833fdecaf20049dca2ebe7057a4d7256a39ed604"
    sha256 cellar: :any_skip_relocation, ventura:        "f4e1cff8bf41b03362223374fb0a5880bccf6811dadeffab0a3b17cce6715ed5"
    sha256 cellar: :any_skip_relocation, monterey:       "d7015c5a49f787bef8ba735b31e206875d56591215c3d5317e5f9b380aa8128d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "638d0887665fededa6bd785f025cf6e3ca12691be15b0451d7fa45b7f7ea4820"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pandoc"

  uses_from_macos "unzip" => :build
  uses_from_macos "zlib"

  # build patch to support pandoc 3.4, upstream PR ref: https://github.com/lierdakil/pandoc-crossref/pull/451
  patch :DATA

  def install
    rm("cabal.project.freeze")

    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"hello.md").write <<~EOS
      Demo for pandoc-crossref.
      See equation @eq:eqn1 for cross-referencing.
      Display equations are labelled and numbered

      $$ P_i(x) = \\sum_i a_i x^i $$ {#eq:eqn1}
    EOS
    output = shell_output("#{Formula["pandoc"].bin}/pandoc -F #{bin}/pandoc-crossref -o out.html hello.md 2>&1")
    assert_match "∑", (testpath/"out.html").read
    refute_match "WARNING: pandoc-crossref was compiled", output
  end
end

__END__
diff --git a/package.yaml b/package.yaml
index ab2ac81..c06adac 100644
--- a/package.yaml
+++ b/package.yaml
@@ -20,7 +20,7 @@ data-files:
 dependencies:
   base: ">=4.11 && <5"
   text: ">=1.2.2 && <2.2"
-  pandoc: ">=3.1.8 && < 3.4"
+  pandoc: ">=3.1.8 && < 3.5"
   pandoc-types: ">= 1.23 && < 1.24"
 _deps:
   containers: &containers { containers: ">=0.1 && <0.7" }
diff --git a/pandoc-crossref.cabal b/pandoc-crossref.cabal
index 0fc730b..df0e7c1 100644
--- a/pandoc-crossref.cabal
+++ b/pandoc-crossref.cabal
@@ -1,6 +1,6 @@
 cabal-version: 2.0
 
--- This file has been generated from package.yaml by hpack version 0.36.0.
+-- This file has been generated from package.yaml by hpack version 0.37.0.
 --
 -- see: https://github.com/sol/hpack
 
@@ -36,6 +36,12 @@ data-files:
     test/m2m/eqnBlockTemplate/expect.md
     test/m2m/eqnBlockTemplate/expect.tex
     test/m2m/eqnBlockTemplate/input.md
+    test/m2m/eqnDisplayTemplate/expect.md
+    test/m2m/eqnDisplayTemplate/expect.tex
+    test/m2m/eqnDisplayTemplate/input.md
+    test/m2m/eqnInlineTableTemplate/expect.md
+    test/m2m/eqnInlineTableTemplate/expect.tex
+    test/m2m/eqnInlineTableTemplate/input.md
     test/m2m/eqnInlineTemplate/expect.md
     test/m2m/eqnInlineTemplate/expect.tex
     test/m2m/eqnInlineTemplate/input.md
@@ -133,7 +139,7 @@ library
   build-depends:
       base >=4.11 && <5
     , mtl >=1.1 && <2.4
-    , pandoc >=3.1.8 && <3.4
+    , pandoc >=3.1.8 && <3.5
     , pandoc-crossref-internal
     , pandoc-types ==1.23.*
     , text >=1.2.2 && <2.2
@@ -177,7 +183,7 @@ library pandoc-crossref-internal
     , microlens-mtl >=0.2.0.1 && <0.3.0.0
     , microlens-th >=0.4.3.10 && <0.5.0.0
     , mtl >=1.1 && <2.4
-    , pandoc >=3.1.8 && <3.4
+    , pandoc >=3.1.8 && <3.5
     , pandoc-types ==1.23.*
     , syb >=0.4 && <0.8
     , template-haskell >=2.7.0.0 && <3.0.0.0
@@ -198,7 +204,7 @@ executable pandoc-crossref
     , gitrev >=1.3.1 && <1.4
     , open-browser ==0.2.*
     , optparse-applicative >=0.13 && <0.19
-    , pandoc >=3.1.8 && <3.4
+    , pandoc >=3.1.8 && <3.5
     , pandoc-crossref
     , pandoc-types ==1.23.*
     , template-haskell >=2.7.0.0 && <3.0.0.0
@@ -219,7 +225,7 @@ test-suite test-integrative
     , directory >=1 && <1.4
     , filepath >=1.1 && <1.6
     , hspec >=2.4.4 && <3
-    , pandoc >=3.1.8 && <3.4
+    , pandoc >=3.1.8 && <3.5
     , pandoc-crossref
     , pandoc-types ==1.23.*
     , text >=1.2.2 && <2.2
@@ -245,7 +251,7 @@ test-suite test-pandoc-crossref
     , hspec >=2.4.4 && <3
     , microlens >=0.4.12.0 && <0.5.0.0
     , mtl >=1.1 && <2.4
-    , pandoc >=3.1.8 && <3.4
+    , pandoc >=3.1.8 && <3.5
     , pandoc-crossref
     , pandoc-crossref-internal
     , pandoc-types ==1.23.*
@@ -265,7 +271,7 @@ benchmark simple
   build-depends:
       base >=4.11 && <5
     , criterion >=1.5.9.0 && <1.7
-    , pandoc >=3.1.8 && <3.4
+    , pandoc >=3.1.8 && <3.5
     , pandoc-crossref
     , pandoc-types ==1.23.*
     , text >=1.2.2 && <2.2
