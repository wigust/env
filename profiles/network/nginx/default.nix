{ pkgs, config, ... }: {
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    config = ''
      http {
        if ($request_method = MKCOL) {
           rewrite ^(.*[^/])$ $1/ break;
        }

        if (-d $request_filename) {
          rewrite ^(.*[^/])$ $1/ break;
        }
        server {
          listen 80;
          listen [::]:80;

          auth_basic              realm_name;
          auth_basic_user_file    ${./credentials.list};

          dav_methods     PUT DELETE MKCOL COPY MOVE;
          dav_ext_methods PROPFIND OPTIONS LOCK UNLOCK;

          root ${config.users.users.ben.home}/org
    
          # In this folder, newly created folder or file is to have specified permission. If none is given, default is user:rw. If all or group permission is specified, user could be skipped
          dav_access      user:rw group:rw all:r;
    
          # MAX size of uploaded file, 0 mean unlimited
          client_max_body_size    0;
    
          # Allow autocreate folder here if necessary
          create_full_put_path    on;
        }
      }
    '';
  };
  systemd.services.nginx.serviceConfig.ReadWritePaths = [ "${config.users.users.ben.home}/org" ];
}
