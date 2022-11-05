#
# SuperCharacter: This package is for computing all supercharacter theories of a finite group.
#
# This file runs package tests. It is also referenced in the package
# metadata in PackageInfo.g.
#
LoadPackage( "SuperCharacter" );

TestDirectory(DirectoriesPackageLibrary( "SuperCharacter", "tst" ),
  rec(exitGAP := true));

FORCE_QUIT_GAP(1); # if we ever get here, there was an error
