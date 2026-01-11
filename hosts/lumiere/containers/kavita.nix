{config, ...}: {
	#sops.secrets."kavita/env" = {};

	virtualisation.oci-containers.containers.kavita = {
		autoStart = true;
		image = "docker.io/jvmilazz0/kavita:0.8.8@ssha256:22c42f3cc83fb98b98a6d6336200b615faf2cfd2db22dab363136744efda1bb0";
		ports = [
			"5000:5000";
		];
		environment = {
			TZ=config.time.timeZone;
		};
		#environmentFiles = [config.sops.secrets."kavita/env".path];
		volumes = [
			"/lumiere/data/docker/kavita/config/:/kavita/config/:rw"
			"/lumiere/media/manga/:/manga/:ro"
		];
		extraOptions = [
			"--net=external"
		];
		labels = {
			"traefik.enable" = "true";
			"traefik.http.routers.kavita.rule" = "Host(`kavita.lumiere.wtf`)";
			"traefik.http.routers.kavita.entrypoints" = "websecure";
			"traefik.http.routers.kavita.tls.certresolver" = "porkbun";
			"traefik.http.routers.kavita.service" = "kavita";
			"traefik.http.services.kavita.loadbalancer.server.port" = "5000";
		};
	};
}