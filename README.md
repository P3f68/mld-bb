1.) build-enviroment
====================================


1.1) git clone http://5.9.147.200:8765/MLD/mld-bb.git
1.2) cd mld-bb
1.3) make update
1.4) MACHINE=amd64 DISTRO=MLD DISTRO_TYPE=release make image


2.) Verzeichnis-Struktur
====================================

/mld-bb
    /bitbake
    /builds                                 ( Build Verzeichnis der unterschiedlichen Images )
    /meta-local
    /meta-mld-souce                         ( Die MLD Sourcen )
        /conf
            /distro
        /meta-hardware                      ( alle möglichen Ziel-Hardware ) 
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
                                              enthält die zusammenstellungen der verschiedene Images(builds) 
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

