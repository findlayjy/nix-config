# Email address configurations for Thunderbird

{ config, pkgs, lib, ... }:
{
  ## Set accounts order
  programs.thunderbird.profiles.main.accountsOrder = [
    "UiO"
    "jyfindlay"
    "findlayjy"
    "account1"   # Local Folders
  ];

  ####################################################
  ## UiO account
  ####################################################
  accounts.email.accounts.UiO = {
    primary  = true;
    address  = "jamief@uio.no";
    realName = "Jamie Y. Findlay";
    userName = "jamief@uio.no";

    # Incoming server
    imap = {
      host = "outlook.office365.com";
      port = 143;
      tls = {
        enable      = true;
        useStartTls = true;   # "STARTTLS" rather than SSL/TLS
      };
      authentication = "xoauth2";
    };

    # Outgoing server
    smtp = {
      host = "smtp.office365.com";
      port = 587;
      tls = {
        enable      = true;
        useStartTls = true;
      };
      authentication = "xoauth2";
    };

    thunderbird = {
      enable   = true;
    };
  };

  ####################################################
  ## jy.findlay@gmail.com
  ####################################################
  accounts.email.accounts.jyfindlay = {
    flavor   = "gmail.com";
    address  = "jy.findlay@gmail.com";
    realName = "Jamie Findlay";

    imap.authentication = "xoauth2";
    smtp.authentication = "xoauth2";

    thunderbird.enable = true;
  };

  ####################################################
  ## findlayjy@gmail.com
  ####################################################
  accounts.email.accounts.findlayjy = {
    flavor   = "gmail.com";
    address  = "findlayjy@gmail.com";
    realName = "Jamie Findlay";

    imap.authentication = "xoauth2";
    smtp.authentication = "xoauth2";

    thunderbird.enable = true;
  };

}
