1.) Build-Umgebung aufsetzten
====================================

1.1.) Je nach Distribution alle notwendigen Pakete instalieren

- Ubuntu and Debian

     $ sudo apt-get install gawk wget git-core diffstat unzip texinfo gcc-multilib \
     build-essential chrpath socat libsdl1.2-dev xterm
                        

- Fedora

     $ sudo dnf install gawk make wget tar bzip2 gzip python unzip perl patch \
     diffutils diffstat git cpp gcc gcc-c++ glibc-devel texinfo chrpath \
     ccache perl-Data-Dumper perl-Text-ParseWords perl-Thread-Queue socat \
     findutils which SDL-devel xterm perl-bignum
                        

- OpenSUSE

     $ sudo zypper install python gcc gcc-c++ git chrpath make wget python-xml \
     diffstat makeinfo python-curses patch socat libSDL-devel xterm
                        

- CentOS

     $ sudo yum install gawk make wget tar bzip2 gzip python unzip perl patch \
     diffutils diffstat git cpp gcc gcc-c++ glibc-devel texinfo chrpath socat \
     perl-Data-Dumper perl-Text-ParseWords perl-Thread-Queue SDL-devel xterm
                        
                        

1.2) Git-Repository auschecken 
     git clone http://5.9.147.200:8765/MLD/mld-bb.git
   
1.2) Ins Verzeichnis wechseln, in dem das Repository ausgechekct wurde
     cd mld-bb

1.3) Update auf alle Submodule(Sub-Repositorys machen)
     make update
     
1.4) Danach kann dann das Build(make) für ein Ziel Hardware gemacht werden
     MACHINE=amd64 DISTRO=MLD DISTRO_TYPE=release make image
     oder
     MACHINE=rpi DISTRO=MLD DISTRO_TYPE=release make image
     MACHINE=rpi2 DISTRO=MLD DISTRO_TYPE=release make image
     MACHINE=rpi3 DISTRO=MLD DISTRO_TYPE=release make image
     MACHINE=bpi DISTRO=MLD DISTRO_TYPE=release make image
     MACHINE=cubietruck DISTRO=MLD DISTRO_TYPE=release make image
     MACHINE=cubieboard DISTRO=MLD DISTRO_TYPE=release make image
     MACHINE=cubieboard2 DISTRO=MLD DISTRO_TYPE=release make image
     
1.4.1) Oder um ein einzelnes Recipes zu bauen
       
       z.B.: MACHINE=amd64 DISTRO=MLD DISTRO_TYPE=release pkg=vdr make pkg

     
     
1.5) die gebauten imges liegen dann in /builds/MLD/release/<MACHINE>/tmp/delpoy/images
     

2.) Verzeichnis-Struktur
====================================

/mld-bb
    /bitbake
    /builds                                 ( Build Verzeichnis der unterschiedlichen Images )
    /meta-local
    /meta-mld-souce                         ( Die MLD Sourcen )
        /conf
            /distro
        /meta-hardware                      ( alle mÃ¶glichen Ziel-Hardware ) 
            /meta-amlogic                   ( wetekplay )    
            /meta-rpi                       ( raspberrypi, raspberrypi2, raspberrypi3 ) 
            /meta-sunxi                     ( cubieboard, cubietruck ) 
            /meta-x86                       ( i386, amd64)
        /meta-system
            /recipes-audio
            /recipes-common                 ( Treiber )
            /recipes-core                   ( Basis Pakete der MLD)
                /base
                /busybox
                /exlinux
                /image                      ( 
                                              enthÃ¤lt die zusammenstellungen der verschiedene Images(builds) 
                                              MLD-image-rpi.bb (raspberrypi)
                                              MLD-image-x86.bb (i386, amd64)
                                            )  
                /init
                /install
                /network
                /packagegroups
                /psplash
            /recipes-multimedia             ( z.B.: ffmpeg)    
            /recipes-tools                  ( Alle zusätlichen Tools, z.B.: shelinabox)    
            /recipes-vdr                    ( Alle vdr Pakete )
                /vdr
                /vdr-font-sysmbols
                .
                .
                /vdr-plugin-svdrpservice
    /meta-openembedded
    /openembedded-core
    /sources                                ( Temp Verzeichnis der Source Downloads )  
    
    
3.) Tipps u. Tricks u. Linksammlung
========================================
3.1) wenn Änderungen im meta-mld-source geamcht worden sind dann im meta-mld-source Verzecihnis
       git commit --all
       oder
       git add 'wenn neue Dateien oder Verzeichnisse hinzugekommen sind'
       
       git push
       
       
       danach im root 'meta-bb'
       git commit --all
       oder
       git add 'wenn neue Dateien oder Verzeichnisse hinzugekommen sind'
       
       git push
       
3.2) openembedded MetaIndex Recipes
     http://layers.openembedded.org/layerindex/branch/master/layers/
     
3.2.1) Openembedded Variablen
       http://www.crashcourse.ca/wiki/index.php/OE_variable_glossary
     
3.3)
do_build                       Default task for a recipe - depends on all other normal tasks required to 'build' a recipe
do_bundle_initramfs            Combines an initial ramdisk image and kernel together to form a single image
do_checkuri                    Validates the SRC_URI value
do_checkuriall                 Validates the SRC_URI value for all recipes required to build a target
do_clean                       Removes all output files for a target
do_cleanall                    Removes all output files, shared state cache, and downloaded source files for a target
do_cleansstate                 Removes all output files and shared state cache for a target
do_compile                     Compiles the source in the compilation directory
do_configure                   Configures the source by enabling and disabling any build-time and configuration options for the software being built
do_devpyshell                  
do_devshell                    Starts a shell with the environment set up for development/debugging
do_fetch                       Fetches the source code
do_fetchall                    Fetches all remote sources required to build a target
do_install                     Copies files from the compilation directory to a holding area
do_listtasks                   Lists all defined tasks for a target
do_package                     Analyzes the content of the holding area and splits it into subsets based on available packages and files
do_package_setscene            Analyzes the content of the holding area and splits it into subsets based on available packages and files (setscene version)
do_package_write_ipk           Creates the actual IPK packages and places them in the Package Feed area
do_package_write_ipk_setscene  Creates the actual IPK packages and places them in the Package Feed area (setscene version)
do_packagedata                 Creates package metadata used by the build system to generate the final packages
do_packagedata_setscene        Creates package metadata used by the build system to generate the final packages (setscene version)
do_patch                       Locates patch files and applies them to the source code
do_populate_lic                Writes license information for the recipe that is collected later when the image is constructed
do_populate_lic_setscene       Writes license information for the recipe that is collected later when the image is constructed (setscene version)
do_populate_sdk                Creates the file and directory structure for an installable SDK
do_populate_sysroot            Copies a subset of files installed by do_install into the sysroot in order to make them available to other recipes
do_populate_sysroot_setscene   Copies a subset of files installed by do_install into the sysroot in order to make them available to other recipes (setscene version)
do_rootfs                      Creates the root filesystem (file and directory structure) for an image
do_unpack                      Unpacks the source code into a working directory
NOTE: Tasks Summary: Attempted 1 tasks of which 0 didn't need to be rerun and all succeeded.

        
3.4) 

IMAGE_INSTALL == rootfs

3.5) Bitbake Variablen
Variable name   Definition              Typical value
prefix          /usr                    /usr
base_prefix     (empty)                 (empty)
exec_prefix     ${base_prefix}          (empty)
base_bindir     ${base_prefix}/bin      /bin
base_sbindir    ${base_prefix}/sbin     /sbin
base_libdir     ${base_prefix}/lib      /lib
datadir         ${prefix}/share         /usr/share
sysconfdir      /etc                    /etc
localstatedir   /var                    /var
infodir         ${datadir}/info         /usr/share/info
mandir          ${datadir}/man          /usr/share/man
docdir          ${datadir}/doc          /usr/share/doc
servicedir      /srv                    /srv
bindir          ${exec_prefix}/bin      /usr/bin
sbindir         ${exec_prefix}/sbin     /usr/sbin
libexecdir      ${exec_prefix}/libexec  /usr/libexec
libdir          ${exec_prefix}/lib      /usr/lib
includedir      ${exec_prefix}/include  /usr/include
palmtopdir      ${libdir}/opie          /usr/lib/opie
palmqtdir       ${palmtopdir}           /usr/lib/opie
