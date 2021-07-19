class Version {
  int major;
  int minor;
  int patch;
  int versionSum;
  Version(String version){
    var parts = version.split(".");
    this.major = int.parse(parts[0]);
    this.minor = int.parse(parts[1]);
    this.patch = int.parse(parts[2]);
  }
}