{
  flake.modules.nixos.nix-settings = { lib, ... }: {
    nixpkgs.config.allowUnfree = true;

    nix = {
      channel.enable = false;

      gc = {
	automatic = true;
	dates = "weekly";
	options = "--delete-older-than 7d";
      };

      settings = {
	auto-optimise-store = lib.mkDefault true;

	experimental-features = [
	  "nix-command"
	  "flakes"
	];

	substituters = [
	  "https://cache.nixos.org"
  	  "https://cache.garnix.io"
	  "https://attic.xuyh0120.win/lantian" # for the kernel
	];

	trusted-public-keys = [
	  "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
	  "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
	  "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
	];

	trusted-users = [ "@wheel" ];
      };
    };
  };
}
