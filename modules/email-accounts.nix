{ config, pkgs, lib, ... }:
{
  accounts.email.accounts.UiO = {
    primary  = true;
    address  = "jamief@uio.no";
    realName = "Jamie Y. Findlay";
    userName = "jamief@uio.no";

    # INCOMING SERVER
    imap = {
      host = "outlook.office365.com";
      port = 143;
      tls = {
        enable      = true;
        useStartTls = true;   # "STARTTLS" rather than SSL/TLS
      };
    };

    # OUTGOING SERVER
    smtp = {
      host = "smtp.office365.com";
      port = 587;
      tls = {
        enable      = true;
        useStartTls = true;
      };
    };

    thunderbird = {
      enable   = true;
      profiles = [ "main" ];

      # Authentication method: OAuth2 (for both servers)
      settings = id: {
        "mail.server.server_${id}.authMethod"   = 10;
        "mail.smtpserver.smtp_${id}.authMethod" = 10;
      };
    };
  };
}
