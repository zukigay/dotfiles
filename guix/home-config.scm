(use-modules (gnu)
             (gnu home)
             (gnu home services)
             (gnu home services desktop)
             (gnu packages freedesktop)
             (gnu home services sound))

(home-environment
  (services 
  (list 
    (service
     (service-type
      (name 'home-xdg-desktop-portal)
      (extensions
       (list
        (service-extension
         home-profile-service-type
         (const (list xdg-desktop-portal
                      xdg-desktop-portal-gtk
                      xdg-desktop-portal-wlr)))
        (service-extension
         home-xdg-configuration-files-service-type
         (const `(("xdg-desktop-portal/portals.conf" ,(local-file "./portals.conf")))))))
    (default-value #t)
    (description #f)))
    (service home-pipewire-service-type
             (home-pipewire-configuration
               (enable-pulseaudio? #t)
               ))
    (service home-dbus-service-type))))
