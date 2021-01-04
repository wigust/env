self: super:
with self.python3Packages;
{
  ptvsd = buildPythonPackage rec {
    pname = "ptvsd";
    version = "4.3.2";
    format = "wheel";

    src = fetchPypi {
      inherit pname version format;
      sha256 = "459137736068bb02515040b2ed2738169cb30d69a38e0fd5dffcba255f41e68d";
    };

    # no tests in the wheel or the zip
    doCheck = false;
  };
}
