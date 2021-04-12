{ users, profiles, userProfiles, ... }:
{
  system = with profiles; rec {
    base = [ core users.ben users.root ];
  };
  user = with userProfiles; rec {
    base = [ direnv git ];
  };
}
