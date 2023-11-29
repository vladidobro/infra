let
  parok = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHwZXz02nXZUTLTD0vP8GqhbHJTk2zmZI2ekJcyTx71e";
  systems = [ parok ];
in
{
  "wireless-networks.age".publicKeys = systems;
}

