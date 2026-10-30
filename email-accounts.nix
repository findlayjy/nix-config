# Email address configurations for Thunderbird

{ config, pkgs, lib, ... }:
{
  # UiO account
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
}
