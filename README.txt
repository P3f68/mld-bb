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
            /recipes-core                   ( Basis Packete der MLD)
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
    /meta-openembedded
    /openembedded-core
    /sources                                ( Temp Verzeichnis der Source Downloads )  
    
    
3.) Tipps u. Tricks u. Linksammlung
========================================
3.1) wenn Änderungen im meta-mld-source geamcht worden sind dann
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
        
