{config, ...}: {
	sops.secrets."netdata/env" = {};

	virtualisation.oci-containers.containers.netdata = {
		autoStart = true;
		image = "docker.io/netdata/netdata:v2.8.4@sha256:321fb7c3f854401a329798392cd681367fa528e95a7dfa7d539546d83ae1dd18";
		capabilities.SYS_PTRACE = true;
		capabilities.SYS_ADMIM = true;
		ports = [
			"19999:19999"
		];
		devices = [
			"dev/dri:dev/dri"
		];
		environment = {
			DOCKER_HOST = "socket_proxy:2375";
		};
		environmentFiles = [config.sops.secrets."netdata/env".path];
		volumes = [
			"/lumiere/data/docker/netdata/config/:/etc/netdata/:rw"
			"/lumiere/data/docker/netdata/lib/:/var/lib/netdata/:rw"
			"/lumiere/data/docker/netdata/cache/:/var/cache/netdata/:rw"
			"/etc/localtime:/etc/localtime:ro"
			"/proc:/host/proc:ro"
			"/sys:/host/sys:ro"
			"/etc/os-release:/host/etc/os-release:ro"
			"/var/log:/host/var/log:ro"
			"/run/dbus:/run/dbus:ro"
		];
		extraOptions = [
			"--net=socket_proxy"
		];
	};
}