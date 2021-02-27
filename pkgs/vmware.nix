{ stdenv, bash, libxslt, libxml2, zlib, python3, sqlite, fetchurl }:
let
  vmware-workstation-runtime = stdenv.mkDerivation rec {
    name = "vmware-workstation-runtime-${version}";
    version = "15.5.1-15018445";

    buildInputs = with super; [ bash libxslt libxml2 zlib ];
    nativeBuildInputs = with super; [ python3 sqlite ];

    src = fetchurl {
      url = "https://download3.vmware.com/software/wkst/file/VMware-Workstation-Full-${version}.x86_64.bundle";
      sha256 = "1ink8yhmjdk432gzlcpb9zqx9l2s0p0b5hamq40pdhklv3l8y3s9";
    };

    vmwareBundleUnpacker = fetchurl {
      url = https://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/eclass/vmware-bundle.eclass;
      sha256 = "d8794c22229afdeb698dae5908b7b2b3880e075b19be38e0b296bb28f4555163";
    };

    vmwareBootstrapConfig = fetchurl {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/vmware-bootstrap?h=vmware-workstation";
      sha256 = "0pnmfan4l6avhlsnasjn7h37iihri63biazd6a2qazldpxmb3rqj";
    };

    vmwareConfig = fetchurl {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/config?h=vmware-workstation";
      sha256 = "0lw4lqasrxha5dwhfakms5qfyh4046dx92qnj5skn0pdv611lfyf";
    };

    vmwareHostdConfig = fetchurl {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/config.xml?h=vmware-workstation";
      sha256 = "13w2v4synskp20x4wilpqgv89g2v0piw0n1izb80xpkxdj8x47yf";
    };

    vmwareHostdDatastores = fetchurl {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/datastores.xml?h=vmware-workstation";
      sha256 = "16ahdz36frh4qh5rjwv1g46vnx6qma55h2qfw9gbfdhd8jmd8k23";
    };

    vmwareHostdEnvironments = fetchurl {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/environments.xml?h=vmware-workstation";
      sha256 = "10pb5ml844i2c9nriss5z97rzc81xcwvzw3clwzy1qgw6wcfrsnc";
    };

    vmwareHostdProxy = fetchurl {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/proxy.xml?h=vmware-workstation";
      sha256 = "124al7ahnkr6m949yfw3qvw3zn3hdjf1v4xyxglab131c0ijb01w";
    };

    vmwareHostdVMAutostart = fetchurl {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/vmAutoStart.xml?h=vmware-workstation";
      sha256 = "0v8fmpcynw6q7z8ppcyfrdsiiliwa0ds0xz6wm6160v1pj62llmd";
    };

    vmwarePAMConfig = fetchurl {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/pam.d-vmware-authd?h=vmware-workstation";
      sha256 = "19rczamxwpm17ipfwa1brshhmdhyshc8x62xjrw520llzsis02nm";
    };

    vmwareVixBootstrapConfig = fetchurl {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/vmware-vix-bootstrap?h=vmware-workstation";
      sha256 = "0hd1zvdpa8jkwqsrcr2n31cc9fd4xf8kijbz3in4dbkk9szrh5ns";
    };

    unpackPhase = ''
      # unpack installer
      csplit --suppress-matched -q $src /^exit$/ '{*}'
      tar xzf xx01 2>/dev/null || true
      mv install/vmware-installer vmware-installer
      rm -rf install/ xx0{0,1}

      # unpack components
      echo '
        ebegin(){
          echo "$1"
        }
        eend(){
          echo OK
        }
        source "${vmwareBundleUnpacker}"
        export T="$PWD"

        for COMP in \
          vmware-network-editor \
          vmware-network-editor-ui \
          vmware-ovftool \
          vmware-player-app \
          vmware-player-setup \
          vmware-tools-linux \
          vmware-tools-linuxPreGlibc25 \
          vmware-tools-netware \
          vmware-tools-solaris \
          vmware-tools-windows \
          vmware-tools-winPre2k \
          vmware-tools-winPreVista \
          vmware-usbarbitrator \
          vmware-virtual-printer \
          vmware-vix-core \
          vmware-vix-lib-Workstation1500 \
          vmware-vmx \
          vmware-vprobe \
          vmware-workstation \
          vmware-workstation-server; \
        do
          vmware-bundle_extract-bundle-component "$src" "$COMP" "./$COMP"
        done
      ' >./extractor.sh
       bash ./extractor.sh # this script doesnt like to work unless it's running from a file
    '';

    installPhase = ''
      # determine installer version
      local vmware_installer_version=$(cat "vmware-installer/manifest.xml" | grep -oPm1 "(?<=<version>)[^<]+")

      # create directory structure
      mkdir -p \
        $out/etc/{cups,pam.d,modprobe.d,profile.d,thnuclnt,vmware,vmware-installer} \
        $out/{bin,share} \
        $out/include/vmware-vix \
        $out/lib/{vmware/{setup,lib/libvmware-vim-cmd.so},vmware-vix,vmware-ovftool,vmware-installer/$vmware_installer_version,cups/filter,module-load.d} \
        $out/share/{doc/vmware-vix,licenses/vmware-workstation}

      # copy bin/
      cp -r \
        vmware-workstation/bin/* \
        vmware-vmx/{,s}bin/* \
        vmware-vix-core/bin/* \
        vmware-vprobe/bin/* \
        vmware-workstation-server/{vmware-hostd,vmware-vim-cmd,vmware-wssc-adminTool} \
        vmware-player-app/bin/* \
        $out/bin

      # copy etc/cups
      cp -r \
        vmware-player-app/etc/cups/* \
        $out/etc/cups

      # copy etc/thnuclnt
      cp -r \
        vmware-player-app/extras/.thnumod \
        $out/etc/thnuclnt

      # copy etc/vmware
      cp -r \
        vmware-vmx/extra/modules.xml \
        vmware-workstation-server/config/etc/vmware/* \
        vmware-workstation-server/etc/vmware/* \
        $out/etc/vmware

      # copy include/vmware-vix
      cp -r \
        vmware-vix-core/include/* \
        $out/include/vmware-vix

      # copy lib/cups/filter
      cp -r \
        vmware-player-app/extras/thnucups \
        $out/lib/cups/filter

      # copy lib/vmware
      cp -r \
        vmware-workstation/lib/* \
        vmware-player-app/lib/* \
        vmware-vmx/{lib/*,roms} \
        vmware-vprobe/lib/* \
        vmware-workstation-server/{bin,lib,hostd} \
        vmware-usbarbitrator/bin \
        vmware-network-editor/lib \
        $out/lib/vmware

      # copy lib/vmware/setup
      cp -r \
        vmware-player-setup/vmware-config \
        $out/lib/vmware/setup

      # copy lib/vmware-installer/VERSION
      cp -r \
        vmware-installer/{python,sopython,vmis,vmis-launcher,vmware-installer,vmware-installer.py} \
        $out/lib/vmware-installer/$vmware_installer_version

      # copy lib/vmware-ovftool
      cp -r \
        vmware-ovftool/* \
        $out/lib/vmware-ovftool

      # copy lib/vmware-vix
      cp -r \
        vmware-vix-lib-Workstation1500/lib/Workstation-15.0.0 \
        vmware-vix-core/{lib/*,vixwrapper-config.txt} \
        $out/lib/vmware-vix

      # copy share/
      cp -r \
        vmware-workstation/share/* \
        vmware-workstation/man \
        vmware-vmware-network-editor-ui/share/* \
        vmware-player-app/share/* \
        $out/share

      # copy share/doc/vmware-vix
      cp -r \
        vmware-vix-core/doc/* \
        $out/share/doc/vmware-vix

      # set file permissions
      chmod +x \
        $out/bin/* \
        $out/lib/vmware/bin/* \
        $out/lib/vmware/setup/* \
        $out/lib/vmware/lib/libvmware-gksu.so/gksu-run-helper \
        $out/lib/vmware-ovftool/{ovftool,ovftool.bin} \
        $out/lib/vmware-installer/$vmware_installer_version/{vmware-installer,vmis-launcher} \
        $out/lib/cups/filter/* \
        $out/lib/vmware-vix/setup/* \
        $out/etc/thnuclnt/.thnumod
      chmod 700 $out/etc/vmware/ssl
      chmod 600 $out/etc/vmware/ssl/*

      # create symlinks (replicate installer) - lib/vmware/bin
      for link in \
        licenseTool \
        vmplayer \
        vmware \
        vmware-app-control \
        vmware-enter-serial \
        vmware-fuseUI \
        vmware-gksu \
        vmware-hostd \
        vmware-modconfig \
        vmware-modconfig-console \
        vmware-mount \
        vmware-netcfg \
        vmware-setup-helper \
        vmware-tray \
        vmware-vim-cmd \
        vmware-vmblock-fuse \
        vmware-vprobe \
        vmware-virtual-printer \
        vmware-wssc-adminTool \
        vmware-zenity
      do
        ln -s $out/lib/vmware/bin/appLoader $out/lib/vmware/bin/$link
      done

      # create symlinks (replicate installer) - bin
      for link in \
        vmware-fuseUI \
        vmware-mount \
        vmware-netcfg \
        vmware-usbarbitrator
      do
        ln -s $out/lib/vmware/bin/$link $out/bin/$link
      done

      # create symlinks (replicate installer) - misc
      ln -s $out/lib/vmware/bin/appLoader $out/bin/vmrest
      ln -s $out/lib/vmware/icu $out/etc/vmware/icu
      ln -s $out/lib/vmware/lib/diskLibWrapper.so/diskLibWrapper.so $out/lib/diskLibWrapper.so
      ln -s $out/lib/vmware/lib/libvmware-hostd.so/libvmware-hostd.so $out/lib/vmware/lib/libvmware-vim-cmd.so/libvmware-vim-cmd.so
      ln -s $out/lib/vmware-ovftool/ovftool $out/bin/ovftool
      ln -s $out/lib/vmware-vix/libvixAllProducts.so $out/lib/libvixAllProducts.so

      # create database of vmware guest tools and copy them in to place (avoids vmware having to fetch them later)
      local database_filename=$out/etc/vmware-installer/database
      touch $database_filename
      sqlite3 "$database_filename" "CREATE TABLE settings(key VARCHAR PRIMARY KEY, value VARCHAR NOT NULL, component_name VARCHAR NOT NULL);"
      sqlite3 "$database_filename" "INSERT INTO settings(key,value,component_name) VALUES('db.schemaVersion','2','vmware-installer');"
      sqlite3 "$database_filename" "CREATE TABLE components(id INTEGER PRIMARY KEY, name VARCHAR NOT NULL, version VARCHAR NOT NULL, buildNumber INTEGER NOT NULL, component_core_id INTEGER NOT NULL, longName VARCHAR NOT NULL, description VARCHAR, type INTEGER NOT NULL);"      

      for isoimage in linux linuxPreGlibc25 netware solaris windows winPre2k winPreVista; do
        local isoversion=$(ls -1 vmware-tools-$isoimage/.installer)
        sqlite3 "$database_filename" "INSERT INTO components(name,version,buildNumber,component_core_id,longName,description,type) VALUES(\"vmware-tools-$isoimage\",\"$isoversion\",\"${version}\",1,\"$isoimage\",\"$isoimage\",1);"
        install -Dm 644 vmware-tools-$isoimage/$isoimage.iso $out/lib/vmware/isoimages/$isoimage.iso
      done
      for isoimage in Linux Windows; do
        install -Dm 644 vmware-virtual-printer/VirtualPrinter-$isoimage.iso $out/lib/vmware/isoimages/VirtualPrinter-$isoimage.iso
      done

      # install licenses
      install -Dm 644 vmware-workstation/doc/EULA $out/share/doc/vmware-workstation/EULA
      ln -s $out/share/doc/vmware-workstation/EULA "$out/share/licenses/vmware-workstation/VMware Workstation - EULA.txt"
      ln -s $out/lib/vmware-ovftool/vmware.eula "$out/share/licenses/vmware-workstation/VMware OVF Tool - EULA.txt"
      install -Dm 644 vmware-workstation/doc/open_source_licenses.txt "$out/share/licenses/vmware-workstation/VMware Workstation open source license.txt"
      install -Dm 644 vmware-workstation/doc/ovftool_open_source_licenses.txt "$out/share/licenses/vmware-workstation/VMware OVF Tool open source license.txt"
      install -Dm 644 vmware-vix-core/open_source_licenses.txt "$out/share/licenses/vmware-workstation/VMware VIX open source license.txt"
      rm -f $out/lib/vmware-ovftool/{vmware-eula.rtf,open_source_licenses.txt,manifest.xml}

      # install config files
      install -d -m 755 $out/lib/vmware-installer/$vmware_installer_version/{lib/lib,artwork}
      install -Dm 644 vmware-vmx/extra/modules.xml $out/lib/vmware/modules/modules.xml
      install -Dm 644 vmware-installer/bootstrap $out/etc/vmware-installer/bootstrap
      install -Dm 644 $vmwareVixBootstrapConfig $out/etc/vmware-vix/bootstrap
      install -Dm 644 $vmwareBootstrapConfig $out/etc/vmware/bootstrap
      install -Dm 644 $vmwareConfig $out/etc/vmware/config
      install -Dm 644 $vmwareHostdConfig $out/etc/vmware/hostd/config.xml
      install -Dm 644 $vmwareHostdDatastores $out/etc/vmware/hostd/datastores.xml
      install -Dm 644 $vmwareHostdEnvironments $out/etc/vmware/hostd/environments.xml
      install -Dm 644 $vmwareHostdProxy $out/etc/vmware/hostd/proxy.xml
      install -Dm 644 $vmwareHostdVMAutostart $out/etc/vmware/hostd/vmAutoStart.xml
      install -Dm 644 $vmwarePAMConfig $out/etc/pam.d/vmware-authd

      # remove unused application definitions (we create our own)
      rm -rf $out/share/{applications,icons}

      # replace placeholder vars with real paths
      for file in gtk-3.0/gdk-pixbuf.loaders; do
        sed -i 's,@@LIBCONF_DIR@@,/usr/lib/vmware/libconf,g' $out/lib/vmware/libconf/etc/$file
      done
      sed -i 's,@@AUTHD_PORT@@,902,' $out/lib/vmware/hostd/docroot/client/clients.xml
      sed \
        -e "s,@@VERSION@@,$vmware_installer_version," \
        -e "s,@@VMWARE_INSTALLER@@,/usr/lib/vmware-installer/$vmware_installer_version," \
        -i $out/etc/vmware-installer/bootstrap

      # patch



