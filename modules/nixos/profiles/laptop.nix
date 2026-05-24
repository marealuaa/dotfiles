{
  flake.modules.nixos.laptop = { config, ...}: 
  {
    systemd.sleep.settings.Sleep = { HibernateDelaySec = "90min"; };

	  services = {
			logind.settings.Login = { HandleLidSwitch = "suspend-then-hibernate"; };

			acpid.enable = true;
			fwupd.enable = true;
			thermald.enable = config.hardware.cpu.intel.updateMicrocode; 

			auto-cpufreq = {
				enable = true;
				settings = {
					battery = {
						governor = "powersave";
						turbo = "never";
					};
					charger = {
						governor = "performance";
						turbo = "auto";
					};
				};
			};
		};

  };
}
