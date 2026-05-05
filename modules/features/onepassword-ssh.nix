{
  flake.modules.homeManager."features-onepassword-ssh" = {
    programs = {
      git.settings = {
        url."git@github.com:".insteadOf = "https://github.com/";
      };

      ssh.matchBlocks."github.com" = {
        hostname = "github.com";
        user = "git";
        identityAgent = "~/.1password/agent.sock";
      };

      ssh.matchBlocks."pi" = {
        hostname = "pi";
        user = "aron";
        identityAgent = "~/.1password/agent.sock";
      };
    };
  };
}
